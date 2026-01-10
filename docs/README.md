# BTRM: BTR Exchange Method - Elite Technical Team

**Elite, security-first AI agent framework for institutional-grade DeFi development.**

---

## Team Philosophy

**BTRM's elite team represents industry top 0.1% technical talent.**

- **THREE TECH LEADS** - Neo (CTO + Frontend), Flynn (On-Chain/Contracts), Krennic (Backend)
- **ALL agents are multi-disciplinary** - Every team member has deep thinking, deep implementation capability, and ability to challenge every decision
- **Production-grade, institutional finance expertise** - All team members understand requirements of high-finance codebases: trust, sobriety, zero-tolerance for bugs
- **NEVER make decisions alone** - Always collaborative, cross-reviewed, with multiple perspectives
- **Deep thinking capability** - All can work at GLOBAL high-level AND low-level implementation details

**Frontend devs are extremely design/UX sensitive** - Edna and Leonardo create beautiful, performant UI while being exceptional engineers

**Backend/CI-CD pair** - Scotty (robust engineer) and Han (DevOps) are both full-stack backend engineers

We build **institutional-grade financial tools** that serve:
1. **High-finance executives & investors**: Trust, sobriety, high performance, no bloat, informative
2. **Retail traders & LPs**: Elegant, scalable, low-bandwidth, accessible marketing and flows

---

## Overview

BTRM is an elite framework for:
- Smart contract development (Solidity/Foundry, EVM + Rust)
- Institutional-grade security (Purple Team: Red↔Blue learning loop)
- Mathematical correctness for DeFi protocols
- **Excellent UI/UX for both retail and institutional users**
- Clean, professional terminology (no "user stories", no agile ceremony)

---

## Documentation Structure

BTR-MAD is designed for a **monorepo** environment with clear separation of concerns:

```
your-project/                          # Monorepo root
├── docs/                              # User-facing (React renderer)
│   ├── trading/                       # Trader guides
│   ├── liquidity/                      # LP guides
│   └── api/                            # User API reference
│
├── specs/                              # BTRM technical documentation (markdown)
│   ├── requirements/                   # Technical specs
│   ├── architecture/                   # System architecture
│   ├── security/                       # Threat models, audits
│   └── releases/                       # Release notes
│
├── contracts/                          # Smart contracts
│   ├── src/                            # Solidity source
│   ├── test/                           # Foundry tests
│   └── lib/                            # Dependencies
│
├── back/                               # Backend services
│   ├── collector/                      # Market data collector
│   └── api/                            # Backend API
│
├── front/                              # Frontend app
│   ├── src/                            # Preact/React source
│   └── ...
│
└── sdk/                                # TypeScript SDK
```

## Quick Reference

### Elite Team (18 Agents)

#### Orchestrator

| Agent | Working Dir | Role | Scope |
|-------|-------------|------|-------|
| **CEO** | `/` (root) | Orchestrator - Multi-Agent Coordinator | 👑 Agent selection, consensus-driven, quality assurance |

**Orchestration Workflow**: CEO analyzes request → selects agents → assigns lead → drives consensus → ensures review.

#### Tech Leads (3 Architects)

| Agent | Working Dir | Role | Scope |
|-------|-------------|------|-------|
| **Neo** | `front/` + `/` (root) | CTO + Frontend Tech Lead | 🏗️ Lead of leads, frontend architecture |
| **Flynn** | `contracts/` | On-Chain Tech Lead | 🧭 Contracts architecture, challenges complexity |
| **Krennic** | `back/` + `sdk/` | Backend Tech Lead | 🧱 Backend, SDK, forces convergence |

**Tech Lead Hierarchy**: Neo (CTO) → coordinates Flynn (contracts) + Krennic (backend).

#### Research Task Force

| Agent | Working Dir | Role | Scope |
|-------|-------------|------|-------|
| **Seldon** | `sim/` + `docs/1. AIMM/` | Quant Researcher (Lead) | 📊 AIMM formulas, simulations, parameters |
| **Vulcan** | `contracts/` + `sim/` | Contracts + Quant | ⬡ Concept-to-code, math → Solidity |

**Research Pipeline**: Seldon (math specs) → Vulcan (Solidity implementation) → Watson (research papers).

#### Contracts (On-Chain)

| Agent | Working Dir | Role | Scope |
|-------|-------------|------|-------|
| **Vulcan** | `contracts/` | Contracts + Quant | ⬡ Correctness-first, math → Solidity |
| **Clu** | `contracts/` | Contracts Optimizer | 🧩 Gas, storage layout, assembly tuning |

