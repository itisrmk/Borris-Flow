# Borris-Flow Usage Examples

These examples show practical commands for setup and day-to-day workflow usage.

## One-shot install

From the repo root:

```bash
make install
```

Equivalent direct install command:

```bash
./scripts/install-borris-workflow.sh
```

Run with force when you want to replace existing command links:

```bash
make install-force
```

## Global vs local usage

You can run Borris-Flow in two ways:

- **Global install (recommended for frequent use):** after one-shot install, commands are available anywhere in your shell.
  ```bash
  # from any directory
  borris-flow init ~/dev/my-app
  borris-workflow --dry-run --json "feature: align architecture docs"
  ```

- **Local/inline usage (no global install required):** run directly from the repo folder.
  ```bash
  # from Borris-Flow repo root
  ./borris-flow init ~/dev/my-app
  ./scripts/borris-workflow.sh "feature: align architecture docs"
  ```

## Workflow command examples

### 1) Launching Claude terminals (default)

```bash
./scripts/borris-workflow.sh --project-root ~/dev/my-app "auth: add OAuth refresh flow"
```

### 2) No-launch mode (prepare worktrees only)

```bash
./scripts/borris-workflow.sh --no-launch --project-root ~/dev/my-app "api: normalize error envelope"
```

### 3) Dry-run preview

```bash
./scripts/borris-workflow.sh --dry-run --project-root ~/dev/my-app "ui: modernize button components"
```

### 4) JSON output for tooling

```bash
./scripts/borris-workflow.sh --json --project-root ~/dev/my-app "docs: update CONTRIBUTING"
```

```bash
borris-workflow --dry-run --json "analytics: add tracing and alerting"
```

## Multi-feature example

Create multiple worktrees in one command:

```bash
./scripts/borris-workflow.sh \
  "api: add endpoint for dashboard metrics" \
  "ui: refresh settings page" \
  "docs: tighten onboarding workflow guide"
```

Or run globally with launch control:

```bash
borris-workflow --max 2 --no-launch \
  "api: add endpoint for dashboard metrics" \
  "ui: refresh settings page" \
  "docs: tighten onboarding workflow guide"
```
