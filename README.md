# BTR-AF - BTR Agentic Framework

**Elite DeFi Development Framework**

19 AI agents for institutional-grade DeFi development with Purple Team security and hub-and-spoke orchestration.

## Installation

Installs locally by default (to `.claude/` or `.vscode/` in your project). Use `--global` for user-wide installation.

### Quick Install (Local)

**Claude Code (macOS/Linux):**
```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/latest/install.sh | bash
```

**Claude Code (Windows PowerShell):**
```powershell
cd C:\path\to\your\project
irm https://raw.githubusercontent.com/btr-supply/agentic-framework/latest/install.ps1 | iex
```

**VS Code (macOS/Linux):**
```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/latest/install.sh | bash -s -- --target=vscode
```

**VS Code (Windows PowerShell):**
```powershell
cd C:\path\to\your\project
irm https://raw.githubusercontent.com/btr-supply/agentic-framework/latest/install.ps1 | iex -Target vscode
```

### Global Install

```bash
# macOS/Linux
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/latest/install.sh | bash -s -- --global

# Windows PowerShell
irm https://raw.githubusercontent.com/btr-supply/agentic-framework/latest/install.ps1 | iex -Global
```

### Version Pinning

Replace `latest` with a version tag (`v1.0.1`, `v1.0.0`) for reproducible installs:

```bash
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/v1.0.1/install.sh | bash -s -- v1.0.1
```

### Manual Installation

Copy `agents/*.agent.md` files:
- **Claude Code**: Convert and copy to `.claude/agents/` (removes `.agent` prefix)
- **VS Code**: Copy to `.github/agents/` (keeps `.agent.md` extension)

## Uninstallation

```bash
# Local
rm -f .claude/agents/*.agent.yaml && rm -rf .claude/workflows/btr-af

# Global
rm -f ~/.claude/agents/*.agent.yaml && rm -rf ~/.claude/workflows/btr-af
```

## Quick Start

1. Use `@sibyl` to orchestrate the team
2. All work flows through Sibyl (hub-and-spoke model)
3. Access specialized agents for specific tasks

## Elite Team (19 Agents)

### Leadership (4)
| Agent | Role | Delegates To |
|-------|------|--------------|
| **Sibyl** | CEO + Research Lead + Orchestrator | All agents |
| **Neo** | CTO + Frontend Tech Lead | Edna, Moebius |
| **Flynn** | On-Chain Tech Lead | Vulcan, Clu |
| **Krennic** | Backend Tech Lead | Scotty, Han |

### Research (4)
| Agent | Role | Focus |
|-------|------|-------|
| **Farnsworth** | Visionary Researcher | Paradigm-breaking theories |
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

### Implementation Specialists (6)
| Agent | Role | Paired With |
|-------|------|-------------|
| **Vulcan** | IT Quant + Smart Contract Dev | Clu |
| **Clu** | Contracts Optimizer | Vulcan |
| **Edna** | UX Designer + Frontend | Moebius |
| **Moebius** | Frontend Performance | Edna |
| **Scotty** | Backend Robustness | Han |
| **Han** | CI/CD + Delivery | Scotty |

### Content (2)
| Agent | Role | Paired With |
|-------|------|-------------|
| **Jocasta** | Technical Writer + DeFi Education | Draper |
| **Draper** | Marketing + Growth | Jocasta |

## Task Coverage

| Capability | Agents |
|------------|--------|
| Smart Contracts | Vulcan + Clu |
| Backend | Scotty + Han |
| Frontend | Edna + Moebius |
| Research | Farnsworth + Seldon |
| Security Red | Kusanagi + Smith |
| Security Blue | Deckard + Trinity |
| Content | Jocasta + Draper |

## Key Principles

1. **Hub-and-spoke** - All work flows through Sibyl
2. **Leads never implement** - They consolidate, challenge, review
3. **Security mandatory** - Smart contracts require Purple Team review
4. **Research pipeline** - Farnsworth proposes → Seldon proves → Vulcan implements
5. **Consensus decisions** - 5 reviewers for major decisions

## Architecture

- **Zero dependencies**: Portable shell scripts
- **Cross-platform**: macOS, Linux, Windows
- **Hub-and-spoke orchestration**: Sibyl coordinates all agents
- **Dual coverage**: 2+ agents for every capability

## Sources

- [Claude Code Subagents Documentation](https://code.claude.com/docs/en/sub-agents)
- [VS Code AI Agents Overview](https://code.visualstudio.com/docs/copilot/agents/overview)

## License

MIT
