# Skill Provenance Template

Use a neighboring `SOURCE.md` when a skill's lineage matters and should remain easy to audit.

Recommended template:

```markdown
# Source

- Origin repo:
- Origin path:
- Imported from commit or tag:
- Import date:
- Local adaptations:
- Notes:
```

Guidelines:

- Keep the skill folder name focused on purpose, not origin.
- Update `SOURCE.md` when upstream references or local rewrites materially change.
- If a skill combines multiple inspirations, list each one explicitly instead of compressing them into the folder name.
