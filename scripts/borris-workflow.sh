#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_PATH" ]; do
  SCRIPT_PATH="$(readlink "$SCRIPT_PATH")"
done
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
TEMPLATE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_CLAUDE_DIR="$TEMPLATE_ROOT/.claude"
TEMPLATE_CLAUDE_MD="$TEMPLATE_ROOT/CLAUDE.md"

usage() {
  cat <<'EOF'
Usage:
  borris-workflow [options] "feature" "feature 2" ...

Options:
  --base <branch-or-ref>   Base git ref/branch for new worktrees (default: current branch)
  --project-root <path>    Project root where worktrees should be created (default: current git repo)
  --max <N>               Max number of auto-launched Claude terminals (default: 4)
  --launch                Force terminal auto-launch (default: on)
  --no-launch             Skip auto-launch and only print commands
  --dry-run               Show planned actions without modifying anything
  --json                  Emit JSON summary output
  --help, -h              Show this help

Feature format:
  "name: prompt" or "name"
EOF
}

log() {
  if [ "$JSON_MODE" -eq 0 ]; then
    echo "$*"
  fi
}

err() {
  echo "error: $*" >&2
}

trim() {
  local value="$1"
  printf '%s' "$value" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'
}

run_git() {
  if [ "$JSON_MODE" -eq 1 ]; then
    "$@" >/dev/null 2>&1
  else
    "$@"
  fi
}

slugify() {
  local s="$1"
  s="$(printf '%s' "$s" | tr '[:upper:]' '[:lower:]' | sed -E 's/[[:space:]]+/-/g; s/[^a-z0-9._-]+/-/g; s/-{2,}/-/g; s/^[-.]+//; s/[-.]+$//')"
  if [ -z "$s" ]; then
    s="feature"
  fi
  echo "$s"
}

json_escape() {
  python3 - "$1" <<'PY'
import json
import sys
print(json.dumps(sys.argv[1]), end="")
PY
}

launch_claude() {
  local path="$1"
  local name="$2"

  if command -v tmux >/dev/null 2>&1; then
    if ! tmux has-session -t "$name" 2>/dev/null; then
      tmux new-session -d -s "$name" "cd '$path' && claude"
    fi
    return 0
  fi

  if command -v osascript >/dev/null 2>&1; then
    osascript <<OSA
      tell application "Terminal"
        activate
        do script "cd '$path' && claude"
      end tell
OSA
    return 0
  fi

  if command -v gnome-terminal >/dev/null 2>&1; then
    gnome-terminal -- bash -lc "cd '$path' && claude"
    return 0
  fi

  if command -v xterm >/dev/null 2>&1; then
    xterm -e bash -lc "cd '$path' && claude" &
    return 0
  fi

  return 1
}

copy_template() {
  local target="$1"
  local force="$2"  # 1/0

  python3 - "$target" "$TEMPLATE_CLAUDE_DIR" "$TEMPLATE_CLAUDE_MD" "$force" <<'PY'
from pathlib import Path
import shutil
import sys


def copy_file(src, dst, force):
    if dst.exists() and not force:
        return
    dst.parent.mkdir(parents=True, exist_ok=True)
    if src.is_dir():
        dst.mkdir(parents=True, exist_ok=True)
    else:
        shutil.copy2(src, dst)


def sync(src: Path, dst: Path, force: bool):
    for child in src.iterdir():
        if child.name in {".git", "worktrees"} and src.name == ".claude":
            continue

        target_child = dst / child.name
        if child.is_dir():
            target_child.mkdir(parents=True, exist_ok=True)
            sync(child, target_child, force)
        else:
            copy_file(child, target_child, force)


target = Path(sys.argv[1])
template_dir = Path(sys.argv[2])
template_md = Path(sys.argv[3])
force = sys.argv[4] == "1"

if not template_dir.is_dir() or not template_md.is_file():
    raise SystemExit("template source missing")

sync(template_dir, target / ".claude", force)
copy_file(template_md, target / "CLAUDE.md", force)
PY
}

append_json_item() {
  local target_name="$1"
  local item="$2"

  case "$target_name" in
    RESULTS_JSON)
      if [ -z "$RESULTS_JSON" ]; then
        RESULTS_JSON="$item"
      else
        RESULTS_JSON="$RESULTS_JSON,$item"
      fi
      ;;
    PLANNED_JSON)
      if [ -z "$PLANNED_JSON" ]; then
        PLANNED_JSON="$item"
      else
        PLANNED_JSON="$PLANNED_JSON,$item"
      fi
      ;;
    CREATED_JSON)
      if [ -z "$CREATED_JSON" ]; then
        CREATED_JSON="$item"
      else
        CREATED_JSON="$CREATED_JSON,$item"
      fi
      ;;
    *)
      err "Unknown json list: $target_name"
      ;;
  esac
}

