---
name: writing-refactor-plans
description: Use when refactor research exists or requirements are clear and Codex needs to choose a safe refactoring scope, compare options, and write a behavior-preserving implementation plan before code changes
---

# Writing Refactor Plans

## Overview

Turn refactor research into a scoped, reviewable implementation plan.

Core principle: one design hypothesis at a time.

## Hard Gates

- Do not implement code changes.
- Do not write output files unless the user explicitly asks.
- If research is insufficient, use `refactor-research` first.
- Do not plan behavior changes unless clearly labeled and justified.

## Required Inputs

- Refactor research brief
- Diff or PR context
- Behavior to preserve
- Focus areas
- Refactor depth: conservative, moderate, or aggressive

## Process

1. Restate behavior and invariants.
2. State the root maintainability hypothesis:

   > I think this code is hard to support because X. Refactoring Y into Z will improve A, B, and C while preserving behavior.

3. Compare options:
   - No refactor
   - Conservative refactor
   - Future-proof refactor
   - Aggressive rewrite
4. Stress-test the recommendation.
   - Correctness risks
   - API/contract risks
   - Migration risks
   - Test gaps
   - Overengineering risks
   - Missed simpler alternatives
5. Choose a verdict:
   - `NO_REFACTOR_NEEDED`
   - `CONSERVATIVE_REFACTOR`
   - `FUTURE_PROOF_REFACTOR`
   - `AGGRESSIVE_REWRITE`
   - `DEFER_REFACTOR`
6. Write the implementation plan.
   - Keep tasks small.
   - Put tests before or alongside refactors.
   - Define out-of-scope changes.
   - Include acceptance criteria and rollback notes.

## Plan Format

```md
# Refactor Plan

## Summary
## Root Maintainability Problem
## Verdict
## Approved Scope
## Out Of Scope
## Behavior To Preserve
## Options Considered
## Risks And Mitigations
## Tasks
## Tests Required
## Verification Commands
## Rollback Plan
## Optional Follow-Ups
```

## Task Format

```md
### Task N: <name>

- Goal:
- Files likely touched:
- Exact change:
- Behavior preserved:
- Tests to add/update:
- Acceptance criteria:
- Risks:
- Rollback notes:
```

## Integration

After the user approves the plan, use existing workflow skills:

- `using-git-worktrees` before implementation
- `test-driven-development` for behavior-preserving changes
- `subagent-driven-development` or `executing-plans` for task execution
- `requesting-code-review` after meaningful changes
- `verification-before-completion` before claiming completion

## Red Flags

Stop and revise the plan if:

- The plan bundles unrelated refactors.
- The test strategy is vague.
- Public behavior changes are hidden inside "refactor."
- The plan adds abstractions without deleting or simplifying complexity.
- The architecture cannot be explained in three sentences.
