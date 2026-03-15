---
description: "Commit, push, and open a PR"
---

Follow these steps in order:

1. Run `git status` and inspect changed files
2. Run `git diff` to review what changed
3. Stage intended files with `git add`
4. Create a clear commit message (Conventional Commits)
5. Push branch (`git push -u origin <branch>` when needed)
6. Open PR with `gh pr create` including:
   - Why this change
   - What was changed
   - How it was tested
7. If any step fails, stop and report the blocker
