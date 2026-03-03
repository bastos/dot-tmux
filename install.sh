#!/usr/bin/env bash
# ============================================================
# tmux configuration installer
#
# Usage (default path ~/.config/tmux):
#   curl -fsSL https://raw.githubusercontent.com/bastos/dot-tmux/main/install.sh | bash
#
# Custom install path:
#   curl -fsSL https://raw.githubusercontent.com/bastos/dot-tmux/main/install.sh | bash -s -- --path ~/.tmux
#
# Options:
#   --path <dir>   Install into <dir> instead of ~/.config/tmux
#   --help         Show this help
# ============================================================
set -euo pipefail

# ---- Defaults ----------------------------------------------
REPO_URL="https://github.com/bastos/dot-tmux.git"
DEFAULT_INSTALL_DIR="${HOME}/.config/tmux"
INSTALL_DIR="${DEFAULT_INSTALL_DIR}"
TPM_REPO="https://github.com/tmux-plugins/tpm"
# ------------------------------------------------------------

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

info()    { echo -e "${CYAN}${BOLD}==>${RESET} $*"; }
success() { echo -e "${GREEN}${BOLD} ✓${RESET} $*"; }
warn()    { echo -e "${YELLOW}${BOLD} !${RESET} $*"; }
die()     { echo -e "${RED}${BOLD}ERROR:${RESET} $*" >&2; exit 1; }

usage() {
    echo "Usage: install.sh [--path <dir>] [--help]"
    echo ""
    echo "  --path <dir>   Install into <dir>  (default: ~/.config/tmux)"
    echo "  --help         Show this help"
    echo ""
    echo "When piping through curl, pass flags like this:"
    echo "  curl -fsSL <url> | bash -s -- --path ~/.tmux"
    exit 0
}

# ---- Argument parsing --------------------------------------
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --path)
                [[ -z "${2:-}" ]] && die "--path requires an argument"
                # Expand ~ manually (not expanded inside double quotes)
                INSTALL_DIR="${2/#\~/$HOME}"
                shift 2
                ;;
            --help|-h)
                usage
                ;;
            *)
                die "Unknown option: $1\nRun with --help for usage."
                ;;
        esac
    done
}

# ---- Dependency checks -------------------------------------
check_deps() {
    local missing=()
    for cmd in git tmux; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        die "Missing required dependencies: ${missing[*]}\n  Install them and re-run."
    fi
}

# ---- Verify parent directory exists ------------------------
check_parent_dir() {
    local parent
    parent="$(dirname "$INSTALL_DIR")"
    if [[ ! -d "$parent" ]]; then
        die "Parent directory does not exist: ${parent}\n  Create it first:\n    mkdir -p ${parent}"
    fi
    # When using a custom --path, require the target itself to already exist
    # so the user consciously picks an install location.
    if [[ "$INSTALL_DIR" != "$DEFAULT_INSTALL_DIR" && ! -d "$INSTALL_DIR" ]]; then
        die "Target directory does not exist: ${INSTALL_DIR}\n  Create it first:\n    mkdir -p ${INSTALL_DIR}"
    fi
}

# ---- Backup existing config --------------------------------
backup_existing() {
    if [[ -e "$INSTALL_DIR" ]]; then
        local backup="${INSTALL_DIR}.bak.$(date +%Y%m%d%H%M%S)"
        warn "Found existing config at ${INSTALL_DIR}"
        warn "Backing it up to ${backup}"
        mv "$INSTALL_DIR" "$backup"
    fi
}

# ---- Clone repo --------------------------------------------
clone_repo() {
    info "Cloning tmux config into ${INSTALL_DIR} …"
    git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"
    success "Repo cloned"
}

# ---- Install TPM -------------------------------------------
install_tpm() {
    local tpm_dir="${INSTALL_DIR}/plugins/tpm"
    if [[ -d "${tpm_dir}/.git" ]]; then
        info "TPM already present — skipping"
    else
        info "Installing TPM …"
        git clone --depth=1 "$TPM_REPO" "$tpm_dir"
        success "TPM installed"
    fi
}

