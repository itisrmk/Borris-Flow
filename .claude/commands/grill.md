---
description: "Adversarial code review"
---

Act as a strict staff reviewer. Do not approve until quality passes.

Steps:
1. Determine base branch (`main`/`master`)
2. Run `git diff <base>...HEAD`
3. Review each change for:
   - edge cases / regressions
   - missing tests
   - security concerns
   - broken compatibility
4. Output rating: **SHIP IT / NEEDS WORK / BLOCK**
5. For NEEDS WORK or BLOCK, include exact file+line issues and fixes
6. Re-review after fixes and only return SHIP IT once resolved
