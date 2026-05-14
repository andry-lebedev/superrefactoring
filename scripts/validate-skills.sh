#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

required_files=(
  "$ROOT/.codex-plugin/plugin.json"
  "$ROOT/.claude-plugin/plugin.json"
  "$ROOT/.cursor-plugin/plugin.json"
  "$ROOT/gemini-extension.json"
  "$ROOT/skills/refactor-research/SKILL.md"
  "$ROOT/skills/writing-refactor-plans/SKILL.md"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file" >&2
    exit 1
  fi
done

for skill in "$ROOT"/skills/*/SKILL.md; do
  grep -q '^---$' "$skill" || {
    echo "Missing YAML frontmatter delimiter: $skill" >&2
    exit 1
  }
  grep -q '^name: [a-z0-9-][a-z0-9-]*$' "$skill" || {
    echo "Invalid or missing skill name: $skill" >&2
    exit 1
  }
  grep -q '^description: Use when ' "$skill" || {
    echo "Description must start with 'Use when': $skill" >&2
    exit 1
  }
done

python3 -m json.tool "$ROOT/.codex-plugin/plugin.json" >/dev/null
python3 -m json.tool "$ROOT/.claude-plugin/plugin.json" >/dev/null
python3 -m json.tool "$ROOT/.claude-plugin/marketplace.json" >/dev/null
python3 -m json.tool "$ROOT/.cursor-plugin/plugin.json" >/dev/null
python3 -m json.tool "$ROOT/gemini-extension.json" >/dev/null
python3 -m json.tool "$ROOT/package.json" >/dev/null

echo "Superrefactoring validation passed."
