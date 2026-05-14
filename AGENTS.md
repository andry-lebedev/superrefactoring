# Superrefactoring - Codex Instructions

This repo is a plugin-style skills library modeled after `obra/superpowers`.

## AI Instruction Sync

When modifying this file, update the sibling instruction file for the other AI in the same directory in the same change:
- `CLAUDE.md` for Claude Code.
- `AGENTS.md` for Codex and other agents.

If the sibling file is missing, create it or explicitly note why the pair does not apply.

## Purpose

Superrefactoring provides refactoring skills that help agents investigate a PR or local diff before proposing maintainability-focused changes, then write a scoped refactor plan that can be executed through existing development workflows.

## Repo Shape

- `.codex-plugin/` - Codex plugin manifest.
- `.claude-plugin/` - Claude plugin manifest and marketplace metadata.
- `.cursor-plugin/` - Cursor plugin manifest.
- `.opencode/` - OpenCode install and plugin bootstrap.
- `hooks/` - session-start context injection hooks.
- `skills/` - agent skills.
- `docs/` - usage and testing docs.
- `scripts/` - maintenance scripts.
- `tests/` - lightweight validation tests.

## Skill Conventions

- Keep skill descriptions trigger-focused.
- Keep `SKILL.md` bodies compact and procedural.
- Do not require output files from skills unless the user explicitly asks.
- Refactoring research must not perform code changes.
- Refactoring plans must not implement code changes.
- Execution belongs to existing workflows such as TDD, subagent-driven development, and code review.

## Validation

Run:

```sh
npm test
```

or:

```sh
bash scripts/validate-skills.sh
```
