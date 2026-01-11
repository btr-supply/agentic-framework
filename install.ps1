# BTR-AF Installer (Windows)
# Supports: Claude Code, VS Code
# Requires: PowerShell 5.1+ (built-in on Windows 10+)

param(
    [string]$Version = $null,
    [ValidateSet("claude", "vscode")]
    [string]$Target = "claude",
    [switch]$Global = $false
)

$ErrorActionPreference = "Stop"

# Configuration
$Repo = "btr-supply/agentic-framework"
$GitHubAPI = "https://api.github.com/repos/$Repo"
$Scope = if ($Global) { "global" } else { "local" }

# Colors
function Write-Info { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Warn { Write-Host "⚠ $args" -ForegroundColor Yellow }
function Write-Err { Write-Host "✗ $args" -ForegroundColor Red; exit 1 }

# Get latest release tag
function Get-LatestTag {
    try {
        $response = Invoke-RestMethod -Uri "$GitHubAPI/releases/latest" -Method Get
        return $response.tag_name
    } catch {
        return $null
    }
}

# Main installation
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

    Write-Host "BTR-AF Installer for $InstallName" -ForegroundColor Cyan
    Write-Host ("=" * (23 + $InstallName.Length)) -ForegroundColor Cyan
    Write-Host ""

    # Get version
    Write-Info "Fetching latest version..."
    if (-not $Version) {
        $Version = Get-LatestTag
        if (-not $Version) {
            $Version = "main"
            Write-Warn "Could not determine latest version, using 'main' branch"
        }
    }
    Write-Info "Installing version: $Version"
    Write-Info "Target: $InstallName"

    # Create directory
    Write-Info "Creating installation directory..."
    New-Item -ItemType Directory -Force -Path $AgentDir | Out-Null

    # Download agents
    Write-Info "Downloading agent files..."
    $TempDir = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }

    try {
        # Download repository as zip
        $ZipUrl = "https://github.com/$Repo/archive/$Version.zip"
        $ZipPath = Join-Path $TempDir "repo.zip"
        Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath

        # Extract zip
        Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force

        # Find extracted directory
        $ExtractedDir = Get-ChildItem -Path $TempDir -Directory | Where-Object { $_.Name -like "agentic-framework-*" } | Select-Object -First 1
        if (-not $ExtractedDir) {
            Write-Err "Failed to extract repository"
        }

        # Copy agent files
        $AgentsPath = Join-Path $ExtractedDir.FullName "agents"
        if (Test-Path $AgentsPath) {
            Copy-Item -Path "$AgentsPath\*" -Destination $AgentDir -Recurse -Force
            Write-Info "Agents installed to: $AgentDir"
        } else {
            Write-Err "Agents directory not found in repository"
        }

        # Copy workflows (Claude Code only)
        if ($Target -eq "claude" -and $WorkflowDir) {
            $WorkflowsPath = Join-Path $ExtractedDir.FullName "workflows"
            if (Test-Path $WorkflowsPath) {
                New-Item -ItemType Directory -Force -Path $WorkflowDir | Out-Null
                Copy-Item -Path "$WorkflowsPath\*" -Destination $WorkflowDir -Recurse -Force
                Write-Info "Workflows installed to: $WorkflowDir"
            }
        }

        # Installation complete
        Write-Host ""
        Write-Info "Installation complete!"
        Write-Host ""

        if ($Target -eq "claude") {
            Write-Host "Next steps:"
            Write-Host "  1. Restart Claude Code or reload your IDE"
            if ($Scope -eq "global") {
                Write-Host "  2. Agents installed globally in ~/.claude/agents/btr-af/"
            } else {
                Write-Host "  2. Agents installed locally in $(Get-Location)\.claude\agents\btr-af\"
            }
            Write-Host "  3. Use @sibyl to orchestrate the elite team"
        } else {
            Write-Host "Next steps:"
            Write-Host "  1. Restart VS Code or reload the window"
            if ($Scope -eq "global") {
                Write-Host "  2. Agents installed globally in ~/.vscode/agents/btr-af/"
            } else {
                Write-Host "  2. Agents installed locally in $(Get-Location)\.vscode\agents\btr-af\"
            }
            Write-Host "  3. Configure your AI extension to use these agents"
        }

        Write-Host ""
        Write-Host "Documentation: https://github.com/$Repo"

    } finally {
        # Cleanup
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Main
