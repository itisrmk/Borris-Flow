<p align="center">
  <img src="./assets/logo.png" alt="Borris-Flow logo" width="180" />
</p>

<h1 align="center">Borris-Flow</h1>
<p align="center">
  <strong>Your Claude-first starter for faster, safer feature delivery.</strong>
</p>
<p align="center">
  <strong>Inspired by <a href="https://x.com/bcherny/status/2007179832300581177" target="_blank">Boris Cherny’s create → execute → review workflow</a>.</strong>
</p>
<p align="center">
  <strong>Attribution:</strong> this project is independently implemented and does not copy Boris Cherny’s original code.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License" />
  <img src="https://img.shields.io/badge/Version-v1.0.2-blue" alt="Version" />
  <a href="https://www.npmjs.com/package/borris-flow"><img src="https://img.shields.io/npm/v/borris-flow.svg" alt="npm version" /></a>
  <a href="https://www.npmjs.com/package/borris-flow"><img src="https://img.shields.io/npm/dt/borris-flow.svg" alt="npm downloads" /></a>
  <img src="https://img.shields.io/github/stars/itisrmk/Borris-Flow?style=social" alt="GitHub stars" />
</p>

---

## Why teams use Borris-Flow

- ⚡ **Fast onboarding** — one command to add a consistent local Claude workflow to any repo.
- 🧭 **Parallel execution** — scale feature delivery through isolated worktrees.
- 🔒 **Safe by default** — explicit `--force`, clear prompts, and `--dry-run` for risk-free planning.
- 🧰 **Consistent conventions** — reusable `.claude/` and `CLAUDE.md` structure across projects.
- 🤝 **Reliable handoffs** — task prompts in `TASK.md` and machine-readable output for tooling.

---

## Quickstart

### 1) Install the toolchain

```bash
# Option A: npm (recommended for users)
npm install -g borris-flow

# Option B: local install from source
# Clone and enter the repo
# https://github.com/itisrmk/Borris-Flow.git
git clone https://github.com/itisrmk/Borris-Flow.git
cd Borris-Flow

# Install global entrypoints
make install

# Add ~/.local/bin to PATH (if needed)
export PATH="$HOME/.local/bin:$PATH"
```

### 2) Scaffold a project

```bash
# Scaffold in the current repo
borris-flow init

# Scaffold a target repo
borris-flow init /path/to/your-project

# Overwrite when needed
borris-flow init /path/to/your-project --force
borris-flow --force init /path/to/your-project
```

### 3) Run your first workflow

```bash
# Run parallel tasks from project root
borris-workflow "auth: add SSO login" "ui: improve status banner" "tests: stabilize flakies"

# Or from anywhere
borris-workflow --project-root /path/to/your-project "analytics: reduce p95 latency"
```

> Tip: run with `--dry-run` first to preview everything before creating branches and worktrees.

---

## Usage

### 1) Project bootstrap (`borris-flow`)

`borris-flow` creates the workflow scaffold:

```bash
borris-flow init
borris-flow init /path/to/repo
borris-flow init /path/to/repo --force
borris-flow --force init /path/to/repo
```

Supported options:

- `--help` (`-h`) — show usage
- `--version` (`-V`) — show version
- `--force` (`-f`) — overwrite scaffold files

### 2) Parallel workflow automation (`borris-workflow`)

Create isolated branches/worktrees for each task:

```bash
borris-workflow "feature: stabilize flaky tests" "feature: improve CLI output"

borris-workflow --project-root /path/to/repo --json "feature: add webhook support"
borris-workflow --dry-run "feature: preview without changes"
```

Supported flags:

- `--project-root <path>` — target repo
- `--base <ref>` — base branch/ref (default: current branch)
- `--max <N>` — max number of auto-launched terminals
- `--launch` / `--no-launch` — control Claude terminal startup
- `--dry-run` — show plans only
- `--json` — machine-readable output
- `--help`

Expected JSON sections:

- `planned`
- `created`
- `results`

### 3) Maintenance

```bash
make install        # one-shot install entrypoints
make install-force  # overwrite symlinks if needed
make verify         # script syntax checks + JSON smoke test
make lint           # alias for verify
make clean          # remove managed ~/.local/bin links
```

Need concrete recipes? See [`EXAMPLES.md`](./EXAMPLES.md).

---

## Repository contents

- **`borris-flow`** — bootstrap CLI to install workflow conventions.
- **`borris-workflow`** — orchestrates parallel feature worktrees.
- **`scripts/borris-workflow.sh`** — core workflow engine.
- **`scripts/install-borris-workflow.sh`** — one-step installer.
- **`Makefile`** — `install`, `verify`, `lint`, `clean`.
- `.claude/commands/*`, `.claude/agents/*` — reusable coding workflows and roles.
- **Docs & process** — `EXAMPLES.md`, `CONTRIBUTING.md`, `RELEASE.md`, `ABOUT.md`.

---

## Optional: power-up with Ruflo

Ruflo is optional and intentionally non-blocking.

- `ruflo task create ...`
- `ruflo task list`
- `ruflo task status <id>`

Core workflow remains Claude-first.

---

## License

This project is released under the [MIT License](./LICENSE).