**Supplement Pair**: Vulcan ensures correctness → Clu optimizes gas/storage.

#### Backend

| Agent | Working Dir | Role | Scope |
|-------|-------------|------|-------|
| **Scotty** | `back/` | Backend + CI/CD | ⚙️ Systems craft, robustness, infra interfaces |
| **Han** | `back/` | Delivery Engineer | 🚀 Fast shipping, scripts, automation, pipelines |

**Supplement Pair**: Scotty optimizes correctness → Han optimizes delivery speed.

#### Frontend + Product

| Agent | Working Dir | Role | Scope |
|-------|-------------|------|-------|
| **Edna** | `front/` | Designer + Frontend | 🖥️ UX design, product, assets, implementation |
| **Leonardo** | `front/` | Frontend (Design-minded) | 🧑‍🎨 Performance purist, component architecture, anti-bloat |

**Supplement Pair**: Edna owns user+marketing interface → Leonardo challenges bloat, ensures idiomatic code.

#### Growth (Marketing)

| Agent | Working Dir | Role | Scope |
|-------|-------------|------|-------|
| **Draper** | `front/`, `docs/` | Growth Lead | 📢 GTM strategy, content, conversion copy |

#### Security (Purple Team)

| Agent | Working Dir | Role | Scope |
|-------|-------------|------|-------|
| **Elliot** | `/` (root) | Security Architect + Purple Lead | 🔐 Threat modeling, Red↔Blue coordination |
| **Moriarty** | `/` (root) | Red (Strategy) | 🩸 Economic exploits, systemic failures |
| **Lupin** | `/` (root) | Red (Tactics) | 🎭 Hands-on exploitation, bypass techniques |
| **Holmes** | `/` (root) | Blue (Deep Audit) | 🔍 Surgical reasoning, logic path analysis |
| **Poirot** | `/` (root) | Blue (Systems Audit) | 🧠 Pattern recognition, holistic review |

**Purple Team Workflow**: Led by Elliot, pulling from Red (Moriarty, Lupin) and Blue (Holmes, Poirot). Red teaches Blue; Blue teaches Red.

#### Documentation & Growth

| Agent | Working Dir | Role | Scope |
|-------|-------------|------|-------|
| **Watson** | `docs/` + `sdk/` | Technical Writer + DeFi Education | 📝 Long-form docs, API/ABI, concept democratization |
| **Draper** | `front/` + `docs/4. User Guides/` | Growth + Social Media | 📢 Short-form, campaigns, dumbing down tech |

**Content Pipeline**: Watson (long-form) → Draper (simplifies for social). Seldon (research) → Watson (papers) → Draper (social).

### Workflows

#### Orchestration & Consensus
| Trigger | Workflow | Purpose |
|---------|----------|---------|
| `ORCHESTRATE` | coordinate | Multi-agent coordination (CEO selects agents) |
| `CONSENSUS` | consensus | Consensus workflow (gather inputs, challenge, confirm) |

#### Requirements & Specification
| Trigger | Workflow | Purpose |
|---------|----------|---------|
| `SPEC` | technical-spec | Create technical specification |
| `TR` | technical-research | Research and document findings |

#### Architecture
| Trigger | Workflow | Purpose |
|---------|----------|---------|
| `ARCH` | system-architecture | System architecture design |
| `SEC-ARCH` | security-architecture | Security architecture design |

#### Development
| Trigger | Workflow | Purpose |
|---------|----------|---------|
| `SC` | smart-contract-task | Smart contract task (TDD) |
| `BE` | backend-task | Backend task (TDD) |
| `FE` | frontend-task | Frontend task (TDD + UX focus) |
| `CR` | code-review | Peer code review |

#### Security
| Trigger | Workflow | Purpose |
|---------|----------|---------|
| `AUDIT` | security-audit | Comprehensive security audit |
| `THREAT` | threat-model | STRIDE threat model |

#### Testing & Math
| Trigger | Workflow | Purpose |
|---------|----------|---------|
| `FUZZ` | fuzzing | Fuzzing campaign design |
| `MATH` | math-verification | Math correctness verification |
| `SIM` | simulation | AMM/strategy simulation |

#### Documentation & Release
| Trigger | Workflow | Purpose |
|---------|----------|---------|
| `ARCH-DOC` | architecture-docs | Architecture documentation |
| `RELEASE` | release-plan | Release planning |

