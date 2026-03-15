#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
FORCE=0

usage() {
  cat <<'EOF'
Usage:
  ./scripts/install-borris-workflow.sh [--force]

Options:
  --force   Replace existing ~/.local/bin/borris-flow and ~/.local/bin/borris-workflow
  --help    Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      FORCE=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BF_CMD="$REPO_ROOT/borris-flow"
BW_CMD="$REPO_ROOT/borris-workflow"

if [ ! -f "$BF_CMD" ] || [ ! -f "$BW_CMD" ]; then
  echo "error: expected files missing in repo root"
  echo "  borris-flow: $BF_CMD"
  echo "  borris-workflow: $BW_CMD"
  exit 1
fi

chmod +x "$BF_CMD" "$BW_CMD"
mkdir -p "$INSTALL_DIR"

declare -a skipped=()
declare -a installed=()

install_link() {
  local src="$1"
  local dst="$2"

  if [ -L "$dst" ]; then
    local current
    current="$(readlink "$dst" || true)"
    if [ "$current" = "$src" ]; then
      echo "ok: already linked $dst"
      return 0
    fi

    if [ "$FORCE" -eq 0 ]; then
      echo "skip: symlink exists for $dst (points to $current). use --force to replace"
      skipped+=("$dst")
      return 0
    fi

    rm -f "$dst"
  elif [ -e "$dst" ]; then
    if [ "$FORCE" -eq 0 ]; then
      echo "skip: $dst exists and is not a symlink. use --force to replace"
      skipped+=("$dst")
      return 0
    fi
    rm -f "$dst"
  fi

  ln -s "$src" "$dst"
  echo "installed: $dst -> $src"
  installed+=("$dst")
}

install_link "$BF_CMD" "$INSTALL_DIR/borris-flow"
install_link "$BW_CMD" "$INSTALL_DIR/borris-workflow"

echo
echo "Done. Installed/verified wrappers in: $INSTALL_DIR"

echo "Commands available from anywhere:"
echo "  borris-flow"
echo "  borris-workflow"

echo
if [ ${#skipped[@]} -gt 0 ]; then
  echo "Skipped (existing path already present):"
  printf '  - %s
' "${skipped[@]}"
fi

if ! echo ":$PATH:" | grep -q ":$INSTALL_DIR:"; then
  echo
  echo "warning: $INSTALL_DIR is not in PATH"
  echo "Add this to your shell profile (e.g. ~/.zshrc or ~/.bashrc):"
  echo 'export PATH="$HOME/.local/bin:$PATH"'
fi

echo
if [ ${#installed[@]} -eq 0 ] && [ ${#skipped[@]} -gt 0 ]; then
  echo "Use --force if you want to replace the skipped entries and reinstall."
fi
