# Superrefactoring

Superrefactoring is a small skills library for refactoring work that should be careful, evidence-driven, and behavior-preserving.

It is modeled after the structure of [obra/superpowers](https://github.com/obra/superpowers): plugin manifests for several coding agents, a `skills/` directory, hooks, docs, scripts, and lightweight tests.

## Skills

- `refactor-research` - investigate a PR, branch, or local diff before proposing refactors.
- `writing-refactor-plans` - turn refactor research into scoped options and an implementation plan.

## Principle

No refactor without first understanding the code's role in the system.

The skills bias toward:

- behavior preservation
- upstream/downstream dependency mapping
- existing codebase patterns
- ownership boundaries
- testability
- boring, supportable code

## What These Skills Do Not Do

They do not implement refactors directly. After a plan is approved, execute it through Superpowers execution: `superpowers:subagent-driven-development` when subagents are available, or `superpowers:executing-plans` as the fallback.

## Validation

```sh
npm test
```

or:

```sh
bash scripts/validate-skills.sh
```

## License

MIT.
