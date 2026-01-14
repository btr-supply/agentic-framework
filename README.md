# BTR-AF - BTR Agentic Framework

**Elite DeFi Development Framework**

19 AI agents for institutional-grade DeFi development with Purple Team security and hub-and-spoke orchestration.

## Installation

### OpenCode (Recommended)

OpenCode supports cross-agent communication via MCP servers.

```bash
# Install OpenCode
curl -fsSL https://opencode.ai/install | bash

# Clone agentic-framework
git clone https://github.com/btr-supply/agentic-framework.git
cd agentic-framework

# Clone IntraCom (agent bus MCP server)
git clone https://github.com/btr-supply/agentic-intracom.git ../agentic-intracom
cd ../agentic-intracom && bun install
```

The `opencode.json` in this repo is pre-configured to use IntraCom for agent communication.

### Claude Code / VS Code

Installs locally by default (to `.claude/` or `.vscode/`). Use `--global` for user-wide installation.

**Claude Code (macOS/Linux):**
```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/latest/install.sh | bash
```

**VS Code (macOS/Linux):**
```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/btr-supply/agentic-framework/latest/install.sh | bash -s -- --target=vscode
```

### Version Pinning

Replace `latest` with a version tag (`v1.0.1`, `v1.0.0`) for reproducible installs.

### Manual Installation

Copy `agents/*.agent.md` files:
- **Claude Code**: Convert and copy to `.claude/agents/`
- **OpenCode**: Copy to `.opencode/agent/` (already done in this repo)

## OpenCode + IntraCom Setup

This framework integrates with [IntraCom](https://github.com/btr-supply/agentic-intracom) for cross-agent communication.

### Configuration

The `opencode.json` in this repo includes:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "intracom": {
      "type": "local",
      "command": ["bun", "run", "../agentic-intracom/src/index.ts"],
      "enabled": true
    }
  }
}
```

### Agent Communication

Agents can communicate via IntraCom MCP tools:

- `agent_register` - Register agent with capabilities
- `message_send` - Send messages to other agents
- `message_read` - Read messages from mailbox
- `agent_list` - List all registered agents

### Example Agent Configuration

```markdown
---
description: CEO + Orchestrator
mode: primary
---

# Sibyl - CEO

You are registered as `sibyl` on IntraCom.

## Communication Protocol

1. Register: `agent_register(agentId="sibyl", capabilities={...}, allowlist=[...])`
2. Send: `message_send(from="sibyl", to="neo", body="...")`
3. Read: `message_read(agentId="sibyl")`
```

## Quick Start

1. Install OpenCode: `curl -fsSL https://opencode.ai/install | bash`
2. Install IntraCom dependencies from `../agentic-intracom`
3. Run: `opencode` in this directory
4. Use `@sibyl` to orchestrate the team

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
