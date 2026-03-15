# Borris-Flow

**Borris-Flow** is a lightweight Claude Code starter kit for solo and small-team engineering teams that want a practical **workflow-inspired** setup: reliable local conventions, fast task parallelization, and clean handoffs.

It is explicitly inspired by Boris Cherny’s public workflow framing for Claude Code (create/execute/review), as described in this thread: https://x.com/bcherny/status/2007179832300581177. This project is an independent implementation and only mirrors the workflow approach.

Built around `claude`, the repository gives you:

- A ready-to-use local CLI scaffold (`borris-flow`)
- Parallel feature execution across git worktrees (`/workflow`)
- Consistent command/agent conventions for review, testing, and commits
- One-command global install and verification ergonomics

---

## About this repo

This project is designed to make Claude Code a first-class local development workflow, not a sidecar. It bakes in:

- **Context discipline** (`CLAUDE.md` + `.claude/agents/*` + `.claude/commands/*`)
- **Safe automation** (`--dry-run`, prompt-based overwrite, explicit `--force`)
- **Parallel execution** (`scripts/borris-workflow.sh`)
- **Reusable contributor loop** (Makefile + docs + templates)

---

## Why Borris-Flow?

Most local setups drift into one-off scripts and one-off workflows. Borris-Flow gives you a repeatable baseline so every repo can start with the same conventions and every task can be kicked off the same way.

- Quick onboarding for Claude Code in new projects
- Easy feature fan-out without context switching
- Clear task handoffs through generated `TASK.md`
- Machine-readable workflow output for automation

---

## Install

### 1) Clone or copy this repo

```bash
git clone https://github.com/itisrmk/Borris-Flow.git
cd Borris-Flow
```

### 2) Install global commands

```bash
make install
# or:
./scripts/install-borris-workflow.sh
```

You can rerun with force when needed:

```bash
make install-force
```

Ensure `~/.local/bin` is on PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

---

## Bootstrapping a project

Use `borris-flow` to scaffold `.claude` and `CLAUDE.md` into a project:

```bash
# Current repo
borris-flow init

# Target repo
borris-flow init /path/to/your-project

# Overwrite existing scaffold files
borris-flow init /path/to/your-project --force
# or
borris-flow --force init /path/to/your-project
```

### `borris-flow` options

- `--help` (`-h`): show usage
- `--version` (`-V`): print version
- `--force` (`-f`): overwrite on install

`init` copies:
- `.claude/`
- `CLAUDE.md`

---

## Parallel workflow automation (`/workflow`)

After a project is initialized, kick off multiple feature streams from repo root:

```bash
borris-workflow "auth: add SSO login" "ui: improve status banner" "tests: stabilize flakies"
```

Or from anywhere (once installed):

```bash
borris-workflow --project-root /path/to/repo "feature: stabilize flaky tests"
```

### Options

- `--project-root <path>`: target repo explicitly
- `--base <ref>`: branch each feature from current branch by default
- `--max <N>`: max auto-launched Claude terminals (default `4`)
- `--launch` / `--no-launch`: control auto-launch behavior
- `--dry-run`: preview only, no changes
- `--json`: machine-readable output
- `--help`: usage

### What it does

1. Creates `.claude/worktrees/<slug>` worktrees
2. Creates branches like `workflow/<slug>`
3. Initializes Borris-Flow inside each worktree
4. Writes `TASK.md` per feature
5. Launches Claude terminals (or prints manual commands when launch is not available)

### JSON mode

```bash
borris-workflow --dry-run --json --project-root /path/to/repo "analytics: stabilize flaky tests"
borris-workflow --json "api: add webhooks" "ui: improve status banner"
```

Response shape includes `planned`, `created`, and `results` arrays for tooling.

---

## Development workflow

```bash
make install        # one-shot install of command entrypoints
make install-force  # force-reinstall entrypoints
make verify         # scripts syntax + JSON smoke test
make lint           # alias for verify
make clean          # remove managed ~/.local/bin symlinks
```

See [`EXAMPLES.md`](./EXAMPLES.md) for real command recipes.

---

## Repository hygiene

- `LICENSE`: MIT license
- `CONTRIBUTING.md`: contribution workflow
- `.gitignore`: clean working trees for publish
- `RELEASE.md`: release steps and checklist

---

## Optional: power-up with Ruflo

Ruflo remains optional and is intentionally non-blocking:

- `ruflo task create ...`
- `ruflo task list`
- `ruflo task status <id>`

Core workflow remains Claude-first.

---

## Inspiration

This release explicitly credits **Boris Cherny** and his public thread: https://x.com/bcherny/status/2007179832300581177.

We adapted only the **workflow pattern** (create/execute/review cycles and safe local conventions). This repository is an independent implementation and does not copy Boris's code.

## License

This project is licensed under the [MIT License](./LICENSE).
