---
name: refactor-research
description: Use when reviewing a PR, branch, or local diff for maintainability and refactoring opportunities before proposing code changes, especially when upstream/downstream dependencies, ownership boundaries, coupling, tests, or existing codebase patterns need investigation
---

# Refactor Research

## Overview

Research the code before proposing refactors.

Core principle: no refactor hypothesis without code evidence.

## Hard Gates

- Do not implement code changes.
- Do not write output files unless the user explicitly asks.
- Do not propose a refactor plan until changed code, surrounding callers/consumers, tests, and similar patterns have been inspected.
- Preserve behavior by default.

## Inputs

Infer values when possible. Ask only if missing information blocks safe research.

- PR URL or local diff
- Repo path
- Base branch
- Focus areas
- Refactor depth
- User context

## Process

1. Identify the diff.
   - For PRs, inspect PR metadata and diff.
   - For local work, inspect branch, status, commits, and base diff.
2. Read changed files in full.
   - Identify changed functions/classes/types.
   - Identify public exports, routes, commands, schemas, models, jobs, and side effects.
3. Identify behavior to preserve.
   - Inputs, outputs, errors, persisted state, API responses, events, logs, metrics, and tests.
4. Trace upstream.
   - Find callers, producers, routes, UI actions, jobs, configs, env vars, event sources, and related repos when relevant.
5. Trace downstream.
   - Find callees, consumers, DB writes/reads, external calls, emitted events, caches, error handlers, and tests.
6. Search for existing patterns.
   - Find similar services, handlers, repositories, validators, adapters, mappers, migrations, and tests.
   - Prefer actual code examples over guessed conventions.
7. Assess maintainability pressure.
   - Look for mixed ownership, duplication, scattered validation, hidden state, weak boundaries, leaky abstractions, and brittle tests.
8. Produce a research brief in the response.

## Research Brief Format

```md
# Refactor Research Brief

## Diff Summary
## Changed Code
## Behavior To Preserve
## Upstream Map
## Downstream Map
## Similar Existing Patterns
## Current Tests And Gaps
## Maintainability Pressures
## Refactor Candidates
## Open Questions Or Blockers
```

## Subagents

If the user explicitly asks for multi-agent research, split independent work into upstream, downstream, and pattern scouts. Otherwise do the research locally.

## Red Flags

Stop and gather more evidence if:

- Only the diff was read.
- Changed files were not read in full.
- Callers or consumers were not checked.
- Existing codebase patterns were not searched.
- The refactor idea is mostly aesthetic.
- Behavior preservation is unclear.
