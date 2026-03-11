# tmux Configuration

My personal [tmux](https://github.com/tmux/tmux) configuration — a productive terminal multiplexer setup tuned for macOS (and usable on Linux) with a clean Ghostty-inspired dark theme, vi-style keybindings, and a hand-picked set of plugins managed by [TPM](https://github.com/tmux-plugins/tpm).

## Features

- Ghostty-inspired dark color scheme
- Vi-style copy mode with system clipboard integration
- Mouse support enabled
- True color (24-bit) support for modern terminals
- Session persistence (resurrect: manual save/restore)
- Fuzzy search across scrollback, URLs, and terminal output
- Sidebar directory tree, copycat search, and a command palette

---

## Requirements

- [tmux](https://github.com/tmux/tmux) ≥ 3.2
- [TPM](https://github.com/tmux-plugins/tpm) — Tmux Plugin Manager
- [fzf](https://github.com/junegunn/fzf) — required by several plugins
- macOS: `reattach-to-user-namespace` (`brew install reattach-to-user-namespace`)
- Linux: `xclip` or `wl-copy` for clipboard integration

---

## Installation

### One-liner

```sh
curl -fsSL https://raw.githubusercontent.com/bastos/dot-tmux/main/install.sh | bash
```

The script will:
- Back up any existing `~/.config/tmux` directory
- Clone this repo into `~/.config/tmux`
- Install TPM and all plugins
- Install `reattach-to-user-namespace` on macOS (requires Homebrew)
- Install `fzf` automatically (Homebrew on macOS; apt / pacman / dnf on Linux)

Then just start tmux:

```sh
tmux
```

### Manual

```sh
# 1. Clone
git clone https://github.com/bastos/dot-tmux.git ~/.config/tmux

# 2. Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# 3. (macOS) clipboard helper
brew install reattach-to-user-namespace

# 4. Start tmux and install plugins
tmux
# press prefix + I
```

---

## Plugins

| Plugin | Description |
|--------|-------------|
| [tpm](https://github.com/tmux-plugins/tpm) | Plugin manager |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible default settings |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save and restore sessions manually |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank) | Copy to system clipboard |
| [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat) | Regex search in scrollback |
| [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar) | Directory tree sidebar |
| [tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight) | Status bar indicator for prefix/copy mode |
| [tmux-sessionist](https://github.com/tmux-plugins/tmux-sessionist) | Enhanced session management |
| [tmux-open](https://github.com/tmux-plugins/tmux-open) | Open files/URLs from copy mode |
| [extrakto](https://github.com/laktak/extrakto) | Extract text from terminal output via fzf |
| [tmux-fzf-url](https://github.com/wfxr/tmux-fzf-url) | Pick and open URLs with fzf |
| [tmux-fuzzback](https://github.com/roosta/tmux-fuzzback) | Fuzzy search scrollback buffer |
| [tmux-command-palette](https://github.com/lost-melody/tmux-command-palette) | Searchable keybinding palette |

---

## Keybindings Reference

**Prefix keys: `Ctrl-Space`** (primary) **· `Ctrl-b`** (secondary)

---

## Core

| Key | Action |
|-----|--------|
| `prefix + r` | Reload tmux config |
| `Ctrl-k` | Clear screen and scrollback history (no prefix) |

---

## Panes

| Key | Action |
|-----|--------|
| `prefix + \|` | Split pane vertically (current path) |
| `prefix + -` | Split pane horizontally (current path) |
| `prefix + h` | Focus pane left |
| `prefix + j` | Focus pane down |
| `prefix + k` | Focus pane up |
| `prefix + l` | Focus pane right |
| `Alt + ←` | Focus pane left (no prefix) |
| `Alt + →` | Focus pane right (no prefix) |
| `Alt + ↑` | Focus pane up (no prefix) |
| `Alt + ↓` | Focus pane down (no prefix) |
| `prefix + H` | Resize pane left 5 cells (repeatable) |
| `prefix + J` | Resize pane down 5 cells (repeatable) |
| `prefix + K` | Resize pane up 5 cells (repeatable) |
| `prefix + L` | Resize pane right 5 cells (repeatable) |

---

## Windows

| Key | Action |
|-----|--------|
| `prefix + c` | New window (current path) |
| `Shift + ←` | Previous window (no prefix) |
| `Shift + →` | Next window (no prefix) |

---

## Copy Mode (vi)

| Key | Action |
|-----|--------|
| `prefix + [` | Enter copy mode |
| `v` | Begin selection |
| `Ctrl-v` | Toggle rectangle selection |
| `y` | Copy selection to clipboard |
| `Y` | "Put" selection — paste to command line |
| `n` | Next search match (copycat) |
| `N` | Previous search match (copycat) |
| `Enter` | Copy highlighted match (vi mode) |
| `MouseDragEnd1Pane` | Copy mouse selection to clipboard |

---

## Sessions — tmux-sessionist

| Key | Action |
|-----|--------|
| `prefix + g` | Switch session by name (fuzzy) |
| `prefix + C` | Create new session by name |
| `prefix + X` | Kill current session (stay in tmux) |
| `prefix + S` | Switch to last session |
| `prefix + @` | Promote current pane to new session |
| `prefix + Ctrl-@` | Promote current window to new session |
| `prefix + t h/−/"` | Join marked pane into current — horizontal split |
| `prefix + t v/\|/%` | Join marked pane into current — vertical split |
| `prefix + t f/@` | Join marked pane into current — full screen |

---

## Session Persistence — tmux-resurrect

| Key | Action |
|-----|--------|
| `prefix + Ctrl-s` | Save session |
| `prefix + Ctrl-r` | Restore session |

---

## Yank — tmux-yank

| Key | Context | Action |
|-----|---------|--------|
| `prefix + y` | Normal | Copy command line to clipboard |
| `prefix + Y` | Normal | Copy current pane's working directory to clipboard |
| `y` | Copy mode | Copy selection to clipboard |
| `Y` | Copy mode | Paste selection to command line |

---

## Search — tmux-copycat

| Key | Action |
|-----|--------|
| `prefix + /` | Regex / string search |
| `prefix + Ctrl-f` | File search |
| `prefix + Ctrl-g` | Git status file search |
| `prefix + Alt-h` | SHA-1/SHA-256 hash search |
| `prefix + Ctrl-u` | URL search |
| `prefix + Ctrl-d` | Number search |
| `prefix + Alt-i` | IP address search |

---

## Open — tmux-open (copy mode)

| Key | Action |
|-----|--------|
| `o` | Open selection with system default app |
| `Ctrl-o` | Open selection in `$EDITOR` |
| `Shift-s` | Search selection in browser (Google) |

---

## Sidebar — tmux-sidebar

| Key | Action |
|-----|--------|
| `prefix + Tab` | Toggle directory tree sidebar |
| `prefix + Backspace` | Toggle sidebar and focus it |

---

## Fuzzy Tools

| Key | Action |
|-----|--------|
| `prefix + Tab` | **Extrakto** — extract & insert text from terminal output |
| `prefix + u` | **tmux-fzf-url** — pick and open a URL from the pane |
| `prefix + ?` | **tmux-fuzzback** — fuzzy search scrollback buffer |

---

## Command Palette — tmux-command-palette

| Key | Action |
|-----|--------|
| `prefix + h` | Open keybinding palette (prefix key table) |
| `prefix + BSpace` | Open keybinding palette (root key table) |
| `?` (copy-mode) | Open keybinding palette (copy-mode key table) |

---

## Plugin Manager — TPM

| Key | Action |
|-----|--------|
| `prefix + I` | Install plugins |
| `prefix + U` | Update plugins |
| `prefix + Alt-u` | Remove unlisted plugins |
