# Borris-Flow Project Agents

## Purpose
This file defines the human + AI agent workflow for this repository.

## Team roles

### 1) Implementer
- Owns concrete code/config/docs changes.
- Keeps edits minimal and scoped to task.
- Verifies local behavior (`make verify`, targeted smoke checks) before handing off.
- Notes assumptions and edge cases in `logs.md`.

### 2) Verifier
- Replays change impact from a second perspective.
- Checks syntax checks and behavior checks still pass.
- Confirms docs match implementation.
- Reports gaps before merge.

### 3) Maintainer (Rahul)
- Final decision-maker for feature direction.
- Keeps repository direction coherent and contributor-friendly.
- Reviews and merges only after check evidence is present.

## Escalation and quality rules

- If a command behavior changes, update:
  - `README.md`
  - `EXAMPLES.md`
  - release notes as needed
- If `make verify` fails, pause and fix before next commit.
- No behavior changes without an updated usage sample.

## Review checklist

- [ ] Scripts pass `bash -n`
- [ ] Workflow smoke test is stable (`--dry-run --json`)
- [ ] README usage examples are accurate
- [ ] Attribution statement stays accurate
- [ ] GitHub-facing docs remain clean and actionable

## Communication style for collaborators

- Keep notes short, decision-focused, and explicit.
- Use plain English with command snippets when possible.
- Prefer incremental commits and clear commit messages.
