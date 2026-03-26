#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_ROOT="${1:-$ROOT_DIR}"
SOURCE_DIR="$TARGET_ROOT/skills"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Missing skills directory: $SOURCE_DIR" >&2
  exit 1
fi

SEEN_FILE="$(mktemp)"
trap 'rm -f "$SEEN_FILE"' EXIT
skill_count=0

while IFS= read -r category_dir; do
  category_name="$(basename "$category_dir")"

  if [[ "$category_name" == "_shared" ]]; then
    continue
  fi

  while IFS= read -r skill_dir; do
    skill_file="$skill_dir/SKILL.md"

    if [[ ! -f "$skill_file" ]]; then
      echo "Missing SKILL.md: $skill_file" >&2
      exit 1
    fi

    skill_name="$(sed -n 's/^name:[[:space:]]*//p' "$skill_file" | head -n 1 | tr -d '"' | tr -d "'")"

    if [[ -z "$skill_name" ]]; then
      echo "Missing skill name in $skill_file" >&2
      exit 1
    fi

    previous_skill_file="$(awk -F '\t' -v name="$skill_name" '$1 == name { print $2; exit }' "$SEEN_FILE")"

    if [[ -n "$previous_skill_file" ]]; then
      echo "Duplicate skill name: $skill_name" >&2
      echo "First: $previous_skill_file" >&2
      echo "Second: $skill_file" >&2
      exit 1
    fi

    printf '%s\t%s\n' "$skill_name" "$skill_file" >>"$SEEN_FILE"
    ((skill_count += 1))
  done < <(find "$category_dir" -mindepth 1 -maxdepth 1 -type d | LC_ALL=C sort)
done < <(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | LC_ALL=C sort)

if (( skill_count == 0 )); then
  echo "No skills found under $SOURCE_DIR" >&2
  exit 1
fi

echo "Validated $skill_count skills in $SOURCE_DIR"
