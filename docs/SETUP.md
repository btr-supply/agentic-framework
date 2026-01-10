# BTRM Setup and Usage Guide

## Installation

### 1. Install BTRM into BTR DEX

From your BTR DEX project root (`/Users/derpa/Work/btr/dex`):

```bash
bun /Users/derpa/Work/bmad/tools/cli/bmad-cli.js install
```

Select `btrm` when prompted. This installs the BTRM framework into `_btr/btrm/` in your project.

### 2. Verify Installation

```bash
ls _btr/btrm/agents/
# Should show 18 agent files: ceo, neo, flynn, krennic, seldon, vulcan, clu, scotty, han, edna, leonardo, elliot, moriarty, lupin, holmes, poirot, watson, draper
```

---

## Using BTRM with Claude Code

### Basic Workflow

**Always start with the CEO (orchestrator) for complex tasks:**

1. **You ask a question** → Claude picks up BTRM context
2. **CEO analyzes** → Identifies domains, selects relevant agents
3. **Agents collaborate** → Each provides independent analysis (with WebSearch)
4. **Lead consolidates** → Domain lead challenges and synthesizes
5. **Consensus reached** → All agents confirm
6. **Response delivered** → Code implemented if needed, reviewed against CONTRIBUTING.md

### Example: "Review documentation consistency with codebase"

```
You: Review the documentation and its consistency with the codebase

CEO (internally):
1. Domains: Documentation + Codebase (all layers)
2. Agents: Watson (docs lead), Neo (frontend), Flynn (contracts), Krennic (backend)
3. Lead: Watson (documentation focus)

Watson: [WebSearch for doc consistency best practices]
- Reviews docs/ structure against code
- Identifies inconsistencies

Neo: [WebSearch for frontend doc patterns]
- Reviews front/ vs docs/ alignment

Flynn: [WebSearch for Solidity NatSpec standards]
- Reviews contracts/ NatSpec vs docs/ alignment

Krennic: [WebSearch for SDK documentation patterns]
- Reviews sdk/ exports vs docs/ alignment

Watson (Lead): Consolidates findings, proposes fixes

All agents confirm: Correct, elegant, actionable

Response delivered to you
```

---

## Agent Triggers

### Orchestration
| Trigger | Agent | Purpose |
|---------|-------|---------|
| `ORCHESTRATE` | CEO | Multi-agent coordination |
| `CONSENSUS` | CEO | Consensus workflow |

### Architecture
| Trigger | Agent | Purpose |
|---------|-------|---------|
| `ARCH` | Neo | System architecture |
| `FRONT-ARCH` | Neo | Frontend architecture |
| `CONTRACT-ARCH` | Flynn | Contract architecture |
| `BACKEND-ARCH` | Krennic | Backend architecture |
| `TECH-DECISION` | Neo + Flynn + Krennic | Major decision (5 reviewers) |

### Development
| Trigger | Agent | Purpose |
|---------|-------|---------|
| `SC` | Vulcan | Smart contract task |
| `FE` | Edna | Frontend task |
| `BE` | Scotty | Backend task |
| `GAS` | Clu | Gas optimization |
| `PERF` | Leonardo | Frontend performance |

### Research
| Trigger | Agent | Purpose |
|---------|-------|---------|
| `MATH` | Seldon | Math verification |
| `SIM` | Seldon | AIMM simulation |
| `MATH-TO-SOL` | Vulcan | Math → Solidity |

### Security
| Trigger | Agent | Purpose |
|---------|-------|---------|
| `THREAT` | Elliot | Threat modeling |
| `PURPLE` | Elliot | Purple team workflow |
| `RED-STRAT` | Moriarty | Red team strategy |
| `RED-TACTICS` | Lupin | Red team tactics |
| `BLUE-DEEP` | Holmes | Deep audit |
| `BLUE-SYSTEMS` | Poirot | Systems audit |

### Documentation
| Trigger | Agent | Purpose |
|---------|-------|---------|
| `API-DOC` | Watson | API documentation |
| `ARTICLE` | Watson | Educational article |
| `SOCIAL` | Draper | Social media content |
| `GTM` | Draper | Go-to-market strategy |

---

## Core Principles (All Agents)

Every BTRM agent follows these principles:

### 1. WebSearch First
Before any technical response, agents use WebSearch to:
- Verify current best practices
- Check official documentation
- Find state-of-the-art approaches
- Validate assumptions

