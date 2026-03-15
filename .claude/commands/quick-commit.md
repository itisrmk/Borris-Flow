---
description: "Stage all changes and commit with a descriptive message"
---

1. Run `git status`
2. Run `git diff` to understand changes
3. Stage everything with `git add -A`
4. Commit with Conventional Commit format:
   - `<type>(scope?): <imperative summary>`
   - examples: `feat: add offline queue`, `fix(auth): validate token expiration`
