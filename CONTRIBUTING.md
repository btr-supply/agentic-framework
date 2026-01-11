# Contributing to BTR-AF

## Project Structure

```
btr-af/
├── agents/              # Agent definitions
│   ├── sibyl.agent.yaml
│   ├── neo.agent.yaml
│   ├── flynn.agent.yaml
│   └── ...
├── workflows/           # Workflow definitions
│   ├── research/
│   ├── development/
│   ├── security/
│   ├── documentation/
│   ├── orchestration/
│   └── ...
├── docs/                # Documentation
│   ├── README.md
│   ├── SETUP.md
│   └── core-principles.md
├── .claude/             # Claude Code integration
│   └── agents/
└── install scripts      # Installation utilities
```

---

## Atomic Commits

**All commits must be atomic** - one focused change per commit.

✅ Good: Add single agent, update one workflow, fix one doc section
❌ Bad: Multiple agents + workflows + docs in one commit

**Rule**: If your commit message needs "and", split it into multiple commits.

---

## Commit Categories

| Category | Prefix | Purpose |
|----------|--------|---------|
| **Feature** | `feat` | New agents, workflows, functionality |
| **Fix** | `fix` | Bug fixes, error corrections |
| **Documentation** | `docs` | Documentation updates only (no code logic) |
| **Refactor** | `refac` | Restructuring, same behavior |
| **Operations** | `ops` | CI/CD, build, tooling, installation scripts |

---

## Branch Naming

Format: `<category>/<brief-description>`

**Rules**:
- Lowercase only
- Separate words with hyphens
- Keep brief (2-4 words)

**Examples**:
- `feat/add-jocasta-agent`
- `feat/security-workflow`
- `fix/workflow-execution`
- `docs/update-setup`
- `refac/agent-structure`
- `ops/install-script`

---

## Commit Messages

Format:
```
[category] Brief description in imperative mood

Optional detailed explanation.
```

**Rules**:
1. Prefix: `[category]` in lowercase
2. Imperative mood: "Add" not "Added"
3. First line ≤ 72 characters
4. Optional body after blank line
5. **NEVER mention AI tools** (Claude, GPT, Copilot, etc.) in commit messages

**Examples**:

✅ Good:
```
[feat] Add Jocasta agent for technical writing
[feat] Add security audit workflow
[fix] Correct workflow orchestration logic
[docs] Update agent configuration guide
[refac] Reorganize workflow structure
[ops] Update installation script
```

❌ Bad:
```
Update stuff
Fixed things
feat: Add feature (wrong format)
[FEAT] Add (uppercase)
Co-Authored / Generated with Claude (never mention AI)
```

---

## Pull Requests

**Title**: Same format as commit messages: `[category] Brief description`

**Size**:
- Small: < 200 lines (ideal)
- Medium: 200-500 lines (acceptable)
- Large: > 500 lines (split into smaller PRs)

---

## Dead Code Policy

**⚠️ ZERO TOLERANCE for dead code**

- ❌ NO deprecated code or backward compatibility layers
- ❌ NO commented-out code blocks
- ❌ NO unused agent definitions or workflows
- ❌ NO "TODO: remove this later" comments
- ✅ Delete unused agents/workflows immediately
- ✅ Update all references when refactoring
- ✅ Clean slate - if it's not used, it's gone

**When refactoring:**
1. Update all usages first
2. Delete old code completely
3. No transition period with both versions

---

## Pre-Commit Checklist

- [ ] Change is atomic (one logical change)
- [ ] Correct category prefix used
- [ ] Commit message in imperative mood
- [ ] First line ≤ 72 characters
- [ ] No AI tool mentions in comments or commit messages
- [ ] YAML files are valid
- [ ] Only related files included
- [ ] No dead code or unused definitions

---

## Comment Policy

**Concise but informative - explain WHY, not WHAT**

| Keep | Remove |
|------|--------|
| Non-obvious logic, design decisions | Decorative ASCII art, verbose headers |
| Agent role rationale | Obvious descriptions |
| Workflow orchestration dependencies | Redundant explanations |
| Critical constraints | Trivial comments |

**When in doubt**: A comment that saves a future reader 5 minutes of head-scratching is worth keeping.

---

## Code Philosophy

**Performance. Elegant. Signal-Driven. DRY. Concise.**

| Principle | Description |
|-----------|-------------|
| **Lean** | Minimal dependencies, clean structure |
| **DRY** | Don't repeat yourself - extract common patterns |
| **No over-abstraction** | Three similar lines is better than premature abstraction |
| **Consistent formatting** | Follow existing YAML/markdown style |
| **Silent** | No emojis, minimal verbose output |

---

## Problem Solving (For AI Agents)

