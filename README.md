<div align="center">

# Borris-Flow

![Borris-Flow logo](./assets/logo.png)

**Your Claude-first starter for fast, safe, parallel software delivery.**

Inspired by Boris Cherny's workflow thread: https://x.com/bcherny/status/2007179832300581177

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Version](https://img.shields.io/badge/Version-v1.0.0-blue)](https://github.com/itisrmk/Borris-Flow/releases/tag/v1.0.0)
[![GitHub stars](https://img.shields.io/github/stars/itisrmk/Borris-Flow?style=social)](https://github.com/itisrmk/Borris-Flow)

</div>

> **Borris-Flow** is an open starter that turns Claude Code into an operational workflow:
> **create → execute → review**, with clean handoffs and repeatable local conventions.

---

## Why teams use Borris-Flow

- 🚀 **Boot up fast** with `borris-flow` and get a full Claude local command/agent structure instantly.
- 🧠 **Parallelize safely** with `/workflow`-style worktrees so multiple features can run independently.
- 🧰 **Consistent developer routine** with built-in `.claude/commands` and `.claude/agents`.
- 🛡️ **Safe by default** with confirmation prompts, `--dry-run`, and `--force` gates.
- 🤖 **Automation-friendly** with stable `--json` output and predictable tooling contracts.

---

## Quick start

```bash
git clone https://github.com/itisrmk/Borris-Flow.git
cd Borris-Flow
make install
```

If `~/.local/bin` is not in PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Now install this template into any project:

```bash
borris-flow init /path/to/your-project
# overwrite if needed:
borris-flow --force init /path/to/your-project
```

---

## Core capabilities

### 1) Project bootstrap (`borris-flow`)

- Scaffolds `.claude/` and `CLAUDE.md`
- Keeps setup predictable and deterministic
- Reusable across repos with explicit `--force` behavior

```bash
borris-flow init                   # current repo
borris-flow init ./my-repo --force  # replace template files
```

### 2) Parallel execution (`borris-workflow`)

From repo root:

```bash
borris-workflow "auth: add SSO login" "ui: improve status banner" "tests: stabilize flakies"
```

From anywhere (after install):

```bash
borris-workflow --project-root /path/to/repo "analytics: stabilize flaky tests"
```

Supports:
- `--project-root` target explicit repo
- `--base` base ref/branch
- `--max` terminal fan-out
- `--launch` / `--no-launch`
- `--dry-run`
- `--json`

### JSON automation example

```bash
borris-workflow --dry-run --json --project-root /path/to/repo "analytics: reduce p95 latency"
```

The result includes:
- `planned` (requested feature plans)
- `created` (actually created worktrees)
- `results` (per-item execution summary)

### 3) Installer and maintenance

```bash
make install        # install global commands into ~/.local/bin
make install-force  # overwrite existing installs
make verify         # syntax checks + workflow smoke
make lint           # alias for verify
make clean          # remove managed symlinks
```

---

## What you get in this repo

- `borris-flow` — bootstrap CLI
- `borris-workflow` — global command wrapper
- `scripts/borris-workflow.sh` — orchestration engine
- `scripts/install-borris-workflow.sh` — one-shot installer
- `Makefile` — standard tasks
- `EXAMPLES.md` — practical multi-scenario snippets
- `CONTRIBUTING.md`, `RELEASE.md`, `ABOUT.md`
- `.claude/commands/*` and `.claude/agents/*`

---

## About this repo

This is intentionally **Boris-inspired** and **Claude-first**, not a fork.

It is explicitly inspired by Boris Cherny’s workflow framing for Claude Code (create/execute/review), as described here:
https://x.com/bcherny/status/2007179832300581177.

We adapt the structure and intent so teams can ship faster with less context churn.

---

## Optional: add Rufflo when needed

Ruflo is optional and power-user only:

- `ruflo task create ...`
- `ruflo task list`
- `ruflo task status <id>`

Core workflow remains Claude-first.

---

## License

MIT — see [LICENSE](./LICENSE).