if [ "$#" -eq 0 ]; then
  usage
  exit 1
fi

BASE_REF=""
PROJECT_ROOT_INPUT=""
MAX_LAUNCH=4
LAUNCH=1
DRY_RUN=0
JSON_MODE=0
FEATURES=()
RESULTS_JSON=""
PLANNED_JSON=""
CREATED_JSON=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --base|--base-branch)
      BASE_REF="${2:-}"
      if [ -z "$BASE_REF" ]; then
        err "--base requires a value"
        exit 1
      fi
      shift 2
      ;;
    --project-root)
      PROJECT_ROOT_INPUT="${2:-}"
      if [ -z "$PROJECT_ROOT_INPUT" ]; then
        err "--project-root requires a value"
        exit 1
      fi
      shift 2
      ;;
    --max)
      MAX_LAUNCH="${2:-}"
      if ! [[ "$MAX_LAUNCH" =~ ^[0-9]+$ ]] || [ "$MAX_LAUNCH" -lt 1 ]; then
        err "--max must be a positive integer"
        exit 1
      fi
      shift 2
      ;;
    --launch)
      LAUNCH=1
      shift
      ;;
    --no-launch)
      LAUNCH=0
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --json)
      JSON_MODE=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --*)
      err "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      FEATURES+=("$1")
      shift
      ;;
  esac
 done

if [ "${#FEATURES[@]}" -eq 0 ]; then
  err "No features provided"
  usage
  exit 1
fi

if [ ! -d "$TEMPLATE_CLAUDE_DIR" ] || [ ! -f "$TEMPLATE_CLAUDE_MD" ]; then
  err "Template source missing at $TEMPLATE_ROOT"
  exit 1
fi

if [ -z "$PROJECT_ROOT_INPUT" ]; then
  PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
else
  PROJECT_ROOT="$(cd "$PROJECT_ROOT_INPUT" && pwd)"
fi
if [ -z "$PROJECT_ROOT" ]; then
  PROJECT_ROOT="$(pwd)"
fi

if [ ! -d "$PROJECT_ROOT/.git" ] && [ ! -f "$PROJECT_ROOT/.git" ]; then
  err "Could not detect a git repository at: $PROJECT_ROOT"
  exit 1
fi

if [ -z "$BASE_REF" ]; then
  BASE_REF="$(git -C "$PROJECT_ROOT" branch --show-current 2>/dev/null || true)"
fi
if [ -z "$BASE_REF" ]; then
  BASE_REF="HEAD"
fi

if ! git -C "$PROJECT_ROOT" rev-parse --verify --quiet "$BASE_REF" >/dev/null 2>&1; then
  if git -C "$PROJECT_ROOT" rev-parse --verify --quiet "origin/$BASE_REF" >/dev/null 2>&1; then
    BASE_REF="origin/$BASE_REF"
  elif [ "$DRY_RUN" -eq 1 ]; then
    BASE_REF="HEAD"
  elif git -C "$PROJECT_ROOT" rev-parse --verify --quiet HEAD >/dev/null 2>&1; then
    BASE_REF="HEAD"
  else
    err "Could not resolve base ref '$BASE_REF' in project '$PROJECT_ROOT'"
    exit 1
  fi
fi

WORKTREE_ROOT="$PROJECT_ROOT/.claude/worktrees"

if [ "$DRY_RUN" -eq 0 ]; then
  mkdir -p "$WORKTREE_ROOT"
fi

log "Workflow base: $BASE_REF"
log "Project root: $PROJECT_ROOT"
log "Worktrees root: $WORKTREE_ROOT"

launched=0
index=0

