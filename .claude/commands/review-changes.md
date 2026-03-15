---
description: "Review uncommitted changes and suggest improvements"
---

1. Run `git status` and `git diff`
2. For each changed file, evaluate:
   - correctness
   - edge cases
   - conventions
   - security and error handling
3. Return:
   - what looks good
   - what should change
   - recommended next step (`tests`, `tweak`, `commit`, `ask again`)
