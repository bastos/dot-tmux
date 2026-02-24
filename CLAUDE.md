# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal tmux configuration repository. Single-file config (`tmux.conf`) with a Ghostty-inspired dark theme, vi-style bindings, and 14 plugins managed by TPM.

## Key Commands

- **Reload config in tmux:** `prefix + r` (runs `tmux source-file ~/.config/tmux/tmux.conf`)
- **Install plugins:** `prefix + I` (TPM fetches all `@plugin` entries)
- **Update plugins:** `prefix + U`
- **Remove unlisted plugins:** `prefix + Alt-u`

## Architecture

Everything lives in `tmux.conf`, organized into clearly marked sections:

1. **General Settings** — terminal overrides, mouse, indexing, scrollback, timing
2. **Key Bindings** — prefix (`C-Space` / `C-b`), splits, pane/window navigation, copy mode
3. **Ghostty-Inspired Theme** — colors, status bar, pane borders, window formatting
4. **Plugin Configuration** — per-plugin `@`-variable settings
5. **Terminal-Specific Optimizations** — conditional blocks for Ghostty, Alacritty, Linux
6. **Plugin List** — all `@plugin` declarations
7. **Initialize Plugin Manager** — `run '~/.config/tmux/plugins/tpm/tpm'` (must stay last)

## Cross-Platform Pattern

The config uses `if-shell` blocks extensively for platform/terminal detection:
- `uname | grep -q Darwin` for macOS vs Linux
- `$TERM_PROGRAM` / `$TERM` for terminal-specific settings
- `command -v xclip` / `command -v wl-copy` for Linux clipboard tool detection

When adding new platform-conditional settings, follow this existing pattern rather than introducing alternative detection methods.

## Important Constraints

- The TPM initialization line (`run '~/.config/tmux/plugins/tpm/tpm'`) **must remain the very last line** in `tmux.conf`.
- Plugin directories under `plugins/` are git-ignored except `plugins/tpm/` itself.
- The theme uses a specific color palette (see comments in the theme section) — keep new UI elements consistent with those hex values.
- `reattach-to-user-namespace` is required on macOS for clipboard integration.