### 2. Consensus-Driven
- **Major decisions**: 5 reviewers (Neo + Flynn + Krennic + 2 specialists)
- **Minor decisions**: 2 reviewers (domain pair)
- All code changes reviewed against CONTRIBUTING.md

### 3. BTR DEX Stack Awareness
All agents know:
- **Bun** (never npm/yarn)
- **Solidity 0.8.33** with Foundry
- **Preact + Signals + Tailwind** (<400KB bundle)
- **CREATE3** deterministic deployments
- **tsgo** for type checking
- **oxlint** for linting

---

## Consensus Workflow Detail

### Phase 1: Problem Formalization
- CEO analyzes request
- WebSearch to verify context
- Ask clarifying questions if needed
- Identify primary domain

### Phase 2: Agent Selection
- Select relevant agents by domain:
  - Frontend: Neo, Edna, Leonardo
  - Contracts: Flynn, Vulcan, Clu
  - Backend: Krennic, Scotty, Han
  - Research: Seldon, Vulcan, Watson
  - Security: Elliot, Moriarty, Lupin, Holmes, Poirot
  - Docs: Watson, Draper

### Phase 3: Independent Analysis
- Each agent provides analysis (no file changes yet)
- All agents WebSearch before responding
- Proposals as text, not file edits

### Phase 4: Lead Consolidation
- Domain lead collects responses
- Challenges: correct? elegant? DRY? modern? minimal?
- Synthesizes into consolidated proposal

### Phase 5: Agent Confirmation
All agents confirm:
- [ ] Conceptually sound
- [ ] Technically correct
- [ ] Elegant and minimal
- [ ] DRY (no duplication)
- [ ] Modern (current best practices)
- [ ] Idiomatic (follows project conventions)
- [ ] Aligned with CONTRIBUTING.md

### Phase 6: Implementation
- Only after consensus
- Developer implements exactly the proposal
- Atomic commits per CONTRIBUTING.md

### Phase 7: Final Review
All agents review:
- [ ] Code matches proposal
- [ ] No dead code
- [ ] CONTRIBUTING.md compliance

### Phase 8: Delivery
- Brief summary
- Key decisions
- Code changes (if applicable)

---

## Decision Matrix

| Scope | Reviewers | Composition |
|-------|-----------|-------------|
| **Major** (new module, refactor, protocol change, new dep) | 5 | Neo + Flynn + Krennic + 2 specialists |
| **Minor** (localized, single layer) | 2 | Domain pair |
| **Security-sensitive** | 5 | Swap 1 specialist for Elliot |

---

## Best Practices

### For Complex Tasks
1. Start with `ORCHESTRATE` or describe the task fully
2. Let CEO select appropriate agents
3. Review the consensus before implementation
4. Check code against CONTRIBUTING.md

### For Simple Tasks
1. Use direct triggers (`SC`, `FE`, `BE`, etc.)
2. Agent will still WebSearch and follow principles
3. Domain lead reviews output

### For Security-Sensitive Work
1. Always involve Elliot (Purple Lead)
2. Red team (Moriarty, Lupin) finds attack vectors
3. Blue team (Holmes, Poirot) audits defenses
4. Purple workflow ensures learning loop

---

## File Structure After Installation

```
your-project/
├── _btr/
│   └── btrm/
│       ├── agents/           # 18 elite agents
│       │   ├── ceo.agent.yaml
│       │   ├── neo.agent.yaml
│       │   ├── flynn.agent.yaml
│       │   └── ...
│       ├── workflows/
│       │   ├── orchestration/
│       │   │   └── consensus/
│       │   └── requirements/
│       │       └── technical-spec/
│       ├── core-principles.md
│       ├── ELITE-TEAM-SPEC.md
│       ├── README.md
│       ├── SETUP.md           # This file
│       └── module.yaml
├── contracts/   # Vulcan, Clu, Flynn
├── front/       # Edna, Leonardo, Neo
├── back/        # Scotty, Han, Krennic
├── sdk/         # Krennic, Watson
├── sim/         # Seldon, Vulcan
└── docs/        # Watson, Draper
```

---

## Troubleshooting

### Agents not using WebSearch
- Verify agent YAML has `WEBSEARCH FIRST` principle
- Check if WebSearch tool is available in Claude Code

### Consensus not working
- Use `CONSENSUS` trigger explicitly
- Ensure CEO agent is installed

### Code not following CONTRIBUTING.md
- Lead agent enforces CONTRIBUTING.md in final review
- Use `REVIEW-ALL` trigger for cross-team review
