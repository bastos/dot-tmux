# Repository Guidelines

## Project Structure & Module Organization
- `tmux.conf` is the single source of truth. It is organized into bannered sections: General Settings, Key Bindings, Theme, Plugin Configuration, Terminal-Specific Optimizations, Plugin List, and TPM initialization.
- `README.md` contains installation steps, plugin list, and keybinding reference for users.
- `CLAUDE.md` documents contributor/agent constraints for safe edits.
- `plugins/` is TPM-managed runtime content. Do not edit plugin code here; only `plugins/tpm/` is intentionally allowed to be tracked.
- `.gitignore` excludes plugin checkouts and editor/OS noise.

## Build, Test, and Development Commands
- No build step exists; this repository is configuration-only.
- Start tmux locally: `tmux`
- Reload config in an active session: `prefix + r` (or run `tmux source-file ~/.config/tmux/tmux.conf`)
- Plugin lifecycle via TPM:
  - Install declared plugins: `prefix + I`
  - Update plugins: `prefix + U`
  - Remove unlisted plugins: `prefix + Alt-u`
- Inspect declared plugins quickly: `rg "^set -g @plugin" tmux.conf`

## Coding Style & Naming Conventions
- Keep `tmux.conf` ASCII and declarative: one setting/binding per line.
- Preserve the existing section banner format (`# ===============================================`) and place additions in the correct section.
- Use 4-space indentation inside `if-shell { ... }` blocks.
- Follow existing option naming patterns for plugin variables (for example `@continuum-save-interval`).
- Keep `run '~/.config/tmux/plugins/tpm/tpm'` as the final line in `tmux.conf`.

## Testing Guidelines
- There is no automated test framework in this repo.
- After changes, run manual smoke tests:
  1. Reload config and confirm no tmux parse/runtime errors.
  2. Exercise changed keybindings/features directly.
  3. Verify clipboard behavior on target OS (`pbcopy` on macOS, `xclip`/`wl-copy` on Linux).
- For cross-platform edits, validate behavior in at least one macOS terminal and one Linux terminal when possible.

## Commit & Pull Request Guidelines
- This repository currently has no established commit history; use Conventional Commits going forward (for example `feat(tmux): add session switch binding`).
- Keep commits focused to one logical change.
- PRs should include a short summary, motivation, any README updates for user-visible behavior, and screenshots/GIFs when theme or status-line visuals change.
