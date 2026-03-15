---
description: "Bootstrap Borris-Flow into this repo or another target directory"
---

Run this to install the Borris-Flow template:

```bash
borris-flow init [TARGET_DIR] [--force]
```

- `TARGET_DIR` defaults to the current directory.
- `--force` allows overwriting existing `.claude` files and `CLAUDE.md`.

Examples:

- `borris-flow init`
- `borris-flow init ./my-project`
- `borris-flow init ./my-project --force`

Use this command when you want the full Borris-Flow workflow in a new project:
- `.claude/` slash commands and agents
- `CLAUDE.md` session guidance
