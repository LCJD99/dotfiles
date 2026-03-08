# Skills Subtree Management Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement a unified skill-management layout where local and vendor skills live in one git repo, and vendor skills stay updatable from upstream.

**Architecture:** Use `skills/local` for first-party skills and `skills/vendor/<name>` for third-party skills imported with `git subtree`. Keep a plain-text registry in `skills/vendors.txt` and a helper script to add/sync/list vendors consistently.

**Tech Stack:** Git subtree, Bash script, Markdown docs

---

### Task 1: Create repository layout for local and vendor skills

**Files:**
- Create: `skills/local/.gitkeep`
- Create: `skills/vendor/.gitkeep`
- Create: `skills/vendors.txt`

**Step 1: Create directory placeholders**

```bash
mkdir -p skills/local skills/vendor
touch skills/local/.gitkeep skills/vendor/.gitkeep
```

**Step 2: Create vendor registry with header**

```text
# name|repo_url|branch
```

**Step 3: Commit**

```bash
git add skills/local/.gitkeep skills/vendor/.gitkeep skills/vendors.txt
git commit -m "chore: initialize skills subtree directory layout"
```

### Task 2: Add automation script for subtree operations

**Files:**
- Create: `scripts/skills-vendor.sh`

**Step 1: Implement command interface**

Supported commands:
- `add <name> <repo_url> [branch]`
- `sync <name>`
- `sync-all`
- `list`

**Step 2: Implement add behavior**

Use:

```bash
git subtree add --prefix="skills/vendor/<name>" <repo_url> <branch> --squash
```

and append to registry.

**Step 3: Implement sync behavior**

Use:

```bash
git subtree pull --prefix="skills/vendor/<name>" <repo_url> <branch> --squash
```

for existing vendors; for empty target, fallback to `subtree add`.

**Step 4: Implement sync-all and list behavior**

- Parse `skills/vendors.txt`
- Skip comments and blank lines
- Sync each registered vendor

**Step 5: Mark script executable and commit**

```bash
chmod +x scripts/skills-vendor.sh
git add scripts/skills-vendor.sh
git commit -m "feat: add skills vendor subtree management script"
```

### Task 3: Document operating workflow

**Files:**
- Create: `skills/README.md`

**Step 1: Document directory split**

- `skills/local`
- `skills/vendor/<name>`

**Step 2: Document registry format**

- `name|repo_url|branch`

**Step 3: Document add/sync/sync-all/list commands**

Include exact command snippets that match script behavior.

**Step 4: Commit documentation**

```bash
git add skills/README.md
git commit -m "docs: describe subtree-based skills workflow"
```
