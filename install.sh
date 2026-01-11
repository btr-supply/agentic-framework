#!/usr/bin/env bash
# BTR-AF Installer
# Supports: Claude Code, VS Code, macOS, Linux
# Dependencies: None (uses only POSIX shell builtins + curl/wget)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
REPO="btr-supply/agentic-framework"
GITHUB_API="https://api.github.com/repos/${REPO}"
TARGET="claude"  # Default target
SCOPE="local"    # Default scope: local or global
VERSION=""

# Utility functions
info() { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$1"; }
error() { printf "${RED}✗${NC} %s\n" "$1" >&2; exit 1; }

# Show usage
show_usage() {
    cat << EOF
BTR-AF Installer

Usage: $0 [OPTIONS] [VERSION]

Options:
  --target=TARGET    Installation target: 'claude' or 'vscode' (default: claude)
  --global           Install globally to user home directory (default: local)
  --help             Show this help message

Arguments:
  VERSION            Version tag to install (default: latest release)

Examples:
  $0                          # Install latest locally (.claude/agents/)
  $0 --global                 # Install latest globally (~/.claude/agents/)
  $0 --target=vscode          # Install latest to VS Code locally
  $0 v1.0.0                   # Install v1.0.0 locally
  $0 --global v1.0.0          # Install v1.0.0 globally

EOF
    exit 0
}

# Check if command exists
has_command() {
    command -v "$1" >/dev/null 2>&1
}

# Download file using curl or wget
download() {
    local url="$1"
    local output="$2"

    if has_command curl; then
        curl -fsSL "$url" -o "$output"
    elif has_command wget; then
        wget -q "$url" -O "$output"
    else
        error "Neither curl nor wget found. Please install one of them."
    fi
}

# Get latest release tag
get_latest_tag() {
    local tag
    if has_command curl; then
        tag=$(curl -fsSL "${GITHUB_API}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
    elif has_command wget; then
        tag=$(wget -qO- "${GITHUB_API}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
    else
        error "Neither curl nor wget found."
    fi
    echo "$tag"
}

# Main installation
main() {
    # Parse arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            --target=*)
                TARGET="${1#*=}"
                shift
                ;;
            --global)
                SCOPE="global"
                shift
                ;;
            --help)
                show_usage
                ;;
            *)
                VERSION="$1"
                shift
                ;;
        esac
    done

    # Validate target
    if [ "$TARGET" != "claude" ] && [ "$TARGET" != "vscode" ]; then
        error "Invalid target: $TARGET. Must be 'claude' or 'vscode'"
    fi

    # Set installation directories based on target and scope
    if [ "$TARGET" = "claude" ]; then
        if [ "$SCOPE" = "global" ]; then
            AGENT_DIR="${HOME}/.claude/agents"
            WORKFLOW_DIR="${HOME}/.claude/workflows/btr-af"
            INSTALL_NAME="Claude Code (global)"
        else
            AGENT_DIR=".claude/agents"
            WORKFLOW_DIR=".claude/workflows/btr-af"
            INSTALL_NAME="Claude Code (local)"
        fi
    else
        if [ "$SCOPE" = "global" ]; then
            AGENT_DIR="${HOME}/.vscode/agents/btr-af"
            WORKFLOW_DIR=""  # VS Code doesn't use workflows directory
            INSTALL_NAME="VS Code (global)"
        else
            AGENT_DIR=".vscode/agents/btr-af"
            WORKFLOW_DIR=""  # VS Code doesn't use workflows directory
            INSTALL_NAME="VS Code (local)"
        fi
    fi

    echo "BTR-AF Installer for $INSTALL_NAME"
    echo "===================================="
    echo ""

    # Get version
    info "Fetching latest version..."
    if [ -z "$VERSION" ]; then
        VERSION=$(get_latest_tag)
    fi
    if [ -z "$VERSION" ]; then
        VERSION="main"
        warn "Could not determine latest version, using 'main' branch"
    fi
    info "Installing version: $VERSION"
    info "Target: $INSTALL_NAME"

    # Create directory
    info "Creating installation directory..."
    mkdir -p "$AGENT_DIR"

    # Download agents
    info "Downloading agent files..."
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT

    # Download repository as tarball
    TARBALL_URL="https://github.com/${REPO}/archive/${VERSION}.tar.gz"
    download "$TARBALL_URL" "${TEMP_DIR}/repo.tar.gz"

    # Extract agents directory
    tar -xzf "${TEMP_DIR}/repo.tar.gz" -C "$TEMP_DIR"

    # Find the extracted directory
    EXTRACTED_DIR=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "agentic-framework-*" | head -n 1)
    if [ -z "$EXTRACTED_DIR" ]; then
        error "Failed to extract repository"
    fi

    # Create installation directories
    mkdir -p "$AGENT_DIR"

    # Convert and install agent files based on target
    if [ "$TARGET" = "claude" ]; then
        # For Claude Code: convert .agent.md to .md files and install
        info "Converting agents for Claude Code..."
        for agent_file in "${EXTRACTED_DIR}/agents/"*.agent.md; do
            if [ -f "$agent_file" ]; then
                basename=$(basename "$agent_file" .agent.md)
                # Extract agent name from frontmatter and create Claude-compatible format
                sed -n '/^---$/,/^---$/{p;/^---$/q}' "$agent_file" > "${TEMP_DIR}/frontmatter.tmp"
                sed '1{/^---$/d};/^---$/d' "$agent_file" > "${TEMP_DIR}/body.tmp"

                # Convert tools to Claude format
                sed -i.bak 's/^tools:$/tools: Read, Write, Edit, Bash, Glob, Grep/' "${TEMP_DIR}/frontmatter.tmp"
                rm -f "${TEMP_DIR}/frontmatter.tmp.bak"

                # Write Claude-compatible agent file
                cat "${TEMP_DIR}/frontmatter.tmp" > "$AGENT_DIR/${basename}.md"
                echo "" >> "$AGENT_DIR/${basename}.md"
                cat "${TEMP_DIR}/body.tmp" >> "$AGENT_DIR/${basename}.md"
            fi
        done
        info "Agents installed to: $AGENT_DIR"
    else
        # For VS Code: copy .agent.md files to .github/agents/
        mkdir -p ".github/agents"
        for agent_file in "${EXTRACTED_DIR}/agents/"*.agent.md; do
            if [ -f "$agent_file" ]; then
                basename=$(basename "$agent_file" .agent.md)
                cp "$agent_file" ".github/agents/${basename}.agent.md"
            fi
        done
        info "Agents installed to: .github/agents/"
    fi

    # Copy workflows (Claude Code only)
    if [ "$TARGET" = "claude" ] && [ -n "$WORKFLOW_DIR" ] && [ -d "${EXTRACTED_DIR}/workflows" ]; then
        mkdir -p "$WORKFLOW_DIR"
        cp -r "${EXTRACTED_DIR}/workflows/"* "$WORKFLOW_DIR/"
        info "Workflows installed to: $WORKFLOW_DIR"
    fi

    # Installation complete
    echo ""
    info "Installation complete!"
    echo ""

    if [ "$TARGET" = "claude" ]; then
        echo "Next steps:"
        echo "  1. Restart Claude Code or reload your IDE"
        if [ "$SCOPE" = "global" ]; then
            echo "  2. Agents installed globally in ~/.claude/agents/"
        else
            echo "  2. Agents installed locally in $(pwd)/.claude/agents/"
        fi
        echo "  3. Use @sibyl to orchestrate the elite team"
    else
        echo "Next steps:"
        echo "  1. Restart VS Code or reload the window"
        if [ "$SCOPE" = "global" ]; then
            echo "  2. Agents installed globally in ~/.vscode/agents/btr-af/"
        else
            echo "  2. Agents installed locally in $(pwd)/.vscode/agents/btr-af/"
        fi
        echo "  3. Configure your AI extension to use these agents"
    fi

    echo ""
    echo "Documentation: https://github.com/${REPO}"
}

main "$@"