---

## UI/UX Philosophy

**We serve BOTH retail and institutional users. The UI/UX must be excellent for everyone.**

### Retail Users ($1 - $10K trades)
- **Mobile-first**: Many users trade on phones
- **Simplicity**: One-tap swaps, clear fee display
- **Education**: Tooltips, "learn more", guided flows
- **Trust**: Clear security indicators, educational content
- **Accessibility**: WCAG AA compliance, screen reader support

### Institutional Users ($10K - $10M+ trades)
- **Power features**: Batch swaps, advanced charts, historical data
- **API access**: SDK for programmatic trading
- **Compliance**: Reporting, audit trails
- **Performance**: Fast execution, minimal latency

### UI/UX Requirements for Frontend Dev

- ✅ Gas cost shown in both token AND USD
- ✅ Slippage as visual range (min/max output)
- ✅ Pre-transaction simulation
- ✅ Actionable, human-readable error messages
- ✅ Progress indicators for pending transactions
- ✅ Mobile responsive (portrait & landscape)
- ✅ Dark mode with excellent contrast
- ✅ Accessibility: keyboard navigation, ARIA labels
- ✅ Loading states, optimistic UI where appropriate
- ✅ Wallet action explanations before signing

---

## Decision-Making Rules

### Major Decisions
Require **5 reviewers** for decisions involving:
- New module/package
- Refactor direction
- Protocol changes
- Naming/structure conventions
- New dependencies
- Breaking API/contract changes

**Reviewer composition**:
- **3× Architects/Tech Leads**: Neo + Flynn + Krennic
- **2× Stack specialists** (relevant to change):
  - On-chain: Vulcan + Clu
  - Frontend: Edna + Leonardo
  - Backend/CI-CD: Scotty + Han
  - Security-sensitive: Swap one specialist seat for Elliot (still keep 5 total)

### Minor Decisions
Require **2 reviewers** for localized changes within one layer:
- **On-chain** (contract-only): Vulcan + Clu
- **Backend** (backend-only): Scotty + Han
- **Frontend** (frontend-only): Edna + Leonardo

### Supplement Pairs

| Category | Primary | Challenger | Convergence |
|-----------|-----------|-------------|-------------|
| **Architecture** | Neo (north star) | Flynn (alternatives) | Krennic (harden) |
| **Contracts** | Vulcan (correctness) | - | Clu (optimization) |
| **Frontend** | Edna (UX + product) | - | Leonardo (anti-bloat) |
| **Backend/CI-CD** | Scotty (robustness) | - | Han (fast delivery) |

### Purple Team Configuration

- **Purple workflow** led by Elliot
- Pulls members from **Red** (Moriarty: strategy, Lupin: tactics) and **Blue** (Holmes: deep audit, Poirot: systems audit)
- Purple is a workflow, not separate auditors: Red teaches Blue, Blue teaches Red

---

## Installation

### From Local Repository

```bash
cd /path/to/your/project
bun /Users/derpa/Work/bmad/tools/cli/bmad-cli.js install
```

Select `btrm` when prompted.

### Via bunx (when published)

```bash
cd /path/to/your/project
bunx bmad-method@alpha install
```

---

## Usage with Claude Code

### Starting a New Feature

1. **Engage 5-Reviewer Consensus** (for major decisions)
   ```
   Trigger: TECH-DECISION or "tech-decision"
   Agents: Neo + Flynn + Krennic + 2 relevant stack specialists
   ```

2. **Create Specification**
   ```
   Trigger: SPEC or "technical-spec"
   Agent: Any (Watson recommended for docs)
   ```

3. **Create Architecture** (if complex)
   ```
   Trigger: ARCH or "system-architecture"
   Agent: Neo (or Neo + Flynn + Krennic for convergence)
   ```

4. **Create Threat Model** (if security-sensitive)
   ```
   Trigger: THREAT or "threat-model"
   Agent: Elliot
   ```

### Implementing

1. **Smart Contract Task**
   ```
   Trigger: SC or "smart-contract-task"
   Agent: Vulcan
   ```

2. **Frontend Task** (with UX focus)
   ```
   Trigger: FE or "frontend-task"
   Agent: Edna (or Edna + Leonardo for convergence)
   ```

3. **Backend Task**
   ```
   Trigger: BE or "backend-task"
   Agent: Scotty (or Scotty + Han for convergence)
   ```

