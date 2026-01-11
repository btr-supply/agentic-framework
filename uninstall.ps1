# BTR-AF Uninstaller (Windows)
# Supports: Claude Code, VS Code
# Requires: PowerShell 5.1+ (built-in on Windows 10+)

param(
    [ValidateSet("claude", "vscode")]
    [string]$Target = "claude",
    [switch]$Global = $false,
    [switch]$Yes = $false
)

$ErrorActionPreference = "Stop"

# Configuration
$Scope = if ($Global) { "global" } else { "local" }

# Colors
function Write-Info { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Warn { Write-Host "⚠ $args" -ForegroundColor Yellow }
function Write-Err { Write-Host "✗ $args" -ForegroundColor Red; exit 1 }

# Main uninstallation
function Main {
    # Set installation directories based on target and scope
    if ($Target -eq "claude") {
        if ($Scope -eq "global") {
            $AgentDir = Join-Path $env:USERPROFILE ".claude\agents\btr-af"
            $WorkflowDir = Join-Path $env:USERPROFILE ".claude\workflows\btr-af"
            $InstallName = "Claude Code (global)"
        } else {
            $AgentDir = ".claude\agents\btr-af"
            $WorkflowDir = ".claude\workflows\btr-af"
            $InstallName = "Claude Code (local)"
        }
    } else {
        if ($Scope -eq "global") {
            $AgentDir = Join-Path $env:USERPROFILE ".vscode\agents\btr-af"
            $WorkflowDir = $null  # VS Code doesn't use workflows directory
            $InstallName = "VS Code (global)"
        } else {
            $AgentDir = ".vscode\agents\btr-af"
            $WorkflowDir = $null  # VS Code doesn't use workflows directory
            $InstallName = "VS Code (local)"
        }
    }

    Write-Host "BTR-AF Uninstaller for $InstallName" -ForegroundColor Cyan
    Write-Host ("=" * (25 + $InstallName.Length)) -ForegroundColor Cyan
    Write-Host ""

    # Check if installation exists
    if (-not (Test-Path $AgentDir)) {
        Write-Warn "BTR-AF not found at: $AgentDir"
        Write-Host "Nothing to uninstall."
        exit 0
    }

    # Show what will be removed
    Write-Host "The following will be removed:"
    Write-Host "  - Agents: $AgentDir"
    if ($WorkflowDir -and (Test-Path $WorkflowDir)) {
        Write-Host "  - Workflows: $WorkflowDir"
    }
    Write-Host ""

    # Confirmation
    if (-not $Yes) {
        $confirmation = Read-Host "Are you sure you want to uninstall BTR-AF? (y/N)"
        if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
            Write-Host "Uninstallation cancelled."
            exit 0
        }
    }

    # Remove agents
    if (Test-Path $AgentDir) {
        Remove-Item -Path $AgentDir -Recurse -Force
        Write-Info "Removed agents from: $AgentDir"
    }

    # Remove workflows (Claude Code only)
    if ($WorkflowDir -and (Test-Path $WorkflowDir)) {
        Remove-Item -Path $WorkflowDir -Recurse -Force
        Write-Info "Removed workflows from: $WorkflowDir"
    }

    # Clean up empty parent directories
    if ($Scope -eq "local") {
        if ($Target -eq "claude") {
            if ((Test-Path ".claude\agents") -and -not (Get-ChildItem ".claude\agents")) {
                Remove-Item ".claude\agents" -Force -ErrorAction SilentlyContinue
            }
            if ((Test-Path ".claude\workflows") -and -not (Get-ChildItem ".claude\workflows")) {
                Remove-Item ".claude\workflows" -Force -ErrorAction SilentlyContinue
            }
            if ((Test-Path ".claude") -and -not (Get-ChildItem ".claude")) {
                Remove-Item ".claude" -Force -ErrorAction SilentlyContinue
            }
        } else {
            if ((Test-Path ".vscode\agents") -and -not (Get-ChildItem ".vscode\agents")) {
                Remove-Item ".vscode\agents" -Force -ErrorAction SilentlyContinue
            }
            if ((Test-Path ".vscode") -and -not (Get-ChildItem ".vscode")) {
                Remove-Item ".vscode" -Force -ErrorAction SilentlyContinue
            }
        }
    }

    Write-Host ""
    Write-Info "BTR-AF uninstalled successfully!"
    Write-Host ""
}

Main
