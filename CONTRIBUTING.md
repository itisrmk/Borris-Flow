# Contributing to Borris-Flow

Thanks for your interest in improving this project.

## Install

- Install dependencies (if any): this repo is shell-script based, no package
  install step required.
- Bootstrap global commands for local testing:

  ```bash
  make install
  # or
  ./scripts/install-borris-workflow.sh
  ```

- Ensure `~/.local/bin` is on your `PATH` (if using the installer):

  ```bash
  export PATH="$HOME/.local/bin:$PATH"
  ```

## Verify

Before opening a PR, run the verification commands and report results:

- `make verify` (syntax check + dry-run workflow smoke test)
- `bash -n borris-flow`
- `bash -n borris-workflow`
- `bash -n scripts/install-borris-workflow.sh`
- `bash -n scripts/borris-workflow.sh`

### Manual smoke checks (recommended)

- `borris-flow --help`
- `borris-workflow --help`
- `borris-workflow --dry-run --json "test: example prompt"`

## Coding and testing expectations

- Keep changes minimal and targeted.
- Preserve existing behavior; avoid changing script semantics unless explicitly
  requested.
- Prefer shell-safe patterns already used in this repo.
- If you add/modify scripts, run `make verify` and the relevant `bash -n`
  checks.
- Document any intentional behavior changes in your PR description.

## PR workflow

1. Fork or branch from the target branch.
2. Make your changes in small, focused commits.
3. Run `make verify` and include the output in the PR description.
4. Open a pull request with:
   - what changed and why,
   - verification output,
   - any open questions or risks.
5. Iterate on review feedback and keep the diff small and clear.

## Release note

This project is designed to stay lightweight and production-safe. Aim for:
small diffs, clear intent, and clean execution.

## Project maintenance docs

Keep `agents.md` and `logs.md` up to date for each meaningful work cycle:

- update `agents.md` when roles, process, or ownership expectations change
- append a new entry in `logs.md` after each significant implementation/verification session
- this makes handoffs and future maintenance decisions traceable