# ---- Install TPM plugins non-interactively -----------------
install_plugins() {
    local tpm_script="${INSTALL_DIR}/plugins/tpm/bin/install_plugins"
    info "Installing tmux plugins …"

    # TPM resolves TMUX_PLUGIN_MANAGER_PATH via `tmux show-environment -g`
    # against the running server (if any). Set it on the server so the path
    # is honoured even when called from inside an existing tmux session.
    local prev_path=""
    if tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH &>/dev/null; then
        prev_path="$(tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)"
    fi
    tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "${INSTALL_DIR}/plugins/" 2>/dev/null || true

    TMUX_PLUGIN_MANAGER_PATH="${INSTALL_DIR}/plugins/" "$tpm_script"
    local exit_code=$?

    # Restore previous value
    if [[ -n "$prev_path" ]]; then
        tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$prev_path" 2>/dev/null || true
    else
        tmux set-environment -gu TMUX_PLUGIN_MANAGER_PATH 2>/dev/null || true
    fi

    [[ $exit_code -eq 0 ]] || die "Plugin installation failed"
    success "Plugins installed"
}

# ---- macOS extras ------------------------------------------
install_macos_extras() {
    if [[ "$(uname)" != "Darwin" ]]; then return; fi

    if ! command -v reattach-to-user-namespace &>/dev/null; then
        if command -v brew &>/dev/null; then
            info "Installing reattach-to-user-namespace (macOS clipboard helper) …"
            brew install reattach-to-user-namespace
            success "reattach-to-user-namespace installed"
        else
            warn "Homebrew not found — install reattach-to-user-namespace manually:"
            warn "  brew install reattach-to-user-namespace"
        fi
    else
        success "reattach-to-user-namespace already installed"
    fi
}

# ---- fzf check / install ----------------------------------
check_fzf() {
    if command -v fzf &>/dev/null; then
        success "fzf found"
        return
    fi

    if [[ "$(uname)" == "Darwin" ]]; then
        if command -v brew &>/dev/null; then
            info "Installing fzf via Homebrew …"
            brew install fzf
            success "fzf installed"
        else
            warn "fzf not found — install it: brew install fzf"
        fi
    else
        # Linux: try known package managers in order
        if command -v apt-get &>/dev/null; then
            info "Installing fzf via apt …"
            sudo apt-get install -y fzf
            success "fzf installed"
        elif command -v pacman &>/dev/null; then
            info "Installing fzf via pacman …"
            sudo pacman -S --noconfirm fzf
            success "fzf installed"
        elif command -v dnf &>/dev/null; then
            info "Installing fzf via dnf …"
            sudo dnf install -y fzf
            success "fzf installed"
        else
            warn "fzf not found — install it manually: https://github.com/junegunn/fzf#installation"
        fi
    fi
}

# ---- Warn if custom path needs manual wiring ---------------
print_path_instructions() {
    # tmux auto-discovers ~/.config/tmux/tmux.conf; a custom path needs a stub
    if [[ "$INSTALL_DIR" != "$DEFAULT_INSTALL_DIR" ]]; then
        local conf="${INSTALL_DIR}/tmux.conf"
        local stub="${HOME}/.tmux.conf"
        echo ""
        echo -e "${YELLOW}${BOLD}Custom install path detected.${RESET}"
        echo -e "tmux won't load ${CYAN}${conf}${RESET} automatically."
        echo ""
        echo -e "  Add this line to ${CYAN}${stub}${RESET}:"
        echo ""
        echo -e "    ${BOLD}source-file ${conf}${RESET}"
        echo ""
        echo -e "  Or create the stub automatically now:"
        echo ""
        echo -e "    ${CYAN}echo 'source-file ${conf}' >> ${stub}${RESET}"
        echo ""
    fi
}

# ---- Final instructions ------------------------------------
print_next_steps() {
    echo ""
    echo -e "${BOLD}Installation complete!${RESET}"
    echo ""
    echo -e "  Start tmux:               ${CYAN}tmux${RESET}"
    echo -e "  Reload config:            ${CYAN}prefix + r${RESET}"
    echo -e "  Update plugins:           ${CYAN}prefix + U${RESET}"
    echo ""
    echo -e "  Full keybinding reference: ${CYAN}${INSTALL_DIR}/README.md${RESET}"
    echo ""
}

# ---- Main --------------------------------------------------
main() {
    parse_args "$@"

    echo ""
    echo -e "${BOLD}  tmux configuration installer${RESET}"
    echo -e "  ${CYAN}${REPO_URL}${RESET}"
    echo -e "  Installing into: ${CYAN}${INSTALL_DIR}${RESET}"
    echo ""

    check_deps
    check_parent_dir
    backup_existing
    clone_repo
    install_tpm
    install_plugins
    install_macos_extras
    check_fzf
    print_path_instructions
    print_next_steps
}

main "$@"
