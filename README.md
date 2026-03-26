# Chaos Skills

Private AI skills monorepo for local agent workflows.

## Goals

- Keep upstream skills vendored and easy to sync
- Keep custom skills easy to modify
- Keep installation standardized through `npx skills`

## Repository Layout

```text
.
├─ vendors/
│  └─ superpowers/
├─ skills/
│  ├─ core/
│  ├─ planning/
│  ├─ coding/
│  ├─ writing/
│  └─ _shared/
├─ docs/
└─ tooling/
```

### Responsibilities

- `vendors/`: read-only upstream source snapshots
- `skills/`: editable source skills and direct install surface, organized by workflow area
- `docs/`: architecture, standards, sync notes
- `tooling/`: thin local scripts

## Current Upstream

- `vendors/superpowers`: imported from `https://github.com/obra/superpowers`

## Editing Workflow

1. Edit a skill under `skills/`
2. Validate source skills
3. Reinstall from `skills/` into local agents with `npx skills`

### Validate Only

```bash
tooling/validate-skills.sh
```

### Validate And Reinstall

```bash
tooling/sync-local.sh
```

By default this reinstalls to:

- `claude-code`
- `codex`
- `cursor`
- `kiro-cli`

You can override the target agents:

```bash
tooling/sync-local.sh claude-code codex
```

## How Updates Work

`npx skills` can point agents directly at this repo's source tree. The update flow is:

```text
skills/ -> npx skills add -> local agent skill directories
```

That means when you change a local skill, you update it by running:

```bash
tooling/sync-local.sh
```

Then start a new agent session to ensure the updated skill content is reloaded.

## Installing Into Agents

Manual install remains available if you want it:

```bash
npx skills add ./skills -g -a claude-code -a codex -a cursor -a kiro-cli -y
```

You can also target part of the tree directly:

```bash
npx skills add ./skills/planning -g -a codex -y
npx skills add ./skills/planning/brainstorming -g -a codex -y
```

## Provenance

Keep source folder names focused on the skill's purpose, not its origin. If a skill's lineage matters, add a neighboring `SOURCE.md` using the template in `docs/provenance-template.md`.

This keeps install paths clean while preserving upstream traceability in a durable, reviewable place.

## Kiro Note

Kiro may also require `resources` in `.kiro/agents/<agent>.json`:

```json
{
  "resources": ["skill://.kiro/skills/**/SKILL.md"]
}
```

## Syncing Upstream

The current vendor import was added as a subtree. Pull future upstream changes with:

```bash
git subtree pull --prefix=vendors/superpowers https://github.com/obra/superpowers.git main --squash
```

Never modify files inside `vendors/` directly. Copy what you need into `skills/` and adjust it there.
