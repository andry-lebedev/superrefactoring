---
name: writing-refactor-plans
description: Use when refactor research exists or requirements are clear and an agent needs to choose a safe refactoring scope, compare options, and write a behavior-preserving implementation plan before code changes
---

# Writing Refactor Plans

## Overview

Write comprehensive refactor implementation plans assuming the implementer has zero context for the codebase and questionable taste. Document what to change, why it is safe, which behavior must be preserved, which files are likely touched, which tests prove safety, and exactly how each task should be verified.

Core principle: one design hypothesis at a time, expressed as bite-sized tasks.

## Hard Gates

- Do not implement code changes.
- Do not write output files unless the user explicitly asks.
- If research is insufficient, use `refactor-research` first.
- Do not plan behavior changes unless clearly labeled and justified.
- Do not include vague steps an implementer has to invent later.
- Do not bundle unrelated refactors into one task.

## Required Inputs

- Refactor research brief
- Diff or PR context
- Behavior to preserve
- Focus areas
- Refactor depth: conservative, moderate, or aggressive

## Output Location

Default to writing the plan in the response. If the user explicitly asks for a file, save it to:

```txt
docs/superrefactoring/plans/YYYY-MM-DD-<refactor-name>.md
```

User-specified locations override this default.

## Scope Check

Before writing tasks, check whether the research points to one refactor or several independent refactors.

If there are multiple independent subsystems, split the plan into separate plans or clearly mark later plans as follow-ups. Each plan should produce a working, testable, behavior-preserving change on its own.

Do not let "future-proof" become permission to rewrite the world.

## Refactor Decision

Every plan must first choose scope.

1. Restate behavior and invariants.
2. State the root maintainability hypothesis.

   > I think this code is hard to support because X. Refactoring Y into Z will improve A, B, and C while preserving behavior.

3. Compare options.
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
5. Choose a verdict.
   - `NO_REFACTOR_NEEDED`
   - `CONSERVATIVE_REFACTOR`
   - `FUTURE_PROOF_REFACTOR`
   - `AGGRESSIVE_REWRITE`
   - `DEFER_REFACTOR`

If the verdict is `NO_REFACTOR_NEEDED` or `DEFER_REFACTOR`, do not write implementation tasks. Explain why and list optional follow-ups.

## File Structure Mapping

Before defining tasks, map the files likely to be touched and what each is responsible for.

For each file, identify:

- Current responsibility
- Planned responsibility after the refactor
- Whether it is create / modify / delete / test-only
- Upstream/downstream contracts it touches
- Tests that should protect it

This map drives task decomposition. Files that change together should usually appear in the same task. Unrelated files should not.

## Task Granularity

Each task should be small enough for a fresh implementation agent to complete and review independently.

Good task steps are concrete actions:

- Write or update the behavior-preserving test.
- Run it and confirm the expected failure when applicable.
- Make the smallest refactor that satisfies the test.
- Run focused verification.
- Run broader verification if the contract or side effects changed.
- Commit the task if the execution workflow uses commits.

## Plan Header

Every refactor plan MUST start with this header:

```md
# <Refactor Name> Implementation Plan

> **For agentic workers:** REQUIRED EXECUTION: Use Superpowers execution to implement this plan task-by-task: `superpowers:subagent-driven-development` when subagents are available, otherwise `superpowers:executing-plans`. Steps use checkbox (`- [ ]`) syntax for tracking. Preserve behavior unless a task explicitly labels and justifies a behavior change.

**Goal:** <one sentence describing the refactor outcome>

**Refactor hypothesis:** I think this code is hard to support because <cause>. Refactoring <change> will improve <benefits> while preserving <behavior>.

**Approved scope:** <exact boundary of what may change>

**Out of scope:** <changes that must not happen in this pass>

**Verdict:** <NO_REFACTOR_NEEDED | CONSERVATIVE_REFACTOR | FUTURE_PROOF_REFACTOR | AGGRESSIVE_REWRITE | DEFER_REFACTOR>

---
```

## Required Sections

After the header, include:

```md
## Behavior To Preserve
## File Structure
## Options Considered
## Risks And Mitigations
## Tasks
## Verification Commands
## Rollback Plan
## Optional Follow-Ups
```

