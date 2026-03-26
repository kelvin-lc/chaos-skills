# Chaos Skills Architecture

## Layers

- `vendors/`: upstream sources kept read-only for future sync
- `skills/`: editable source skills and direct install surface organized by workflow area
- `docs/`: local governance, sync notes, and architecture docs
- `tooling/`: thin local scripts for validation and install helpers

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

## Install Rule

Each source skill lives at:

`skills/<category>/<skill>/`

The public skill identifier comes from `frontmatter.name`, while the folder name remains an internal organization detail.

`npx skills` installs directly from the `skills/` tree, either from the full source root or from narrower subpaths such as `skills/planning/`.

## Provenance Rule

Folder names should describe the skill's purpose, not its lineage.

If provenance matters, store it in a sidecar `SOURCE.md` next to the skill. Use `docs/provenance-template.md` as the standard format.
