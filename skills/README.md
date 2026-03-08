# Skills Management (Scheme A: Git Subtree)

This repository manages skills with a split layout:

- `skills/local/`: self-designed skills maintained only in this repo
- `skills/vendor/<name>/`: cloned third-party skill sets managed with `git subtree`

## Why this layout

- One git repository for all skills
- Local edits on vendor skills are allowed
- Upstream updates stay available with subtree pull

## Vendor source registry

Vendor repositories are tracked in `skills/vendors.txt`:

```text
# name|repo_url|branch
example|https://github.com/org/skills-example.git|main
```

## Common workflows

Add a vendor repository:

```bash
./scripts/skills-vendor.sh add <name> <repo_url> [branch]
```

Sync one vendor:

```bash
./scripts/skills-vendor.sh sync <name>
```

Sync all vendors from registry:

```bash
./scripts/skills-vendor.sh sync-all
```

List registered vendors:

```bash
./scripts/skills-vendor.sh list
```

## Conflict handling recommendation

When pulling upstream into a vendor subtree, resolve conflicts in place and commit immediately. Keep vendor-local customizations small and isolated to reduce future merge conflicts.
