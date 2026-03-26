# AGENTS.md

This repository is a private skills monorepo. Treat it as a source-and-install pipeline, with `skills/` as the source of truth and install surface.

## Source Of Truth

- When changing a skill, edit `skills/<category>/<skill>/`.
- Never edit `vendors/` directly. It is an upstream snapshot for reference and future sync.
- The public skill identifier comes from the `name:` field inside each `SKILL.md`, not from the source folder name.
- Duplicate `name:` values will break validation and install targeting.
- Keep source folder names focused on the skill's purpose. If provenance matters, capture it in a sidecar `SOURCE.md`, not in the folder name.

## Repository Map

- `skills/core/`: bootstrap and meta-process skills
- `skills/planning/`: planning, orchestration, and execution skills
- `skills/coding/`: engineering workflow skills
- `skills/writing/`: authoring and documentation skills
- `vendors/superpowers/`: upstream reference, kept read-only
- `docs/`: local architecture and governance notes
- `tooling/`: validation and local install helpers

## Editing Rules

1. Read the source skill first, plus any files it references directly.
2. If a change is inspired by `vendors/superpowers`, port only the needed parts into `skills/`. Do not patch the vendor snapshot.
3. Keep frontmatter accurate:
   - `name` must stay unique across all source skills.
   - `description` should optimize for triggering conditions first.
   - Prefer descriptions that start with `Use when...`.
   - Do not summarize the whole workflow in `description`; keep workflow detail in the body.
4. Keep `SKILL.md` lean. Move bulky references, reusable scripts, or large examples into side files only when they reduce prompt bloat or improve reliability.
5. Follow the existing category layout instead of inventing new top-level buckets unless the user explicitly asks for that reorganization.
6. If the user asks for a change in installed behavior, update source under `skills/` first, then run validation and reinstall from `skills/`.
7. If provenance needs to be preserved, add or update a neighboring `SOURCE.md` using the repo template in `docs/provenance-template.md`.

## Creating Or Renaming Skills

- Put new skills under the most specific existing category.
- Use short hyphenated names for source folders.
- Treat `name:` as the public identifier. Changing it changes install targeting and the skill's public identity.
- If you rename a skill, verify references and reinstall behavior after validation.
- Keep instructions concrete and procedural. Assume the model is already capable; include only repo-specific guidance and genuinely useful constraints.

## Required Workflow After Edits

Validate source skills:

```bash
tooling/validate-skills.sh
```

If local agent installs also need to be updated:

```bash
tooling/sync-local.sh
```

To target specific agents only:

```bash
tooling/sync-local.sh claude-code codex
```

After syncing, start a new agent session if the goal is to test freshly updated skill content.

## Quick Checks Before Finishing

- Confirm there are no manual edits in `vendors/`.
- If the task changed a skill, confirm the source edit lives under `skills/`.
- If the task changed a skill, run validation so duplicate `name:` values and missing `SKILL.md` files are caught.
- If the task changed a skill, confirm `name:` still matches the intended public skill identifier.
- If provenance matters for the task, confirm `SOURCE.md` exists and reflects the current upstream or inspiration.
- If a changed skill depends on auxiliary files, make sure a direct install from `skills/` includes them.

## Useful References

- `README.md`
- `docs/architecture.md`
- `skills/writing/writing-skills/anthropic-best-practices.md`
