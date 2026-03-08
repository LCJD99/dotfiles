# My dotfile Configuration

## Terminal Emulation

### kitty


## shell

### bash

### zsh

- [zimfw](https://github.com/zimfw/zimfw) as zsh framework
- [starship](https://github.com/starship/starship) as prompt template 


## Editor

### vim


### nvim

### vscode


## notebook

### obsidian

## skills

This repo manages skills in a split layout:

- `skills/local/`: locally designed skills
- `skills/vendor/<name>/`: third-party skills managed by `git subtree`

### vendor workflow

- Add vendor: `./scripts/skills-vendor.sh add <name> <repo_url> [branch]`
- Sync one vendor: `./scripts/skills-vendor.sh sync <name>`
- Sync all vendors: `./scripts/skills-vendor.sh sync-all`
- List vendors: `./scripts/skills-vendor.sh list`
