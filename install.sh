#!/usr/bin/env bash
# BTR-AF Installer
# Supports: OpenCode, Claude Code, VS Code, macOS, Linux
# Dependencies: None (uses only POSIX shell builtins + curl/wget)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO="btr-supply/agentic-framework"
GITHUB_API="https://api.github.com/repos/${REPO}"
TARGET="opencode"  # Default target
SCOPE="local"    # Default scope: local or global
VERSION=""

# Utility functions
info() { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$1"; }
error() { printf "${RED}✗${NC} %s\n" "$1" >&2; exit 1; }
log() { printf "${BLUE}  →${NC} %s\n" "$1"; }

# Show usage
show_usage() {
    cat << EOF
BTR-AF Installer

Usage: $0 [OPTIONS] [VERSION]

Options:
  --target=TARGET    Installation target: 'opencode', 'claude', or 'vscode' (default: opencode)
  --global           Install globally to user home directory (default: local)
  --help             Show this help message

Arguments:
  VERSION            Version tag to install (default: latest release)

Examples:
  $0                          # Install latest for OpenCode locally (.opencode/agent/)
  $0 --target=claude          # Install latest for Claude Code locally
  $0 --target=vscode          # Install latest for VS Code locally
  $0 --global                 # Install latest globally
  $0 v1.0.0                   # Install v1.0.0 locally

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

# Merge IntraCom MCP config into existing opencode.json
merge_opencode_config() {
    local config_file="$1"
    local intracom_mcp='
  "intracom": {
    "type": "local",
    "command": ["bun", "run", "../agentic-intracom/src/index.ts"],
    "environment": {
      "INTRACOM_STORAGE": ".opencode/intracom-state.json"
    },
    "enabled": true
  }'

    # Check if intracom already exists
    if grep -q '"intracom":' "$config_file" 2>/dev/null; then
        log "IntraCom MCP already configured in $config_file"
        return 0
    fi

    # Backup existing config
    log "Backing up existing $config_file to $config_file.bak"
    cp "$config_file" "$config_file.bak"

    # Check if file has mcp section
    if grep -q '"mcp":' "$config_file" 2>/dev/null; then
        # Insert intracom into existing mcp section
        log "Merging IntraCom MCP into existing mcp section..."

        # Use awk to insert intracom before closing brace of mcp section
        awk -v intracom="$intracom_mcp" '
            /"mcp":\s*\{/ {
                in_mcp=1
                print
                next
            }
            in_mcp && /^\s*\}/ {
                print intracom
                in_mcp=0
            }
            { print }
        ' "$config_file.bak" > "$config_file"

        rm -f "$config_file.bak"
        info "Merged IntraCom MCP into $config_file"
    else
        # No mcp section, add it
        log "Adding mcp section with IntraCom to $config_file..."

        # Insert mcp section before tools or at end
        awk -v intracom="$intracom_mcp" '
            /"tools":\s*\{/ {
                print "  \"mcp\": {"
                print intracom
                print "  },"
                in_tools=1
                next
            }
            { print }
            END {
                if (!in_tools) {
                    print "  \"mcp\": {"
                    print intracom
                    print "  },"
                }
            }
        ' "$config_file.bak" > "$config_file"

        rm -f "$config_file.bak"
        info "Added mcp section with IntraCom to $config_file"
    fi

    # Ensure tools section includes intracom
    if grep -q '"tools":' "$config_file" 2>/dev/null; then
        if ! grep -q '"intracom\*":' "$config_file" 2>/dev/null; then
            log "Adding intracom tools to existing tools section..."
            awk '
                /"tools":\s*\{/ {
                    in_tools=1
                    print
                    print "    \"intracom*\": true,"
                    next
                }
                in_tools && /^\s*\}/ && !added {
                    print "    \"intracom*\": true"
                    added=1
                }
                { print }
            ' "$config_file" > "$config_file.tmp"
            mv "$config_file.tmp" "$config_file"
            info "Added intracom tools to $config_file"
        fi
    fi
}

# Create new opencode.json (only if not exists)
create_opencode_config() {
    cat > opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "intracom": {
      "type": "local",
      "command": ["bun", "run", "../agentic-intracom/src/index.ts"],
      "environment": {
        "INTRACOM_STORAGE": ".opencode/intracom-state.json"
      },
      "enabled": true
    }
  },
  "tools": {
    "intracom*": true
  }
}
EOF
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
    if [ "$TARGET" != "opencode" ] && [ "$TARGET" != "claude" ] && [ "$TARGET" != "vscode" ]; then
        error "Invalid target: $TARGET. Must be 'opencode', 'claude', or 'vscode'"
    fi

    # Set installation directories based on target and scope
    if [ "$TARGET" = "opencode" ]; then
        if [ "$SCOPE" = "global" ]; then
            AGENT_DIR="${HOME}/.config/opencode/agent"
            INSTALL_NAME="OpenCode (global)"
        else
            AGENT_DIR=".opencode/agent"
            INSTALL_NAME="OpenCode (local)"
        fi
    elif [ "$TARGET" = "claude" ]; then
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
            INSTALL_NAME="VS Code (global)"
        else
            AGENT_DIR=".vscode/agents/btr-af"
            INSTALL_NAME="VS Code (local)"
        fi
    fi

    echo "BTR-AF Installer for $INSTALL_NAME"
    echo "===================================="
    echo ""

    # Check for existing installation
    if [ -d "$AGENT_DIR" ] && [ -n "$(ls -A "$AGENT_DIR" 2>/dev/null)" ]; then
        EXISTING_AGENTS=$(ls -1 "$AGENT_DIR" 2>/dev/null | wc -l | tr -d ' ')
        warn "Found existing installation with $EXISTING_AGENTS agent(s)"
        log "Agent directory: $AGENT_DIR"
        log "Updating to version: ${VERSION:-latest}"
        echo ""
    fi

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
    log "Creating installation directory: $AGENT_DIR"
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

    # Install based on target
    if [ "$TARGET" = "opencode" ]; then
        # For OpenCode: copy .opencode/agent/*.md files
        info "Installing agents for OpenCode..."
        if [ -d "${EXTRACTED_DIR}/.opencode/agent" ]; then
            # Count new agents
            NEW_AGENTS=$(ls -1 "${EXTRACTED_DIR}/.opencode/agent/"*.md 2>/dev/null | wc -l | tr -d ' ')
            log "Found $NEW_AGENTS agent(s) to install"

            # Copy agents (overwrite existing)
            cp "${EXTRACTED_DIR}/.opencode/agent/"*.md "$AGENT_DIR/" 2>/dev/null || true

            INSTALLED=$(ls -1 "$AGENT_DIR/"*.md 2>/dev/null | wc -l | tr -d ' ')
            info "Agents installed: $INSTALLED agent(s) in $AGENT_DIR"
        fi

        # Handle opencode.json (merge, don't overwrite)
        if [ "$SCOPE" = "local" ]; then
            if [ -f "opencode.json" ]; then
                log "Existing opencode.json found, merging IntraCom configuration..."
                merge_opencode_config "opencode.json"
            else
                log "Creating new opencode.json..."
                create_opencode_config
                info "Created: opencode.json"
            fi
        fi

    elif [ "$TARGET" = "claude" ]; then
        # For Claude Code: convert .agent.md to .md files and install
        info "Installing agents for Claude Code..."
        for agent_file in "${EXTRACTED_DIR}/agents/"*.agent.md; do
            if [ -f "$agent_file" ]; then
                basename=$(basename "$agent_file" .agent.md)
                # Use awk for portable extraction (macOS + Linux compatible)
                # Extract YAML frontmatter including --- delimiters
                awk '
                    /^---$/ {
                        if (++count == 1) { print; next }
                        if (count == 2) { print; exit }
                    }
                    count == 1 { print }
                ' "$agent_file" > "$AGENT_DIR/${basename}.md"
            fi
        done
        INSTALLED=$(ls -1 "$AGENT_DIR/"*.md 2>/dev/null | wc -l | tr -d ' ')
        info "Agents installed: $INSTALLED agent(s) in $AGENT_DIR"

        # Copy workflows
        if [ -n "$WORKFLOW_DIR" ] && [ -d "${EXTRACTED_DIR}/workflows" ]; then
            mkdir -p "$WORKFLOW_DIR"
            cp -r "${EXTRACTED_DIR}/workflows/"* "$WORKFLOW_DIR/"
            info "Workflows updated in: $WORKFLOW_DIR"
        fi

    else
        # For VS Code: copy .agent.md files to .github/agents/
        mkdir -p ".github/agents"
        for agent_file in "${EXTRACTED_DIR}/agents/"*.agent.md; do
            if [ -f "$agent_file" ]; then
                basename=$(basename "$agent_file" .agent.md)
                cp "$agent_file" ".github/agents/${basename}.agent.md"
            fi
        done
        INSTALLED=$(ls -1 ".github/agents/"*.agent.md 2>/dev/null | wc -l | tr -d ' ')
        info "Agents installed: $INSTALLED agent(s) in .github/agents/"
    fi

    # Installation complete
    echo ""
    info "Installation complete!"
    echo ""

    if [ "$TARGET" = "opencode" ]; then
        echo "Next steps:"
        echo "  1. Install IntraCom:"
        echo "     git clone https://github.com/btr-supply/agentic-intracom.git ../agentic-intracom"
        echo "  2. Install IntraCom dependencies:"
        echo "     cd ../agentic-intracom && bun install"
        echo "  3. Install OpenCode:"
        echo "     curl -fsSL https://opencode.ai/install | bash"
        if [ "$SCOPE" = "global" ]; then
            echo "  4. Agents installed globally in ~/.config/opencode/agent/"
        else
            echo "  4. Run: opencode (in $(pwd))"
        fi
        echo "  5. Use @sibyl to orchestrate the elite team"
    elif [ "$TARGET" = "claude" ]; then
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
