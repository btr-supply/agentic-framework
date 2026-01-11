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

# BTR-AF agent names (for identification)
$AgentNames = @(
    "sibyl", "neo", "flynn", "krennic", "farnsworth", "seldon",
    "vulcan", "clu", "edna", "moebius", "scotty", "han",
    "elliot", "kusanagi", "smith", "deckard", "trinity",
    "jocasta", "draper"
)

# Colors
function Write-Info { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Warn { Write-Host "⚠ $args" -ForegroundColor Yellow }
function Write-Err { Write-Host "✗ $args" -ForegroundColor Red; exit 1 }

# Remove BTR-AF agents from a directory
function Remove-Agents {
    param([string]$Dir)

    if (-not (Test-Path $Dir)) {
        return 0
    }

    $count = 0
    foreach ($agent in $AgentNames) {
        $agentPath = Join-Path $Dir "$agent.md"
        if (Test-Path $agentPath) {
            Remove-Item -Path $agentPath -Force
            $count++
        }
    }

    if ($count -gt 0) {
        Write-Info "Removed $count agent(s) from: $Dir"
    }

    # Clean up empty directory
    if (Test-Path $Dir) {
        try {
            Remove-Item $Dir -Force -ErrorAction Stop
        } catch {
            # Directory not empty, leave it
        }
    }
}

# Main uninstallation
function Main {
    # Set installation directories based on target and scope
    if ($Target -eq "claude") {
        if ($Scope -eq "global") {
            $AgentDir = Join-Path $env:USERPROFILE ".claude\agents"
            $WorkflowDir = Join-Path $env:USERPROFILE ".claude\workflows\btr-af"
            $InstallName = "Claude Code (global)"
        } else {
            $AgentDir = ".claude\agents"
            $WorkflowDir = ".claude\workflows\btr-af"
            $InstallName = "Claude Code (local)"
        }
    } else {
        if ($Scope -eq "global") {
            $AgentDir = Join-Path $env:USERPROFILE ".github\agents"
            $WorkflowDir = $null
            $InstallName = "VS Code (global)"
        } else {
            $AgentDir = ".github\agents"
            $WorkflowDir = $null
            $InstallName = "VS Code (local)"
        }
    }

    Write-Host "BTR-AF Uninstaller for $InstallName" -ForegroundColor Cyan
    Write-Host ("=" * (25 + $InstallName.Length)) -ForegroundColor Cyan
    Write-Host ""

    # Check if any BTR-AF agents exist
    $agentCount = 0
    foreach ($agent in $AgentNames) {
        if ((Test-Path (Join-Path $AgentDir "$agent.md")) -or
            (Test-Path (Join-Path $AgentDir "$agent.agent.md"))) {
            $agentCount++
        }
    }

    if ($agentCount -eq 0 -and -not (Test-Path $WorkflowDir)) {
        Write-Warn "BTR-AF agents not found"
        Write-Host "Nothing to uninstall."
        exit 0
    }

    # Show what will be removed
    Write-Host "The following will be removed:"
    Write-Host "  - $agentCount BTR-AF agent(s) from: $AgentDir"
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
    Remove-Agents -Dir $AgentDir

    # Also try .github\agents for VS Code format
    if ($Target -eq "claude") {
        if ($Scope -eq "global") {
            Remove-Agents -Dir (Join-Path $env:USERPROFILE ".github\agents")
        } else {
            Remove-Agents -Dir ".github\agents"
        }
    }

    # Remove workflows (Claude Code only)
    if ($WorkflowDir -and (Test-Path $WorkflowDir)) {
        Remove-Item -Path $WorkflowDir -Recurse -Force
        Write-Info "Removed workflows from: $WorkflowDir"
        # Clean up empty parent
        $parentDir = Split-Path $WorkflowDir
        if (Test-Path $parentDir) {
            try {
                Remove-Item $parentDir -Force -ErrorAction Stop
            } catch {
                # Directory not empty, leave it
            }
        }
    }

    # Clean up empty parent directories
    if ($Scope -eq "local") {
        if ($Target -eq "claude") {
            if ((Test-Path ".claude\agents") -and -not (Get-ChildItem ".claude\agents" -ErrorAction SilentlyContinue)) {
                Remove-Item ".claude\agents" -Force -ErrorAction SilentlyContinue
            }
            if ((Test-Path ".claude\workflows") -and -not (Get-ChildItem ".claude\workflows" -ErrorAction SilentlyContinue)) {
                Remove-Item ".claude\workflows" -Force -ErrorAction SilentlyContinue
            }
            if ((Test-Path ".claude") -and -not (Get-ChildItem ".claude" -ErrorAction SilentlyContinue)) {
                Remove-Item ".claude" -Force -ErrorAction SilentlyContinue
            }
            if ((Test-Path ".github\agents") -and -not (Get-ChildItem ".github\agents" -ErrorAction SilentlyContinue)) {
                Remove-Item ".github\agents" -Force -ErrorAction SilentlyContinue
            }
            if ((Test-Path ".github") -and -not (Get-ChildItem ".github" -ErrorAction SilentlyContinue)) {
                Remove-Item ".github" -Force -ErrorAction SilentlyContinue
            }
        }
    }

    Write-Host ""
    Write-Info "BTR-AF uninstalled successfully!"
    Write-Host ""
}

Main
