#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/skills"
PUBLISH_DIR="$ROOT_DIR/publish/skills"

rm -rf "$PUBLISH_DIR"
mkdir -p "$PUBLISH_DIR"

find "$SOURCE_DIR" -mindepth 2 -maxdepth 2 -type d | sort | while read -r skill_dir; do
  skill_file="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_file" ]]; then
    continue
  fi

  skill_name="$(sed -n 's/^name:[[:space:]]*//p' "$skill_file" | head -n 1 | tr -d '"' | tr -d "'")"

  if [[ -z "$skill_name" ]]; then
    echo "Missing skill name in $skill_file" >&2
    exit 1
  fi

  publish_skill_dir="$PUBLISH_DIR/$skill_name"

  if [[ -e "$publish_skill_dir" ]]; then
    echo "Duplicate publish skill name: $skill_name" >&2
    exit 1
  fi

  cp -R "$skill_dir" "$publish_skill_dir"
done

echo "Exported skills to $PUBLISH_DIR"
