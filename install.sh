#!/bin/bash
#########################
# install.sh
# Bootstrap dotfiles on a new Ubuntu/Debian machine (Option B: layered apt lists)
#########################

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

INSTALL_BASE=0
INSTALL_DESKTOP=0
INSTALL_DEV=0
LIST_ONLY=0
SKIP_APT=0
SKIP_VIM_PLUGINS=0

usage() {
    cat <<'EOF'
Usage: ./install.sh [OPTIONS]

Install dotfiles dependencies and create symlinks via make.sh.

Options:
  (none)           Install base + desktop + dev, then make.sh
  --desktop-only   Install only packages-desktop.txt (+ make.sh)
  --list           Show packages per layer and exit (dry-run)
  --skip-apt       Skip apt update/install (symlinks and vim-plug only)
  --skip-vim-plugins
                   Skip vim +PlugInstall +qall
  -h, --help       Show this help

Layers (packages-*.txt):
  base     git, curl, build-essential
  desktop  i3wm stack (i3, rofi, picom, feh, ...)
  dev      vim, ripgrep, fzf, gh, texlive, ...
EOF
}

die() {
    echo "error: $*" >&2
    exit 1
}

read_packages() {
    local file="$1"
    [[ -f "$file" ]] || die "missing package list: $file"
    grep -v '^\s*#' "$file" | grep -v '^\s*$' || true
}

apt_cmd() {
    if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
        apt-get "$@"
    else
        command -v sudo >/dev/null || die "sudo is required to install packages"
        sudo apt-get "$@"
    fi
}

check_distro() {
    if [[ ! -f /etc/debian_version ]]; then
        echo "warning: not Debian/Ubuntu; apt steps may fail." >&2
    fi
}

select_layers() {
    case "${1:-}" in
        "")
            INSTALL_BASE=1
            INSTALL_DESKTOP=1
            INSTALL_DEV=1
            ;;
        --desktop-only)
            INSTALL_DESKTOP=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --list)
            LIST_ONLY=1
            INSTALL_BASE=1
            INSTALL_DESKTOP=1
            INSTALL_DEV=1
            ;;
        --skip-apt)
            SKIP_APT=1
            INSTALL_BASE=1
            INSTALL_DESKTOP=1
            INSTALL_DEV=1
            ;;
        --skip-vim-plugins)
            SKIP_VIM_PLUGINS=1
            INSTALL_BASE=1
            INSTALL_DESKTOP=1
            INSTALL_DEV=1
            ;;
        *)
            die "unknown option: $1 (try --help)"
            ;;
    esac
}

collect_packages() {
    local packages=()
    local layer file

    for layer in base desktop dev; do
        case "$layer" in
            base)    [[ "$INSTALL_BASE" -eq 1 ]] || continue ;;
            desktop) [[ "$INSTALL_DESKTOP" -eq 1 ]] || continue ;;
            dev)     [[ "$INSTALL_DEV" -eq 1 ]] || continue ;;
        esac

        file="packages-${layer}.txt"
        while IFS= read -r pkg; do
            packages+=("$pkg")
        done < <(read_packages "$file")
    done

    if ((${#packages[@]} == 0)); then
        die "no package layers selected"
    fi

    printf '%s\n' "${packages[@]}"
}

print_layers() {
    local layer file
    for layer in base desktop dev; do
        case "$layer" in
            base)    [[ "$INSTALL_BASE" -eq 1 ]] || continue ;;
            desktop) [[ "$INSTALL_DESKTOP" -eq 1 ]] || continue ;;
            dev)     [[ "$INSTALL_DEV" -eq 1 ]] || continue ;;
        esac
        file="packages-${layer}.txt"
        echo "==> $file"
        read_packages "$file" | sed 's/^/  /'
        echo
    done
}

install_packages() {
    local packages
    mapfile -t packages < <(collect_packages)

    echo "==> apt update"
    apt_cmd update

    echo "==> apt install (${#packages[@]} packages)"
    apt_cmd install -y "${packages[@]}"
}

run_make() {
    echo "==> make.sh (symlinks)"
    bash "$DIR/make.sh"
}

install_vim_plugins() {
    if [[ "$SKIP_VIM_PLUGINS" -eq 1 ]]; then
        echo "==> skipping vim-plug (PlugInstall)"
        return
    fi

    if ! command -v vim >/dev/null; then
        echo "warning: vim not found; skipping PlugInstall" >&2
        return
    fi

    if [[ -d "$HOME/.vim/plugged" ]] && [[ -n "$(ls -A "$HOME/.vim/plugged" 2>/dev/null)" ]]; then
        echo "==> vim plugins already present (~/.vim/plugged); skipping PlugInstall"
        echo "    (re-run with: rm -rf ~/.vim/plugged && ./install.sh --skip-apt)"
        return
    fi

    echo "==> vim-plug: PlugInstall (first run)"
    vim +PlugInstall +qall
}

print_checklist() {
    cat <<'EOF'

==> Post-install checklist (manual)
  - Log out and back in (or restart) to load i3 session changes
  - Wallpaper: feh expects ~/Daniel/Personal/black.jpeg (see config/i3/config)
  - Keyboard layout: xprofile sets setxkbmap options on X login
  - GitHub CLI: run `gh auth login` if not already configured
  - LaTeX: apt texlive subset installed; full TeX Live may live under /usr/local/texlive/
  - GPU drivers, fonts, and AppImages are not managed by install.sh

EOF
}

# --- main ---

if [[ $# -gt 1 ]]; then
    die "too many arguments (try --help)"
fi

select_layers "${1:-}"
check_distro

if [[ "$LIST_ONLY" -eq 1 ]]; then
    print_layers
    exit 0
fi

if [[ "$SKIP_APT" -eq 0 ]]; then
    install_packages
else
    echo "==> skipping apt (--skip-apt)"
fi

run_make
install_vim_plugins
print_checklist

echo "Done."