**When you don't know how to do something:**

1. **WebSearch first** - Use WebSearch to find current information
2. **Ask second** - If web search doesn't help, ask the user

**Examples**:
- Don't know a CLI flag? → WebSearch it
- Unclear about a tool feature? → WebSearch official docs
- Need installation instructions? → WebSearch the official guide

---

## Releases and Versioning

**Version Tags:**
- Use semantic versioning: `v1.0.0`, `v1.1.0`, `v2.0.0`
- The `latest` tag always points to the most recent stable release
- Users can install with `latest` for convenience or specific versions for reproducibility

**Semantic Versioning:**
- `v1.0.0` → `v1.0.1`: Patch (bug fixes, documentation)
- `v1.0.0` → `v1.1.0`: Minor (new features, backward compatible)
- `v1.0.0` → `v2.0.0`: Major (breaking changes)

**Creating a New Release:**

1. **Make and test your changes** on the `main` branch

2. **Update version in package.json:**
   ```bash
   # Edit package.json, change version field
   ```

3. **Update version references in README.md:**
   ```bash
   # Replace old version (e.g., v1.0.1) with new version (e.g., v1.0.2) in examples
   ```

4. **Commit version bump:**
   ```bash
   git add package.json README.md
   git commit -m "[ops] Bump version to vX.Y.Z"
   git push origin main
   ```

5. **Create version tag:**
   ```bash
   git tag -a vX.Y.Z -m "BTR-AF vX.Y.Z - Brief description"
   git push origin vX.Y.Z
   ```

6. **Move the `latest` tag:**
   ```bash
   # Delete old latest tag locally
   git tag -d latest

   # Create new latest tag pointing to the new version (use ^{} to point to commit, not tag)
   git tag -a latest -m "Alias for latest stable release (currently vX.Y.Z)" vX.Y.Z^{}

   # Force push latest tag to remote
   git push -f origin latest
   ```

7. **Create GitHub Release:**
   ```bash
   gh release create vX.Y.Z \
     --title "vX.Y.Z - Release Title" \
     --notes "## Changes

   - Feature or fix 1
   - Feature or fix 2

   ## Installation

   See README.md for installation instructions."
   ```

8. **Verify:**
   ```bash
   # Check that latest and vX.Y.Z point to the same commit
   git rev-parse latest^{}
   git rev-parse vX.Y.Z^{}

   # Should output the same commit hash
   ```

**Example Release Workflow:**

```bash
# Bump version to v1.0.2
vim package.json  # Change version to 1.0.2
vim README.md     # Update v1.0.1 → v1.0.2 in examples

git add package.json README.md
git commit -m "[ops] Bump version to v1.0.2"
git push origin main

# Create version tag
git tag -a v1.0.2 -m "BTR-AF v1.0.2 - Bug fixes and improvements"
git push origin v1.0.2

# Move latest tag
git tag -d latest
git tag -a latest -m "Alias for latest stable release (currently v1.0.2)" v1.0.2^{}
git push -f origin latest

# Create GitHub Release
gh release create v1.0.2 --title "v1.0.2 - Bug Fixes" --notes "..."

# Verify
git rev-parse latest^{} && git rev-parse v1.0.2^{}
```

**Important Notes:**
- Always use `vX.Y.Z^{}` when creating the `latest` tag to point to the commit, not the tag object
- Force push is required for `latest` tag since it moves to different commits
- The `latest` tag should only point to stable releases, never to `main` branch directly

---

## Agent Git Identity

**⚠️ Always use the user's git identity**

- ❌ NEVER use agent or AI identity for git commit authors or co-authors
- ✅ Use the user's configured git identity

---

## Agent Communication Style

**Keep responses SHORT**

- ❌ NO long summaries/verbose explanations
- ✅ Brief status (1-2 lines), ask when needed

---

## Agent Definitions

**Adding a new agent:**
1. Create `agents/<name>.agent.yaml` with proper role definition
2. Create corresponding `.claude/agents/<name>.md` if needed
3. Document agent's purpose and capabilities
4. Use atomic commit: `[feat] Add <name> agent for <purpose>`

---

## Workflow Definitions

**Adding a new workflow:**
1. Create workflow in appropriate category folder
2. Follow existing workflow structure
3. Document workflow purpose and steps
4. Use atomic commit: `[feat] Add <category> workflow`

---

## File Organization

**Agents**: Each agent in separate YAML file
**Workflows**: Organized by category (research, development, security, etc.)
**Docs**: Keep documentation focused and up-to-date
**No orphaned files**: Every file must have a clear purpose

---

## Related Documentation

- [`README.md`](./README.md) - Project overview and installation
- [`CLAUDE.md`](./CLAUDE.md) - AI agent instructions
