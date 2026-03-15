<p align="center">
  <img src="./assets/logo.png" alt="Borris-Flow logo" width="180" />
</p>

<h1 align="center">Borris-Flow</h1>
<p align="center">
  <strong>Your Claude-first starter kit for faster, safer feature delivery.</strong>
</p>
<p align="center">
  Inspired by the workflow style popularized by Boris Cherny (create → execute → review):
  <a href="https://x.com/bcherny/status/2007179832300581177" target="_blank">thread</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License" />
  <img src="https://img.shields.io/badge/Version-v1.0.0-blue" alt="Version" />
  <img src="https://img.shields.io/github/stars/itisrmk/Borris-Flow?style=social" alt="GitHub stars" />
</p>

---

## Why teams use Borris-Flow

- ⚡ **Fast onboarding** — drop a consistent local workflow into any repo in one command.
- 🧭 **Parallel execution** — spin up multiple feature streams with isolated worktrees.
- 🔒 **Safe-by-default** — explicit `--dry-run`, clear prompts, and `--force` only when intended.
- 🧰 **Consistent conventions** — reusable `.claude/` and `CLAUDE.md` patterns across projects.
- 🤝 **Reliable handoffs** — generated `TASK.md`, predictable outputs, and clear ownership boundaries.

---

## Quickstart

```bash
# 1) Clone and enter the repo
git clone https://github.com/itisrmk/Borris-Flow.git
cd Borris-Flow

# 2) Install command entrypoints
make install

# 3) Ensure local bin is on PATH
# (if not already set):
export PATH="$HOME/.local/bin:$PATH"
```

```bash
# 4) Scaffold Borris-Flow into a target project
borris-flow init /path/to/your-project

# overwrite scaffold files when needed
borris-flow --force init /path/to/your-project
# (equivalent shorthand)
borris-flow init /path/to/your-project --force
```

```bash
# 5) Start parallel work on multiple tasks
# (run in your target project):
borris-workflow "auth: add SSO login" "ui: improve status banner" "tests: stabilize flakies"

# or from anywhere:
borris-workflow --project-root /path/to/your-project "analytics: reduce p95 latency"
```

> 🚀 **Call to action:** Try one real task now, then inspect generated worktrees and `TASK.md` files for a quick confidence check.

---

## About

Borris-Flow is an independent implementation inspired by Boris Cherny’s workflow framing for Claude Code. It is not a fork and does not copy that code. It focuses on a practical local loop that helps small teams keep conventions stable while scaling from a single-task cadence to parallel execution.

You get a compact set of helpers for creating, executing, and reviewing work with less context drift:

- `.claude/commands/*` and `.claude/agents/*` for repeatable automation
- Clear branch/worktree naming patterns for feature fan-out
- Machine-friendly output for automation tooling

---

## Usage

### 1) Project bootstrap (`borris-flow`)

`borris-flow init` initializes a repo with the workflow skeleton:

- `.claude/`
- `CLAUDE.md`

```bash
# Current repository
borris-flow init

# Target repo
borris-flow init /path/to/your-project

# Overwrite existing scaffold files
borris-flow init /path/to/your-project --force
borris-flow --force init /path/to/your-project
```

`borris-flow` options:

- `--help` (`-h`): show usage
- `--version` (`-V`): print version
- `--force` (`-f`): overwrite scaffold files

### 2) Parallel workflow automation (`borris-workflow`)

Creates isolated worktrees and branches for each requested task:

```bash
# From repo root
borris-workflow "feature: stabilize flaky tests" "feature: improve CLI output"

# From anywhere
borris-workflow --project-root /path/to/repo "feature: add webhook support"
```

Supported flags:

- `--project-root <path>`: target repo explicitly
- `--base <ref>`: branch each feature from a base ref
- `--max <N>`: max auto-launched terminals/workflow runners (default `4`)
- `--launch` / `--no-launch`: control auto-launch behavior
- `--dry-run`: show planned changes with no execution
- `--json`: machine-readable output

```bash
# JSON output is great for scripts/CI
borris-workflow --dry-run --json --project-root /path/to/repo "analytics: reduce p95 latency"
```

Expected JSON sections include:

- `planned`
- `created`
- `results`

### 3) Maintenance commands

```bash
make install        # one-shot install of command entrypoints
make install-force  # force-reinstall entrypoints
make verify         # syntax checks + JSON smoke test
make lint           # alias for verify
make clean          # remove managed ~/.local/bin symlinks
```

See [`EXAMPLES.md`](./EXAMPLES.md) for additional command recipes.

---

## Repository contents

- `borris-flow` — bootstrap CLI
- `borris-workflow` — parallel workflow launcher
- `scripts/borris-workflow.sh` — orchestration engine
- `scripts/install-borris-workflow.sh` — installer helper
- `Makefile` — standard contributor tasks
- `EXAMPLES.md`, `CONTRIBUTING.md`, `RELEASE.md`, `ABOUT.md`

---

## Optional: power-up with Ruflo

Ruflo is optional and intentionally non-blocking:

- `ruflo task create ...`
- `ruflo task list`
- `ruflo task status <id>`

Core workflow remains Claude-first.

---

## License

This project is licensed under the [MIT License](./LICENSE).
