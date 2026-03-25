# Chaos Skills Architecture

## Layers

- `vendors/`: upstream sources kept read-only for future sync
- `skills/`: editable source skills organized by workflow area
- `publish/skills/`: flattened install surface for `npx skills`
- `docs/`: local governance, sync notes, and architecture docs
- `tooling/`: thin local scripts for export and install helpers

## Source Categories

- `skills/core/`: bootstrap and meta-process skills
- `skills/planning/`: planning, orchestration, and execution routing
- `skills/coding/`: engineering discipline and review workflows
- `skills/writing/`: authoring and documentation workflows
- `skills/_shared/`: non-skill reusable assets

## Current Superpowers Mapping

### Core

- `using-superpowers`

### Planning

- `brainstorming`
- `dispatching-parallel-agents`
- `executing-plans`
- `subagent-driven-development`
- `using-git-worktrees`
- `writing-plans`

### Coding

- `finishing-a-development-branch`
- `receiving-code-review`
- `requesting-code-review`
- `systematic-debugging`
- `test-driven-development`
- `verification-before-completion`

### Writing

- `writing-skills`

## Publish Rule

Each source skill at `skills/<category>/<skill>/` is exported to:

`publish/skills/<frontmatter.name>/`

The publish layer stays flat so installation stays simple across clients.
