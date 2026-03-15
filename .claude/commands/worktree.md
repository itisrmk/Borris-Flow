---
description: "Create a git worktree for parallel Claude sessions"
---

1. Derive worktree name (e.g., `YYYY-MM-DD-feature` if not provided)
2. Run `git worktree add .claude/worktrees/$name origin/main`
3. Confirm with `git worktree list`
4. Print command to open: `cd .claude/worktrees/$name && claude`
5. Reminder:
   - List: `git worktree list`
   - Remove: `git worktree remove .claude/worktrees/$name`
