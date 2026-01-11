#!/usr/bin/env bash
# BTR-AF Uninstaller
# Supports: Claude Code, VS Code, macOS, Linux

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TARGET="claude"  # Default target
SCOPE="local"    # Default scope: local or global

# BTR-AF agent names (for identification)
AGENT_NAMES=(
    "sibyl"
    "neo"
    "flynn"
    "krennic"
    "farnsworth"
    "seldon"
    "vulcan"
    "clu"
    "edna"
    "moebius"
    "scotty"
    "han"
    "elliot"
    "kusanagi"
    "smith"
    "deckard"
    "trinity"
    "jocasta"
    "draper"
)

# Utility functions
info() { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$1"; }
error() { printf "${RED}✗${NC} %s\n" "$1" >&2; exit 1; }

# Show usage
show_usage() {
    cat << EOF
BTR-AF Uninstaller

Usage: $0 [OPTIONS]

Options:
  --target=TARGET    Uninstall target: 'claude' or 'vscode' (default: claude)
  --global           Uninstall from user home directory (default: local)
  --yes              Skip confirmation prompt
  --help             Show this help message

Examples:
  $0                          # Uninstall locally (.claude/agents/)
  $0 --global                 # Uninstall globally (~/.claude/agents/)
  $0 --target=vscode          # Uninstall VS Code locally
  $0 --yes --global           # Uninstall globally without confirmation

EOF
    exit 0
}

# Remove BTR-AF agents from a directory
remove_agents() {
    local dir="$1"
    local count=0

    if [ ! -d "$dir" ]; then
        return 0
    fi

    for agent in "${AGENT_NAMES[@]}"; do
        if [ -f "$dir/${agent}.md" ]; then
            rm -f "$dir/${agent}.md"
            count=$((count + 1))
        fi
    done

    if [ $count -gt 0 ]; then
        info "Removed $count agent(s) from: $dir"
    fi

    # Clean up empty directory
    rmdir "$dir" 2>/dev/null || true
}

# Main uninstallation
main() {
    local SKIP_CONFIRM=false

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
            --yes|-y)
                SKIP_CONFIRM=true
                shift
                ;;
            --help)
                show_usage
                ;;
            *)
                error "Unknown option: $1. Use --help for usage."
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
            AGENT_DIR="${HOME}/.github/agents"
            WORKFLOW_DIR=""
            INSTALL_NAME="VS Code (global)"
        else
            AGENT_DIR=".github/agents"
            WORKFLOW_DIR=""
            INSTALL_NAME="VS Code (local)"
        fi
    fi

    echo "BTR-AF Uninstaller for $INSTALL_NAME"
    echo "====================================="
    echo ""

    # Check if any BTR-AF agents exist
    AGENT_COUNT=0
    for agent in "${AGENT_NAMES[@]}"; do
        if [ -f "$AGENT_DIR/${agent}.md" ] || [ -f "$AGENT_DIR/${agent}.agent.md" ]; then
            AGENT_COUNT=$((AGENT_COUNT + 1))
        fi
    done

    if [ $AGENT_COUNT -eq 0 ] && [ ! -d "$WORKFLOW_DIR" ]; then
        warn "BTR-AF agents not found"
        echo "Nothing to uninstall."
        exit 0
    fi

    # Show what will be removed
    echo "The following will be removed:"
    echo "  - $AGENT_COUNT BTR-AF agent(s) from: $AGENT_DIR"
    if [ -n "$WORKFLOW_DIR" ] && [ -d "$WORKFLOW_DIR" ]; then
        echo "  - Workflows: $WORKFLOW_DIR"
    fi
    echo ""

    # Confirmation
    if [ "$SKIP_CONFIRM" = false ]; then
        read -p "Are you sure you want to uninstall BTR-AF? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Uninstallation cancelled."
            exit 0
        fi
    fi

    # Remove agents
    remove_agents "$AGENT_DIR"

    # Also try .github/agents for VS Code format
    if [ "$TARGET" = "claude" ]; then
        if [ "$SCOPE" = "global" ]; then
            remove_agents "${HOME}/.github/agents"
        else
            remove_agents ".github/agents"
        fi
    fi

    # Remove workflows (Claude Code only)
    if [ -n "$WORKFLOW_DIR" ] && [ -d "$WORKFLOW_DIR" ]; then
        rm -rf "$WORKFLOW_DIR"
        info "Removed workflows from: $WORKFLOW_DIR"
        # Clean up empty parent
        rmdir "$(dirname "$WORKFLOW_DIR")" 2>/dev/null || true
    fi

    # Clean up empty parent directories
    if [ "$SCOPE" = "local" ]; then
        if [ "$TARGET" = "claude" ]; then
            rmdir ".claude/agents" 2>/dev/null || true
            rmdir ".claude/workflows" 2>/dev/null || true
            rmdir ".claude" 2>/dev/null || true
            rmdir ".github/agents" 2>/dev/null || true
            rmdir ".github" 2>/dev/null || true
        fi
    fi

    echo ""
    info "BTR-AF uninstalled successfully!"
    echo ""
}

main "$@"
