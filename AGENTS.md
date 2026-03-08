# Agent Guide for Dotfiles Repository

This repository contains personal development environment configurations (Neovim, Kitty, Tmux, Zsh).

## Code Style & Formatting

### Lua (Neovim Configuration)
- Formatter: `stylua` (format on save disabled for Lua)
- Structure: Module pattern with `return { ... }`
- Type annotations: Use `---@module` and `---@type` comments for LuaLS support
- Comments: Minimal, only essential documentation
- File organization: `nvim/lua/config/` for core settings, `nvim/lua/plugins/` for plugin specs

### Shell Scripts (Zsh, Tmux)
- Formatters: `shfmt` with 2-space indentation
- Style: POSIX-compatible where possible
- Comments: Section headers with `# ===` for organization
- Aliases: Define in zsh/zshrc for convenience

### Configuration Files
- Tmux: Vi-style key bindings, plugin manager (tpm)
- Kitty: Standard kitty.conf format, tab bar at top
- JSON: Standard JSON format, schema validation where applicable

## Formatters Configuration

From nvim/lua/config/options.lua:
- Lua: `stylua`
- Python: `isort`, `black`
- JavaScript: `prettierd` or `prettier` (prefers prettierd)
- Shell: `shfmt -i 2` (2-space indent)

## File Organization

```
.
├── nvim/
│   └── lua/
│       ├── config/      # Core Neovim settings (options, keymaps, autocmds)
│       └── plugins/     # Plugin specifications (core, colorscheme, etc.)
├── kitty/
│   └── kitty.conf       # Terminal emulator configuration
├── tmux/
│   └── .tmux.conf       # Tmux configuration (vi mode, key bindings)
├── zsh/
│   ├── zshrc            # Shell configuration
│   └── starship.toml    # Prompt configuration
└── opencode/
    └── opencode.json    # AI assistant configuration
```

## Conventions

- **No autoformat** for Lua and C files (explicitly disabled)
- **Vi-style key bindings** preferred in terminal tools (tmux)
- **Minimal comments** - code should be self-documenting
- **Plugin management**: Use lazy.nvim for Neovim, tpm for Tmux
- **Theme**: Catppuccin color scheme across tools

## Git

- Ignore: `custom/` directory (personal machine-specific configs)
- No build, test, or lint commands - this is a configuration-only repository

## Tools Used

- **Shell Framework**: zimfw for Zsh
- **Prompt**: starship for cross-shell prompt
- **Terminal**: kitty with copy-on-select enabled
- **Multiplexer**: tmux with vi mode and sensible defaults
- **Editor**: Neovim with LazyVim distribution
- **AI Assistant**: opencode with local/remote LLM provider

## When Making Changes

1. Test configuration by sourcing/reloading the respective tool
2. Follow existing patterns in the same directory
3. Keep changes minimal and focused
4. Use appropriate formatters for the file type
5. No tests needed - configurations are validated by tool startup
