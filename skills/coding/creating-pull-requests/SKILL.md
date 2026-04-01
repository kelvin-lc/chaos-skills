---
name: creating-pull-requests
description: Use when local changes are ready and you need to stage, commit with Conventional Commits, push, and create a GitHub Pull Request — especially when multiple GitHub accounts may require auth switching
---

# Creating Pull Requests

## Overview

End-to-end workflow: inspect changes → commit (Conventional Commits) → push → create PR via `gh`.

**Core principle:** Never create a PR without reviewing the diff first. Automate formatting, but keep the human in the loop on intent.

## When to Use

- Local changes are ready for review
- You need to open a GitHub PR from the current branch
- The repo may use multiple GitHub accounts (SSH aliases)

**When NOT to use:**
- Work is incomplete or tests fail → fix first
- You only need to commit without a PR → just commit and push

## The Process

### 1. Inspect Local Changes

```bash
git status
git diff --stat
git diff          # full diff for context
```

- Summarize the changes in a brief human-readable sentence.
- Determine the **change type** from the diff:

| Type | When |
|------|------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no logic change |
| `refactor` | Restructure, no feature/fix |
| `perf` | Performance improvement |
| `test` | Adding or updating tests |
| `build` | Build system or dependencies |
| `ci` | CI/CD configuration |
| `chore` | Tooling, configs, misc |

### 2. Stage and Commit

Stage all relevant changes:

```bash
git add -A
```

Generate a **Conventional Commit** message:

```
<type>(<scope>): <short description>

<optional body>
```

Examples: `feat(auth): add OAuth2 login`, `fix(api): handle null user`, `docs(readme): update install steps`

Commit:

```bash
git commit -m "<generated message>"
```

If nothing is staged, explain why and ask the user how to proceed.

### 3. Handle Multi-Account GitHub Auth

**Before pushing or creating a PR**, check which GitHub account the remote expects:

```bash
git remote get-url origin
```

**If the remote URL contains `git@personal:kelvin-lc`** (or similar SSH alias pointing to `kelvin-lc`), ensure `gh` is authenticated as the correct user:

```bash
# Check current gh auth status
gh auth status

# If logged in as the wrong user, switch:
gh auth switch --user kelvin-lc
```

**Rule of thumb:** SSH alias `personal` → GitHub user `kelvin-lc`. If `gh` is logged into a different account, the PR creation will fail with a 403/404. Always verify before proceeding.

### 4. Push Branch

```bash
BRANCH=$(git symbolic-ref --short HEAD)
git push -u origin "$BRANCH"
```

Report any push errors clearly. Common issues:
- **No upstream** → the `-u` flag handles this
- **Permission denied** → likely wrong SSH key or `gh` account; revisit Step 3
- **Diverged history** → ask user whether to rebase or force-push

### 5. Create Pull Request

Prepare title and body:

- **Title:** Same Conventional Commit format as the commit message
- **Body:** Summary of changes, related issue links, testing notes

```bash
gh pr create \
  --title "<type>(<scope>): <description>" \
  --body "<body content>"
```

Or auto-fill from the commit:

```bash
gh pr create --fill
```

### 6. Report Result

- Display the created PR URL.
- Summarize what was done (branch, commit, PR link).

## Quick Reference

| Step | Command | Key check |
|------|---------|-----------|
| Inspect | `git diff --stat` | Understand what changed |
| Stage | `git add -A` | All files included |
| Commit | `git commit -m "…"` | Conventional format |
| Auth | `gh auth status` | Correct account for remote |
| Push | `git push -u origin $BRANCH` | No permission errors |
| PR | `gh pr create --title "…"` | Title matches commit |

## Common Mistakes

**Wrong GitHub account**
- **Problem:** `gh pr create` returns 403/404 because `gh` is authed as the wrong user
- **Fix:** Check `git remote get-url origin` for SSH alias → switch `gh auth` accordingly

**Skipping diff review**
- **Problem:** PR contains unintended changes (debug code, unrelated files)
- **Fix:** Always run `git diff --stat` and review before staging

**Generic commit messages**
- **Problem:** `fix: stuff` — unhelpful for reviewers
- **Fix:** Include scope and a clear description: `fix(cart): correct total when coupon applied`

**Pushing to wrong branch**
- **Problem:** Accidentally push to `main` instead of feature branch
- **Fix:** Always verify current branch with `git symbolic-ref --short HEAD` first
