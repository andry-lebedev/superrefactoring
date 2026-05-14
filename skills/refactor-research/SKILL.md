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
- Always break research into upstream, downstream, and pattern scout passes.
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
4. Run the required scout passes.
5. Assess maintainability pressure.
   - Look for mixed ownership, duplication, scattered validation, hidden state, weak boundaries, leaky abstractions, and brittle tests.
6. Produce a research brief in the response.

## Required Scout Passes

Run all three scout passes every time. Do not skip any scout because the diff looks small.

Use actual subagents only when the host environment and user instructions allow them. If subagents are unavailable or not allowed, run the scouts as separate local passes and keep their findings under separate headings.

### Upstream Scout

Walk backward from each changed function, class, route, job, command, exported type, table, event, or API.

Find:

- Callers and entry points
- Producers of input data
- Routes, jobs, commands, UI actions, event emitters, and external integrations
- Config and environment variables that affect the code
- Validation, normalization, and preparation logic before this code runs
- Related repos when provided by the user

Answer:

- Who calls this?
- What data reaches it, and where does that data originate?
- What assumptions do callers make?
- Is this code compensating for poor upstream shape?
- Would a better upstream abstraction remove complexity here?

### Downstream Scout

Walk forward from each changed function, class, route, job, command, exported type, table, event, or API.

Find:

- Callees and consumers
- Return-value users and API response users
- DB writes/reads, events, queues, external API calls, caches, logs, metrics, analytics, and state mutations
- Errors thrown, caught, transformed, logged, or surfaced
- Tests depending on the behavior

Answer:

- What depends on this output?
- What side effects happen?
- What invariants must remain true?
- What downstream code becomes simpler if this changes higher up?
- What downstream code might break if this refactor is wrong?

### Pattern Scout

Search the codebase for similar working examples before judging the PR's approach.

Find:

- Similar services, handlers, repositories, validators, adapters, mappers, migrations, and tests
- Naming and module-boundary conventions
- Validation, error-handling, result-type, dependency-injection, and side-effect patterns
- Patterns worth copying
- Patterns that are outdated, inconsistent, or not worth copying

Answer:

- How does this codebase already solve similar problems?
- What does the PR do differently?
- Which existing pattern should this refactor reuse?
- What would a codebase-native refactor look like?

## Research Brief Format

```md
# Refactor Research Brief

## Diff Summary
## Changed Code
## Behavior To Preserve
## Upstream Scout
## Downstream Scout
## Pattern Scout
## Current Tests And Gaps
## Maintainability Pressures
## Refactor Candidates
## Open Questions Or Blockers
```

## Red Flags

Stop and gather more evidence if:

- Only the diff was read.
- Changed files were not read in full.
- Callers or consumers were not checked.
- Existing codebase patterns were not searched.
- Upstream, downstream, and pattern findings are blended together instead of separated.
- The refactor idea is mostly aesthetic.
- Behavior preservation is unclear.
