#!/usr/bin/env bash
# BTR-AF Installer for Claude Code
# Supports: macOS, Linux
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
CLAUDE_DIR="${HOME}/.claude/agents/btr-af"

# Utility functions
info() { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$1"; }
error() { printf "${RED}✗${NC} %s\n" "$1" >&2; exit 1; }

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
    echo "BTR-AF Installer for Claude Code"
    echo "================================="
    echo ""

    # Get version
    info "Fetching latest version..."
    VERSION="${1:-$(get_latest_tag)}"
    if [ -z "$VERSION" ]; then
        VERSION="main"
        warn "Could not determine latest version, using 'main' branch"
    fi
    info "Installing version: $VERSION"

    # Create directory
    info "Creating installation directory..."
    mkdir -p "$CLAUDE_DIR"

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

    # Copy agent files
    if [ -d "${EXTRACTED_DIR}/agents" ]; then
        cp -r "${EXTRACTED_DIR}/agents/"* "$CLAUDE_DIR/"
        info "Agents installed to: $CLAUDE_DIR"
    else
        error "Agents directory not found in repository"
    fi

    # Copy workflows (optional)
    if [ -d "${EXTRACTED_DIR}/workflows" ]; then
        WORKFLOW_DIR="${HOME}/.claude/workflows/btr-af"
        mkdir -p "$WORKFLOW_DIR"
        cp -r "${EXTRACTED_DIR}/workflows/"* "$WORKFLOW_DIR/"
        info "Workflows installed to: $WORKFLOW_DIR"
    fi

    # Installation complete
    echo ""
    info "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Restart Claude Code or reload your IDE"
    echo "  2. Agents will appear in your .claude/agents/btr-af/ directory"
    echo "  3. Use @sibyl to orchestrate the elite team"
    echo ""
    echo "Documentation: https://github.com/${REPO}"
}

main "$@"
