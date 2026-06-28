#!/bin/bash
# Install Neovim >= 0.10 for vscode-neovim (Cursor/VS Code).
# Ubuntu 24.04 apt ships 0.9.5, which vscode-neovim 1.19+ rejects.

set -euo pipefail

NVIM_VERSION="${NVIM_VERSION:-v0.10.3}"
NVIM_DIR="${NVIM_DIR:-$HOME/.local/opt/nvim-linux64}"
NVIM_BIN="$NVIM_DIR/bin/nvim"
TARBALL="nvim-linux64.tar.gz"
URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${TARBALL}"

min_version_ok() {
    local ver="$1"
    local major minor patch
    IFS=. read -r major minor patch <<<"${ver#v}"
    major=${major:-0}; minor=${minor:-0}; patch=${patch:-0}
    [[ "$major" -gt 0 ]] || [[ "$major" -eq 0 && "$minor" -ge 10 ]]
}

if [[ -x "$NVIM_BIN" ]]; then
    installed=$("$NVIM_BIN" --version | head -1 | sed -n 's/^NVIM v\([0-9.]*\).*/\1/p')
    if min_version_ok "$installed"; then
        echo "ok: $NVIM_BIN (NVIM v$installed)"
        exit 0
    fi
    echo "warning: $NVIM_BIN is v$installed (< 0.10); reinstalling" >&2
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "==> Downloading Neovim $NVIM_VERSION"
curl -fsSL -o "$tmp/$TARBALL" "$URL"

echo "==> Installing to $NVIM_DIR"
rm -rf "$NVIM_DIR"
mkdir -p "$(dirname "$NVIM_DIR")"
tar xzf "$tmp/$TARBALL" -C "$(dirname "$NVIM_DIR")"

"$NVIM_BIN" --version | head -1
echo "==> Set Cursor: vscode-neovim.neovimExecutablePaths.linux = $NVIM_BIN"
