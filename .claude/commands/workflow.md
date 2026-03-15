---
description: "Automate parallel worktree+Claude sessions for multiple features"
---

Use this for coordinated parallel work.

Run from repo root (or point explicitly with `--project-root`):

```bash
./scripts/borris-workflow.sh "feature A: implement login" "feature B: add caching"
```

(If installed globally, same command can be run as `borris-workflow ...`)

Options:
- `--project-root <path>`: explicit repo root
- `--base <ref>`: branch base ref (default current branch)
- `--max <N>`: only auto-launch first N Claude sessions (default `4`)
- `--no-launch`: create worktrees + TASK only
- `--launch`: force launch (default behavior)
- `--dry-run`: preview actions without making changes
- `--json`: output machine-readable summary
- `--help`: show usage

Examples:

```bash
# two features, auto-launch sessions
./scripts/borris-workflow.sh "auth: add SSO" "ui: add status banner"

# initialize in another repo, no terminal launch
./scripts/borris-workflow.sh --project-root ../other-repo --no-launch "api: add webhook retries"

# preview and consume JSON
./scripts/borris-workflow.sh --dry-run --json "analytics: stabilize flakies"
```
