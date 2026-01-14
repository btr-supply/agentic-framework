# BTR-AF Installer (Windows)
# Supports: OpenCode, Claude Code, VS Code
# Requires: PowerShell 5.1+ (built-in on Windows 10+)

param(
    [string]$Version = $null,
    [ValidateSet("opencode", "claude", "vscode")]
    [string]$Target = "opencode",
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

# Write opencode.json
function Write-OpenCodeConfig {
    @'
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
'@ | Out-File -FilePath "opencode.json" -Encoding UTF8
}

# Main installation
function Main {
    # Set installation directories based on target and scope
    if ($Target -eq "opencode") {
        if ($Scope -eq "global") {
            $AgentDir = Join-Path $env:USERPROFILE ".config\opencode\agent"
            $ConfigDir = Join-Path $env:USERPROFILE ".config\opencode"
            $InstallName = "OpenCode (global)"
        } else {
            $AgentDir = ".opencode\agent"
            $ConfigDir = "."
            $InstallName = "OpenCode (local)"
        }
    } elseif ($Target -eq "claude") {
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
            $AgentDir = Join-Path $env:USERPROFILE ".vscode\agents\btr-af"
            $WorkflowDir = $null
            $InstallName = "VS Code (global)"
        } else {
            $AgentDir = ".vscode\agents\btr-af"
            $WorkflowDir = $null
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

        # Install based on target
        if ($Target -eq "opencode") {
            # For OpenCode: copy .opencode/agent/*.md files
            Write-Info "Installing agents for OpenCode..."
            $OpenCodeAgentPath = Join-Path $ExtractedDir.FullName ".opencode\agent"
            if (Test-Path $OpenCodeAgentPath) {
                New-Item -ItemType Directory -Force -Path $AgentDir | Out-Null
                $agentFiles = Get-ChildItem -Path $OpenCodeAgentPath -Filter "*.md"
                foreach ($agentFile in $agentFiles) {
                    Copy-Item $agentFile.FullName -Destination $AgentDir
                }
                Write-Info "Agents installed to: $AgentDir"
            }

            # Create opencode.json if local install
            if ($Scope -eq "local") {
                Write-Info "Creating opencode.json..."
                Write-OpenCodeConfig
                Write-Info "Config created: opencode.json"
            }

        } elseif ($Target -eq "claude") {
            # For Claude Code: convert .agent.md to .md files and install
            Write-Info "Converting agents for Claude Code..."
            $agentFiles = Get-ChildItem -Path (Join-Path $ExtractedDir.FullName "agents") -Filter "*.agent.md"
            foreach ($agentFile in $agentFiles) {
                $basename = [System.IO.Path]::GetFileNameWithoutExtension($agentFile.Name).Replace(".agent", "")

                # Extract frontmatter (between --- markers)
                $content = Get-Content $agentFile.FullName -Raw
                if ($content -match '(?s)^---(.+?)^---(.+)') {
                    $frontmatter = $matches[1] -replace '^tools:\s*$', 'tools: Read, Write, Edit, Bash, Glob, Grep'
                    $body = $matches[2].Trim()

                    # Write Claude-compatible agent file
                    @"
---
$frontmatter
---
$body
"@ | Out-File -FilePath (Join-Path $AgentDir "$basename.md") -Encoding UTF8
                }
            }
            Write-Info "Agents installed to: $AgentDir"

            # Copy workflows
            if ($WorkflowDir) {
                $WorkflowsPath = Join-Path $ExtractedDir.FullName "workflows"
                if (Test-Path $WorkflowsPath) {
                    New-Item -ItemType Directory -Force -Path $WorkflowDir | Out-Null
                    Copy-Item -Path "$WorkflowsPath\*" -Destination $WorkflowDir -Recurse -Force
                    Write-Info "Workflows installed to: $WorkflowDir"
                }
            }

        } else {
            # For VS Code: copy .agent.md files to .github/agents/
            New-Item -ItemType Directory -Force -Path ".github\agents" | Out-Null
            $agentFiles = Get-ChildItem -Path (Join-Path $ExtractedDir.FullName "agents") -Filter "*.agent.md"
            foreach ($agentFile in $agentFiles) {
                $basename = [System.IO.Path]::GetFileNameWithoutExtension($agentFile.Name).Replace(".agent", "")
                Copy-Item $agentFile.FullName -Destination ".github\agents\$basename.agent.md"
            }
            Write-Info "Agents installed to: .github\agents"
        }

        # Installation complete
        Write-Host ""
        Write-Info "Installation complete!"
        Write-Host ""

        if ($Target -eq "opencode") {
            Write-Host "Next steps:"
            Write-Host "  1. Install IntraCom:"
            Write-Host "     git clone https://github.com/btr-supply/agentic-intracom.git ../agentic-intracom"
            Write-Host "  2. Install IntraCom dependencies:"
            Write-Host "     cd ../agentic-intracom && bun install"
            Write-Host "  3. Install OpenCode:"
            Write-Host "     irm https://opencode.ai/install | iex"
            if ($Scope -eq "global") {
                Write-Host "  4. Agents installed globally in ~/.config/opencode/agent/"
            } else {
                Write-Host "  4. Run: opencode (in $(Get-Location))"
            }
            Write-Host "  5. Use @sibyl to orchestrate the elite team"
        } elseif ($Target -eq "claude") {
            Write-Host "Next steps:"
            Write-Host "  1. Restart Claude Code or reload your IDE"
            if ($Scope -eq "global") {
                Write-Host "  2. Agents installed globally in ~/.claude/agents/"
            } else {
                Write-Host "  2. Agents installed locally in $(Get-Location)\.claude\agents\"
            }
            Write-Host "  3. Use @sibyl to orchestrate the elite team"
        } else {
            Write-Host "Next steps:"
            Write-Host "  1. Restart VS Code or reload the window"
            if ($Scope -eq "global") {
                Write-Host "  2. Agents installed globally in ~/.vscode/agents/btr-af/"
            } else {
                Write-Host "  2. Agents installed locally in $(Get-Location)\.github\agents\"
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
