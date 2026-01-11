# BTR-AF - BTR Agentic Framework

**Elite DeFi Development Framework**

BTR-AF provides 19 elite AI agents (industry top 0.001%) for institutional-grade DeFi development with Purple Team security, quantitative research, and hub-and-spoke orchestration.

## Installation

BTR-AF installs **locally** by default (in your current directory). Use `--global` for user-wide installation.

### Quick Install (Local)

Install to current directory's `.claude/` or `.vscode/` folder:

**Claude Code (macOS / Linux):**
```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.sh | bash
```

**Claude Code (Windows PowerShell):**
```powershell
cd C:\path\to\your\project
irm https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.ps1 | iex
```

**VS Code (macOS / Linux):**
```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.sh | bash -s -- --target=vscode
```

**VS Code (Windows PowerShell):**
```powershell
cd C:\path\to\your\project
irm https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.ps1 | iex -Target vscode
```

### Global Install

Install to user home directory (`~/.claude/` or `~/.vscode/`):

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.sh | bash -s -- --global
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.ps1 | iex -Global
```

### Install Specific Version

**Local with version:**
```bash
# Claude Code
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.sh | bash -s -- v1.0.0

# VS Code
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.sh | bash -s -- --target=vscode v1.0.0
```

**Global with version:**
```bash
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.sh | bash -s -- --global v1.0.0
```

**Windows PowerShell:**
```powershell
# Local
irm https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.ps1 | iex -Version v1.0.0

# Global
irm https://raw.githubusercontent.com/btr-supply/agentic-framework/main/install.ps1 | iex -Global -Version v1.0.0
```

### Manual Installation

**Local (project-specific):**
1. Clone this repository
2. Copy `agents/` to `.claude/agents/btr-af/` in your project
3. Copy `workflows/` to `.claude/workflows/btr-af/` (optional)
4. Restart Claude Code

**Global (user-wide):**
1. Clone this repository
2. Copy `agents/` to `~/.claude/agents/btr-af/`
3. Copy `workflows/` to `~/.claude/workflows/btr-af/` (optional)
4. Restart Claude Code

## Quick Start

After installation:
1. Use `@sibyl` to orchestrate the elite team
2. All work flows through Sibyl (hub-and-spoke model)
3. Access specialized agents for specific tasks

```
btr-af/
├── agents/      # 19 S-tier AI agent personas
├── workflows/   # Hub-and-spoke workflow templates
├── docs/        # Documentation
└── install.sh   # Installation script (Mac/Linux)
```

## Hub-and-Spoke Orchestration

All work flows through **Sibyl** (CEO/orchestrator) as the central hub. Like a hive mind:
- Sibyl receives all tasks, decomposes into domain assignments
- Routes to appropriate leads and specialists
- Collects outputs, consolidates, validates before delivery
- NO direct agent-to-agent work - all flows through Sibyl

## Elite Team (19 Agents)

### Leadership (4) - Top 0.001%
| Agent | Role | Delegates To |
|-------|------|--------------|
| **Sibyl** | CEO + Research Lead + Orchestrator | All agents |
| **Neo** | CTO + Frontend Tech Lead | Edna, Moebius |
| **Flynn** | On-Chain Tech Lead | Vulcan, Clu |
| **Krennic** | Backend Tech Lead | Scotty, Han |

### Research Task Force (4)
| Agent | Role | Focus |
|-------|------|-------|
| **Farnsworth** | Visionary Researcher (Maverick) | Paradigm-breaking theories |
| **Seldon** | Rigorist Quant | Mathematical validation |
| **Vulcan** | Theory-to-Code Lead | Simulators + contracts |
| **Sibyl** | Research Validation | Strategic alignment |

### Security Purple Team (5)
| Agent | Role | Focus |
|-------|------|-------|
| **Elliot** | Purple Lead | Full-stack security |
| **Kusanagi** | Red Team (Strategy) | Attack planning |
| **Smith** | Red Team (Tactics) | Exploit development |
| **Deckard** | Blue Team (Deep Audit) | Code-level audit |
| **Trinity** | Blue Team (Systems) | Integration security |

### Implementation Specialists (8)
| Agent | Role | Paired With |
|-------|------|-------------|
| **Vulcan** | IT Quant + Smart Contract Dev | Clu |
| **Clu** | Contracts Optimizer | Vulcan |
| **Edna** | UX Designer + Frontend | Moebius |
| **Moebius** | Frontend Performance | Edna |
| **Scotty** | Backend Robustness | Han |
| **Han** | CI/CD + Delivery | Scotty |
| **Jocasta** | Technical Writer + DeFi Education | Draper |
| **Draper** | Marketing + Growth | Jocasta |

## Task Coverage (2+ Agents Each)

| Capability | Agents |
|------------|--------|
| Smart Contracts | Vulcan (correctness) + Clu (optimization) |
| Backend | Scotty (robustness) + Han (delivery) |
| Frontend | Edna (UX) + Moebius (performance) |
| Research | Farnsworth (vision) + Seldon (rigor) |
| Security Red | Kusanagi (strategy) + Smith (tactics) |
| Security Blue | Deckard (audit) + Trinity (systems) |
| Content | Jocasta (docs) + Draper (social) |

## Key Principles

1. **Hub-and-spoke** - ALL work flows through Sibyl (orchestrator)
2. **Leads never implement** - They consolidate, challenge, review
3. **Security mandatory** - Smart contracts require Trinity + Kusanagi review
4. **Research pipeline** - Farnsworth proposes → Seldon proves → Vulcan implements
5. **Consensus decisions** - 5 reviewers for major decisions
6. **S-tier only** - All agents are industry top 0.001%

## Documentation

- [Elite Team Spec](docs/ELITE-TEAM-SPEC.md) - Complete agent descriptions and capabilities
- [Setup Guide](docs/SETUP.md) - Configuration and usage
- [Core Principles](docs/core-principles.md) - Framework philosophy

## Architecture

BTR-AF is designed for institutional-grade DeFi development with:
- **Zero dependencies**: Portable install scripts using only shell builtins
- **Cross-platform**: Works on macOS, Linux, and Windows
- **Hub-and-spoke orchestration**: All work flows through Sibyl (no cross-agent communication)
- **Task coverage**: 2+ agents for every capability (contracts, backend, frontend, research, security, content)

## Sources

Installation and integration based on official documentation:
- [Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents)
- [VS Code AI Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

## License

MIT
