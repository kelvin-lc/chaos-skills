#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DEFAULT_AGENTS=(
  claude-code
  codex
  cursor
  kiro-cli
)

if [[ "$#" -gt 0 ]]; then
  AGENTS=("$@")
else
  AGENTS=("${DEFAULT_AGENTS[@]}")
fi

"$ROOT_DIR/tooling/export-skills.sh"

cmd=(npx skills add "$ROOT_DIR/publish" -g -y)

for agent in "${AGENTS[@]}"; do
  cmd+=(-a "$agent")
done

"${cmd[@]}"
