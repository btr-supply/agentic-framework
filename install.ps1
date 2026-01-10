# BTR-AF Installer for Claude Code (Windows)
# Requires: PowerShell 5.1+ (built-in on Windows 10+)

param(
    [string]$Version = $null
)

$ErrorActionPreference = "Stop"

# Configuration
$Repo = "btr-supply/agentic-framework"
$GitHubAPI = "https://api.github.com/repos/$Repo"
$ClaudeDir = Join-Path $env:USERPROFILE ".claude\agents\btr-af"

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
    Write-Host "BTR-AF Installer for Claude Code" -ForegroundColor Cyan
    Write-Host "=================================" -ForegroundColor Cyan
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

    # Create directory
    Write-Info "Creating installation directory..."
    New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null

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
            Copy-Item -Path "$AgentsPath\*" -Destination $ClaudeDir -Recurse -Force
            Write-Info "Agents installed to: $ClaudeDir"
        } else {
            Write-Err "Agents directory not found in repository"
        }

        # Copy workflows (optional)
        $WorkflowsPath = Join-Path $ExtractedDir.FullName "workflows"
        if (Test-Path $WorkflowsPath) {
            $WorkflowDir = Join-Path $env:USERPROFILE ".claude\workflows\btr-af"
            New-Item -ItemType Directory -Force -Path $WorkflowDir | Out-Null
            Copy-Item -Path "$WorkflowsPath\*" -Destination $WorkflowDir -Recurse -Force
            Write-Info "Workflows installed to: $WorkflowDir"
        }

        # Installation complete
        Write-Host ""
        Write-Info "Installation complete!"
        Write-Host ""
        Write-Host "Next steps:"
        Write-Host "  1. Restart Claude Code or reload your IDE"
        Write-Host "  2. Agents will appear in your .claude/agents/btr-af/ directory"
        Write-Host "  3. Use @sibyl to orchestrate the elite team"
        Write-Host ""
        Write-Host "Documentation: https://github.com/$Repo"

    } finally {
        # Cleanup
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Main
