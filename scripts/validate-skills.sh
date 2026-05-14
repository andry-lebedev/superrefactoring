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

writing_refactor_plans="$ROOT/skills/writing-refactor-plans/SKILL.md"
required_plan_markers=(
  "## Scope Check"
  "## File Structure Mapping"
  "## Plan Header"
  "> **For agentic workers:**"
  "- [ ] **Step 1: Write or update the safety test**"
  "## No Placeholders"
  "## Self-Review"
  "Superpowers execution"
  "superpowers:subagent-driven-development"
  "superpowers:executing-plans"
)

for marker in "${required_plan_markers[@]}"; do
  grep -Fq -- "$marker" "$writing_refactor_plans" || {
    echo "writing-refactor-plans is missing Superpowers-style marker: $marker" >&2
    exit 1
  }
done

if grep -Fq "Inline Execution" "$writing_refactor_plans"; then
  echo "writing-refactor-plans must not offer generic Inline Execution; use Superpowers execution instead" >&2
  exit 1
fi

refactor_research="$ROOT/skills/refactor-research/SKILL.md"
required_research_markers=(
  "## Required Scout Passes"
  "### Upstream Scout"
  "### Downstream Scout"
  "### Pattern Scout"
  "Do not skip any scout because the diff looks small."
)

for marker in "${required_research_markers[@]}"; do
  grep -Fq -- "$marker" "$refactor_research" || {
    echo "refactor-research is missing mandatory scout marker: $marker" >&2
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