for raw in "${FEATURES[@]}"; do
  index=$((index + 1))
  feature="$raw"

  if [[ "$feature" == *:* ]]; then
    name="${feature%%:*}"
    prompt="${feature#*:}"
  else
    name="$feature"
    prompt="Implement this feature."
  fi

  name="$(trim "$name")"
  prompt="$(trim "$prompt")"

  if [ -z "$name" ]; then
    err "Skipping empty feature in argument ${index}"
    result="{\"index\":$index,\"feature\":\"\",\"name\":\"\",\"slug\":\"\",\"branch\":\"\",\"worktree\":\"\",\"status\":\"skipped\",\"created\":false,\"launched\":false,\"error\":\"empty feature\"}"
    append_json_item RESULTS_JSON "$result"
    append_json_item PLANNED_JSON "$result"
    continue
  fi

  slug="$(slugify "$name")"
  branch="workflow/$slug"
  worktree_dir="$WORKTREE_ROOT/$slug"
  task_file="$worktree_dir/TASK.md"
  launch_cmd="cd '$worktree_dir' && claude"
  created=false

  if [ -d "$worktree_dir" ]; then
    status="existing"
    log "[$index] Existing worktree found: $worktree_dir"
  else
    status="planned"
    if [ "$DRY_RUN" -eq 1 ]; then
      log "[$index] DRY-RUN: would create worktree $worktree_dir (branch: $branch)"
      created=false
    else
      if git -C "$PROJECT_ROOT" show-ref --verify --quiet "refs/heads/$branch"; then
        log "[$index] Creating worktree from existing branch: $branch"
        run_git git -C "$PROJECT_ROOT" worktree add "$worktree_dir" "$branch"
      else
        log "[$index] Creating worktree and branch '$branch' from '$BASE_REF'"
        run_git git -C "$PROJECT_ROOT" worktree add -b "$branch" "$worktree_dir" "$BASE_REF"
      fi
      status="created"
      created=true
    fi
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    log "[$index] DRY-RUN: would initialize template in $worktree_dir"
    log "[$index] DRY-RUN: would write TASK.md in $task_file"
    result="{\"index\":$index,\"feature\":$(json_escape "$feature"),\"name\":$(json_escape "$name"),\"slug\":$(json_escape "$slug"),\"branch\":$(json_escape "$branch"),\"worktree\":$(json_escape "$worktree_dir"),\"status\":\"planned\",\"created\":false,\"launched\":false,\"error\":\"\"}"
    append_json_item RESULTS_JSON "$result"
    append_json_item PLANNED_JSON "$result"
    continue
  fi

  log "[$index] Writing TASK.md in $worktree_dir"
  cat > "$task_file" <<EOF_TASK
# Borris-Flow Task

- Branch: $branch
- Base: $BASE_REF
- Source feature: $feature

## Instructions

${prompt}
EOF_TASK

  log "[$index] Initializing Borris-Flow in $worktree_dir"
  init_log="/tmp/borris-workflow-init.log"
  status="initialized"
  if ! copy_template "$worktree_dir" "1" >>"$init_log" 2>&1; then
    status="failed"
    err "Template init failed for $worktree_dir; check: $init_log"
  fi

  did_launch=false
  if [ "$status" != "failed" ]; then
    if [ "$LAUNCH" -eq 1 ]; then
      if [ "$launched" -lt "$MAX_LAUNCH" ]; then
        if launch_claude "$worktree_dir" "borris-flow-${slug}"; then
          launched=$((launched + 1))
          did_launch=true
          log "[$index] Launched Claude for $worktree_dir"
        else
          log "[$index] Could not auto-launch. Run manually: $launch_cmd"
        fi
      else
        log "[$index] Launch cap reached (--max=$MAX_LAUNCH). Run manually: $launch_cmd"
      fi
    else
      log "[$index] Launch disabled. Run manually: $launch_cmd"
    fi
  fi

  result="{\"index\":$index,\"feature\":$(json_escape "$feature"),\"name\":$(json_escape "$name"),\"slug\":$(json_escape "$slug"),\"branch\":$(json_escape "$branch"),\"worktree\":$(json_escape "$worktree_dir"),\"status\":\"$status\",\"created\":$([ "$created" = true ] && echo true || echo false),\"launched\":$did_launch,\"error\":\"\"}"
  append_json_item RESULTS_JSON "$result"
  append_json_item PLANNED_JSON "$result"
  if [ "$created" = true ]; then
    append_json_item CREATED_JSON "$result"
  fi
done

if [ "$JSON_MODE" -eq 1 ]; then
  echo "{\"baseRef\":$(json_escape "$BASE_REF"),\"projectRoot\":$(json_escape "$PROJECT_ROOT"),\"worktreesRoot\":$(json_escape "$WORKTREE_ROOT"),\"dryRun\":$([ "$DRY_RUN" -eq 1 ] && echo true || echo false),\"launch\":$([ "$LAUNCH" -eq 1 ] && echo true || echo false),\"maxLaunch\":$MAX_LAUNCH,\"planned\":[${PLANNED_JSON}],\"created\":[${CREATED_JSON}],\"results\":[${RESULTS_JSON}]}"
  exit 0
fi

if [ "$DRY_RUN" -eq 1 ]; then
  log "Dry run complete. No changes made."
else
  log "Workflow complete: processed ${#FEATURES[@]} feature(s)."
  log "Active worktrees can be listed with: git worktree list"
fi
