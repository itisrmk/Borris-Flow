# Release Notes: Borris-Flow

## What's Included

- Claude-first local template bootstrapping (`borris-flow`)
- Parallel worktree orchestration (`/workflow` + `borris-workflow`)
- Idempotent installer for global command access
- Makefile lifecycle commands
- Usage docs + examples

## Release Readiness Checklist

- [x] Core scripts present and executable
  - `borris-flow`
  - `borris-workflow`
  - `scripts/borris-workflow.sh`
  - `scripts/install-borris-workflow.sh`
- [x] Validation passes
  - `make verify`
- [x] Docs complete
  - `README.md`
  - `EXAMPLES.md`
- [x] Contribution docs added
  - `CONTRIBUTING.md`
  - `LICENSE`
  - `.gitignore`
- [x] Installability
  - `make install` and global command availability

## Publishing steps

1. Ensure all checks pass:
   ```bash
   make verify
   ```
2. Commit with a release-oriented message.
3. Tag a release:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push --tags
   ```
4. (Optional) add GitHub release notes with example usage and changelog highlights.
