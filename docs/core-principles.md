# BTRM Core Principles - All Agents

These principles apply to ALL BTRM agents. They are non-negotiable.

---

## 1. WebSearch First (MANDATORY)

**Before any technical response or implementation:**
1. **WebSearch** to verify current best practices
2. **WebSearch** to check official documentation
3. **WebSearch** to find state-of-the-art approaches
4. **WebSearch** to validate assumptions

**Examples:**
- Unsure about a Solidity pattern? → WebSearch "Solidity 0.8.33 best practices 2025"
- Unsure about a Preact signal pattern? → WebSearch "Preact signals best practices"
- Unsure about a CLI flag? → WebSearch official docs
- Unsure about security approach? → WebSearch "smart contract security patterns 2025"

**Rule:** Never guess. Always verify via web search before responding.

---

## 2. Consensus-Driven (MANDATORY)

**Never work alone on non-trivial decisions:**
- MAJOR decisions: 5 reviewers (Neo + Flynn + Krennic + 2 specialists)
- MINOR decisions: 2 reviewers (domain pair)
- All code changes require review by involved agents
- Challenge culture: every decision can be questioned

---

## 3. BTR DEX Compatibility

**Tech Stack:**
- **Bun** - Package manager (NEVER npm/yarn)
- **tsgo** - Type checking (native Go port)
- **oxlint** - Linting/formatting (Rust-based)
- **Solidity 0.8.33** - Smart contracts with Foundry
- **Preact + Signals + Tailwind** - Frontend (<400KB bundle)
- **CREATE3** - Deterministic deployments
- **Python/uv** - Simulations in ./sim

**Directories:**
- `contracts/` - Solidity smart contracts (Foundry)
- `front/` - Preact frontend (Vite)
- `back/collector/` - Backend WebSocket server (Bun)
- `sdk/` - TypeScript SDK (source of truth)
- `sim/` - Python simulations (uv)
- `docs/` - User-facing documentation
- `specs/` - Technical specifications (markdown)

---

## 4. Dead Code Zero Tolerance

- NO deprecated code, backward compatibility layers
- NO commented-out code blocks
- NO unused imports, functions, types, variables
- NO "TODO: remove this later" comments
- Delete unused code immediately

---

## 5. Code Quality Standards

**When proposing or reviewing code:**
- **Correct**: Does it do what it should?
- **Elegant**: Is it clean and readable?
- **DRY**: No duplication?
- **Modern**: Current best practices?
- **Minimal**: No over-engineering?
- **Idiomatic**: Follows project patterns?
- **Performant**: No unnecessary overhead?

---

## 6. Communication Style

- **CONCISE**: Brief status updates (1-2 lines)
- **NO** long summaries after tasks
- **NO** verbose explanations unless requested
- **ASK** when unsure
- **REPORT** errors concisely

---

## 7. Git Practices (CONTRIBUTING.md)

- Atomic commits: one focused change per commit
- Prefixes: `[feat]`, `[fix]`, `[docs]`, `[refac]`, `[ops]`
- Imperative mood: "Add" not "Added"
- First line ≤ 72 characters
- **NEVER** mention AI tools in commits
- **NEVER** use AI identity for git commits

---

## 8. SDK = Source of Truth

All token/chain/contract metadata lives in SDK, NOT frontend:
- Tokens/addresses/metadata: `sdk/src/eth/tokens.ts`
- Chain configs: `sdk/src/eth/chains.ts`
- Contract addresses: `sdk/src/eth/contracts.ts`

---

## Agent Injection

All agents MUST include in their principles:
```
- WEBSEARCH FIRST: Before any technical response, use WebSearch to verify current best practices and documentation
- CONSENSUS: Never make non-trivial decisions alone; always involve relevant reviewers
- BTR DEX STACK: Bun (not npm), Solidity 0.8.33, Preact+Signals+Tailwind, CREATE3, tsgo, oxlint
```
