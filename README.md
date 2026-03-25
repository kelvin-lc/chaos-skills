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
├─ publish/
│  └─ skills/
├─ docs/
└─ tooling/
```

### Responsibilities

- `vendors/`: read-only upstream source snapshots
- `skills/`: editable source skills, organized by workflow area
- `publish/skills/`: flattened install surface consumed by `npx skills`
- `docs/`: architecture, standards, sync notes
- `tooling/`: thin local scripts

## Current Upstream

- `vendors/superpowers`: imported from `https://github.com/obra/superpowers`

## Editing Workflow

1. Edit a skill under `skills/`
2. Export source skills into `publish/skills/`
3. Reinstall from `publish/` into local agents with `npx skills`

### Export Only

```bash
tooling/export-skills.sh
```

### Export And Reinstall

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

`npx skills` does not point agents directly at this repo. The update flow is:

```text
skills/ -> publish/skills/ -> npx skills add -> local agent skill directories
```

That means when you change a local skill, you update it by running:

```bash
tooling/sync-local.sh
```

Then start a new agent session to ensure the updated skill content is reloaded.

## Installing Into Agents

Manual install remains available if you want it:

```bash
npx skills add ./publish -g -a claude-code -a codex -a cursor -a kiro-cli -y
```

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
