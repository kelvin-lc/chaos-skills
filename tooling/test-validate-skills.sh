#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VALIDATE_SCRIPT="$ROOT_DIR/tooling/validate-skills.sh"

make_skill() {
  local root="$1"
  local category="$2"
  local folder="$3"
  local name="$4"
  local description="$5"

  mkdir -p "$root/skills/$category/$folder"
  cat >"$root/skills/$category/$folder/SKILL.md" <<EOF
---
name: $name
description: $description
---
EOF
}

expect_success() {
  local dir="$1"
  local output

  if ! output="$("$VALIDATE_SCRIPT" "$dir" 2>&1)"; then
    echo "expected success, got failure" >&2
    echo "$output" >&2
    exit 1
  fi
}

expect_failure() {
  local dir="$1"
  local pattern="$2"
  local output

  if output="$("$VALIDATE_SCRIPT" "$dir" 2>&1)"; then
    echo "expected failure, got success" >&2
    echo "$output" >&2
    exit 1
  fi

  if [[ "$output" != *"$pattern"* ]]; then
    echo "failure output did not include expected pattern: $pattern" >&2
    echo "$output" >&2
    exit 1
  fi
}

main() {
  local tmp_ok tmp_duplicate tmp_missing
  tmp_ok="$(mktemp -d)"
  tmp_duplicate="$(mktemp -d)"
  tmp_missing="$(mktemp -d)"
  trap "rm -rf '$tmp_ok' '$tmp_duplicate' '$tmp_missing'" EXIT

  make_skill "$tmp_ok" core "using-superpowers" "using-superpowers" "Use when starting any conversation"
  make_skill "$tmp_ok" planning "brainstorming" "brainstorming" "Use when planning a design change"
  mkdir -p "$tmp_ok/skills/_shared/templates"
  expect_success "$tmp_ok"

  make_skill "$tmp_duplicate" core "skill-one" "duplicate-skill" "Use when first"
  make_skill "$tmp_duplicate" planning "skill-two" "duplicate-skill" "Use when second"
  expect_failure "$tmp_duplicate" "Duplicate skill name: duplicate-skill"

  mkdir -p "$tmp_missing/skills/coding/missing-skill"
  expect_failure "$tmp_missing" "Missing SKILL.md:"

  echo "validate-skills tests passed"
}

main "$@"
