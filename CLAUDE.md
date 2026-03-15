# CLAUDE.md — Borris-Flow

This repository uses a compact Claude workflow for fast, reliable edits with verification.

## Rules

1. **Plan before large changes.** For substantial edits, outline scope, risks, and verification first.
2. **Small, reviewable steps.** Make minimal diffs; avoid broad refactors unless requested.
3. **Verify always.** Run at least one relevant validation command before considering work complete.
4. **Prefer behavior preservation.** Do not change public behavior/API without explicit direction.
5. **Be explicit.** Explain assumptions, trade-offs, and blockers clearly.
6. **No blind approvals.** Reviewers and automated checks must be respected before merge.
7. **Keep it practical.** Favor clear, maintainable, boring solutions over cleverness.

## Default verification expectations

Run the repo’s project checks when available:

- `npm test` / `pnpm test` / equivalent
- `npm run lint`
- `npm run typecheck`
- `npm run build`

If a command does not exist, skip it and proceed with the most relevant applicable checks.

## Built-in workflows

Use these slash-command files under `.claude/commands/`:

- `/commit-push-pr`
- `/quick-commit`
- `/test-and-fix`
- `/review-changes`
- `/grill`
- `/techdebt`
- `/worktree`

## Agent roster

Use `.claude/agents/` files when you need dedicated passes:

- `code-simplifier`
- `code-architect`
- `verify-app`
- `build-validator`
- `staff-reviewer`
- `oncall-guide`