### Security

1. **Purple Team Workflow**
   ```
   Trigger: PURPLE or "purple-team"
   Agent: Elliot (coordinates Red + Blue)
   ```

2. **Red Team Strategy**
   ```
   Trigger: RED-STRAT or "red-strategy"
   Agent: Moriarty
   ```

3. **Red Team Tactics**
   ```
   Trigger: RED-TACTICS or "red-tactics"
   Agent: Lupin
   ```

4. **Blue Team Deep Audit**
   ```
   Trigger: BLUE-DEEP or "deep-audit"
   Agent: Holmes
   ```

5. **Blue Team Systems Audit**
   ```
   Trigger: BLUE-SYSTEMS or "systems-audit"
   Agent: Poirot
   ```

---

## Terminology

| BTRM Term | Meaning |
|-----------|---------|
| **Spec** | Technical specification (what to build) |
| **Task** | Implementable work item |
| **Epic** | Large feature spanning multiple tasks |
| **Bug** | Defect in existing code |
| **Vulnerability** | Security issue |
| **Spike** | Research task with timebox |

---

## Security Gates (Purple Team)

Every code change passes through Purple Team:

1. **Self-Review** - Developer review (appropriate agent: Vulcan, Scotty, Edna)
2. **Peer Review** - Minor: 2 reviewers, Major: 5 reviewers
3. **Red Team Strategy** - Moriarty identifies systemic/economic attack vectors
4. **Red Team Tactics** - Lupin creates concrete PoCs and bypasses
5. **Blue Team Deep Audit** - Holmes performs surgical reasoning on execution paths
6. **Blue Team Systems Audit** - Poirot finds pattern problems and integration failures
7. **Purple Coordination** - Elliot coordinates Red↔Blue learning loop
8. **Documentation** - Watson update

---

## Comparison: BTRM vs BMAD

| Aspect | BMAD | BTRM |
|--------|------|------|
| **Agents** | 33+ generic | 18 elite (industry top 0.1%) |
| **Workflows** | 530+ | 18+ focused workflows |
| **Focus** | General software + games | DeFi/Smart Contracts (institutional-grade) |
| **Terminology** | "User stories", "sprints" | "Specs", "tasks", "major/minor decisions" |
| **Security** | Afterthought, single auditor | First-class (Purple Team: Red + Blue learning loop) |
| **Math** | Not covered | Elite Quant (Seldon) with statistical rigor |
| **UI/UX** | Separate agent, not design-minded | Two elite frontend devs (Edna + Leonardo) - both design and technical excellence |
| **Architecture** | Single architect | 3 architects (Neo + Flynn + Krennic) with clear roles |
| **Decision Process** | Unclear | Explicit 5-reviewer (major) and 2-reviewer (minor) rules |
| **Auditors** | 2 | 4 (2 Red + 2 Blue) with Red↔Blue learning loop |

---

## License

MIT (inherits from BMAD-METHOD)

---

## Production-Grade, Institutional Finance Context

All BTRM team members are **deep thinkers with production-grade experience in institutional finance codebases**:

### Deep Thinking Capability
- Every team member can work at **GLOBAL high-level system design** AND **low-level implementation details**
- No role limitation: architects understand implementation, implementers understand architecture
- **Multi-disciplinary**: Each team member takes on at least 2 roles (e.g., Vulcan: contracts + quant)

### Zero Tolerance for Bugs
- Institutional finance has zero tolerance for production bugs
- **Security-first**: Every code change passes through Purple Team (Red↔Blue learning loop)
- **Testing-first**: Comprehensive tests before, during, and after implementation
- **Formal verification**: For critical code paths and mathematical correctness

### Collaborative Decision Making
- **NEVER make decisions alone**: All technical decisions are cross-reviewed
- **Multiple perspectives**: 5 reviewers for major decisions ensure diverse input
- **Challenge culture**: Every decision can and should be challenged
- **Supplement dynamics**: Each category has primary, challenger, and convergence roles

### Working with BTR DEX Monorepo

The BTRM elite team is specifically designed for the BTR DEX monorepo structure:
```
/Users/derpa/Work/btr/dex/
├── contracts/    # Vulcan, Clu
├── back/         # Scotty, Han
├── front/        # Edna, Leonardo
├── sim/          # Seldon, Vulcan, Clu
├── docs/         # Watson, Draper (marketing)
└── sdk/          # All agents contribute to SDK design
```

---
