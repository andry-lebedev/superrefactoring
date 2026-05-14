# Testing

Run:

```sh
npm test
```

This currently validates:

- required plugin manifests exist
- JSON metadata parses
- each skill has YAML frontmatter
- each skill name is lowercase kebab-case
- each skill description starts with `Use when`

Future tests should exercise realistic pressure prompts for refactoring research and plan-writing behavior.