## Task Structure

Use this format for every task:

````md
### Task N: <specific task name>

**Goal:** <one outcome>

**Files:**
- Create: `exact/path/to/new-file.ext`
- Modify: `exact/path/to/existing-file.ext`
- Delete: `exact/path/to/deleted-file.ext`
- Test: `exact/path/to/test-file.ext`

**Behavior preserved:** <specific invariant, input/output, side effect, or contract>

**Acceptance criteria:**
- <observable result>
- <test or verification result>

- [ ] **Step 1: Write or update the safety test**

Describe the exact behavior to test. Include real test code when the target test framework and API are clear. If exact code cannot be written safely from current context, provide the exact test name, fixture, assertion, and file path.

```<language>
<test code or precise test skeleton>
```

- [ ] **Step 2: Run the test and confirm the expected result**

Run: `<exact focused command>`
Expected: `<expected failure before refactor or pass if this is characterization coverage>`

- [ ] **Step 3: Make the refactor**

Describe the exact code movement, extraction, deletion, rename, boundary change, or contract preservation. Include code snippets only when they are reliable enough for an implementer to use directly.

- [ ] **Step 4: Run focused verification**

Run: `<exact focused command>`
Expected: `PASS`

- [ ] **Step 5: Run broader verification**

Run: `<exact broader command>`
Expected: `PASS`

- [ ] **Step 6: Commit task changes**

```sh
git add <paths>
git commit -m "refactor: <task summary>"
```
````

Omit create / modify / delete lines that do not apply. Omit the commit step only if the user or execution environment does not want per-task commits.

## No Placeholders

Every task must contain enough information for a fresh agent to execute it without guessing.

These are plan failures:

- `TBD`, `TODO`, `fill in later`, `as appropriate`
- "Add tests" without naming the test file and behavior
- "Improve error handling" without naming the exact error boundary and expected behavior
- "Clean up this file" without naming the supportability problem
- "Similar to Task N" instead of repeating the needed detail
- "Run tests" without the exact command
- Behavior changes hidden inside refactor wording

If exact code cannot be provided because research is insufficient, stop and use `refactor-research`.

## Self-Review

After writing the plan, review it before presenting it.

1. Research coverage: Does every task trace back to evidence from the research?
2. Behavior preservation: Is every invariant protected by a test or verification command?
3. Scope discipline: Are unrelated cleanups excluded?
4. Placeholder scan: Remove vague language listed in "No Placeholders."
5. Type/name consistency: Do functions, classes, files, schemas, and commands use the same names throughout?
6. Execution readiness: Could a fresh agent implement each task from only this plan?

Fix issues inline. Do not present the plan until this review passes.

## Integration

After presenting the plan, ask for approval before implementation.

Use this handoff:

```md
Plan complete. Execution must use Superpowers execution.

1. `superpowers:subagent-driven-development` (recommended) - dispatch a fresh implementation agent per task, with spec and quality review after each task
2. `superpowers:executing-plans` - fallback when subagents are unavailable or the user wants batch execution with checkpoints

Which Superpowers execution path?
```

If the user chooses execution, stop using Superrefactoring as the executor and hand off to Superpowers:

- `superpowers:using-git-worktrees` before implementation
- `superpowers:test-driven-development` for behavior-preserving changes
- `superpowers:subagent-driven-development` for normal task execution
- `superpowers:executing-plans` only when subagent-driven execution is unavailable or explicitly not wanted
- `superpowers:requesting-code-review` after meaningful changes
- `superpowers:verification-before-completion` before claiming completion

Do not execute the plan through an ad hoc local workflow. Superrefactoring researches and plans; Superpowers executes.

## Red Flags

Stop and revise the plan if:

- The plan bundles unrelated refactors.
- The test strategy is vague.
- Public behavior changes are hidden inside "refactor."
- The plan adds abstractions without deleting or simplifying complexity.
- The architecture cannot be explained in three sentences.
- A task cannot be implemented without rereading the entire codebase.
- The plan requires changing many files but cannot explain the ownership boundary.
- The rollback plan is "revert everything" for a risky multi-step refactor.
