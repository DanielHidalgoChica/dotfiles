# Dotfiles

Personal configuration for an i3wm + Vim development environment on Ubuntu/Debian, managed with Git and the [XDG Base Directory](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) layout (`~/.config`).

![Shell](https://img.shields.io/badge/Shell-Bash-green)
![Editor](https://img.shields.io/badge/Editor-Vim-brightgreen)
![WM](https://img.shields.io/badge/WM-i3-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Contents

- [Overview](#overview)
- [Repository layout](#repository-layout)
- [Installation](#installation)
- [Day-to-day usage](#day-to-day-usage)
- [Package layers](#package-layers)
- [What's included](#whats-included)
- [Vim and LaTeX](#vim-and-latex)
- [Manual setup after install](#manual-setup-after-install)
- [License](#license)

## Overview

This repo is the single source of truth for shell, editor, window manager, and selected XDG configs. Two scripts drive setup:

| Script | Purpose |
|--------|---------|
| **`install.sh`** | New machine: install apt packages by layer, run `make.sh`, install vim-plug plugins |
| **`make.sh`** | Create symlinks from `~/dotfiles` into `$HOME` and `~/.config`; backup conflicting local files to `~/dotfiles_old/` |

`make.sh` is **idempotent** — safe to re-run. If a symlink already points to the correct target, nothing changes. If you have a local copy that differs, it is moved to `~/dotfiles_old/` (with a timestamp suffix on collision) before linking.

Configs with secrets are handled explicitly: only `config/gh/config.yml` is versioned; `~/.config/gh/hosts.yml` (GitHub auth tokens) stays local and is listed in `.gitignore`.

## Repository layout

```
~/dotfiles/
├── install.sh, make.sh
├── packages-base.txt, packages-desktop.txt, packages-dev.txt
├── config/                 # XDG configs → ~/.config/
│   ├── i3/                 # i3 + i3blocks.conf
│   ├── picom/
│   ├── gtk-3.0/            # dark theme preference
│   └── gh/config.yml
├── vim/, vimrc             # editor + vim-plug (plug.vim bundled)
├── bashrc, bash_aliases, bash_profile, xprofile
└── gitconfig, editorconfig, vimrc_minimal
```

**Symlink map**

| Source in repo | Target |
|--------------|--------|
| `bashrc`, `bash_profile`, `bash_aliases`, `vimrc`, `vim`, `xprofile`, `gitconfig`, `editorconfig`, `vimrc_minimal` | `~/.<name>` |
| `config/i3`, `config/picom`, `config/gtk-3.0` | `~/.config/<name>` |
| `config/gh/config.yml` | `~/.config/gh/config.yml` (file only; `hosts.yml` stays local) |

## Installation

### New machine (recommended)

Requires Ubuntu or Debian with `sudo` and network access.

```sh
git clone https://github.com/DanielHidalgoChica/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

This installs all three package layers (base + desktop + dev), creates symlinks, and runs `vim +PlugInstall +qall` on first use if `~/.vim/plugged` is empty.

**Options**

```sh
./install.sh --list            # show packages per layer (dry-run)
./install.sh --desktop-only    # only packages-desktop.txt
./install.sh --skip-apt        # symlinks + vim-plug only
./install.sh --skip-vim-plugins
./install.sh --help
```

Then log out and back in (or restart) to load the i3 session.

### Existing machine (configs only)

If packages are already installed and you only want to link dotfiles:

```sh
cd ~/dotfiles
./make.sh
# or
./install.sh --skip-apt
```

## Day-to-day usage

1. Edit files **in `~/dotfiles`** (or via symlinks — same inode).
2. Commit and push from the repo.
3. On another machine: `git pull && ./make.sh` (re-run `install.sh` only when adding apt dependencies).

To add a new XDG config directory:

1. Copy it to `~/dotfiles/config/<name>/`
2. Add `<name>` to `config_files` in `make.sh`
3. Add apt packages to the appropriate `packages-*.txt` if needed

## Package layers

Packages are plain lists (one per line, `#` comments allowed). Target: **Ubuntu/Debian** via `apt`.

| File | Role | Examples |
|------|------|----------|
| `packages-base.txt` | CLI essentials | git, curl, build-essential |
| `packages-desktop.txt` | i3 stack | i3, rofi, picom, feh, dunst, pulseaudio, … |
| `packages-dev.txt` | Editor + dev | vim, ripgrep, fzf, gh, texlive, latexmk, zathura, xdotool |

Install manually without the script:

```sh
sudo apt update
sudo apt install $(grep -v '^#' packages-base.txt packages-desktop.txt packages-dev.txt | tr '\n' ' ')
```

## What's included

| Component | Description |
|-----------|-------------|
| **i3wm** | Tiling WM, i3blocks status bar, autostart (dex), lock (i3lock + xss-lock) |
| **picom** | Compositor |
| **Shell** | bashrc, aliases, profile; fzf + ripgrep integration |
| **Vim** | vim-plug, UltiSnips, vimtex, fzf.vim, tex-conceal, EditorConfig |
| **LaTeX** | vimtex + latexmk + zathura; extensive UltiSnips snippets |
| **Git** | gitconfig with `gh` credential helper |
| **GitHub CLI** | `config/gh/config.yml` (run `gh auth login` separately) |
| **GTK** | prefer dark theme via `gtk-3.0/settings.ini` |
| **X11** | xprofile (keyboard layout via setxkbmap) |

Tools used by i3 config but **without custom XDG config** in this repo (defaults from apt): rofi, dunst, feh, neofetch.

## Vim and LaTeX

Plugins (via [vim-plug](https://github.com/junegunn/vim-plug), declared in `vimrc`):

- **[vimtex](https://github.com/lervag/vimtex)** — compile with latexmk, PDF via zathura
- **[UltiSnips](https://github.com/SirVer/ultisnips)** — snippets (`vim/UltiSnips/tex/`, `jj_snippets/`)
- **[fzf.vim](https://github.com/junegunn/fzf.vim)** — fuzzy file/buffer search
- **[tex-conceal.vim](https://github.com/KeitaNakamura/tex-conceal.vim)** — pretty math symbols

Key bindings in TeX files (local leader `,`):

| Key | Action |
|-----|--------|
| `,l` | Save + compile (continuous) |
| `,c` | Save + compile (once) |
| `,v` | Forward search in zathura |

Build output goes to `build/` with SyncTeX enabled. After viewing PDF, focus returns to Vim via xdotool (see `vim/after/ftplugin/tex/vimtex.vim`).

### Vim directory layout

| Path | Purpose |
|------|---------|
| `vim/plugin/` | Global plugin settings |
| `vim/after/ftplugin/` | Filetype overrides (TeX keymaps) |
| `vim/after/plugin/` | Plugin overrides |
| `vim/UltiSnips/` | Snippet definitions |
| `vim/autoload/plug.vim` | vim-plug (bundled) |

Cloned plugins live in `~/.vim/plugged/` (gitignored).

## Manual setup after install

Not covered by `install.sh`:

| Item | Notes |
|------|-------|
| Wallpaper | i3 expects `~/Daniel/Personal/black.jpeg` (see `config/i3/config`) |
| GitHub auth | `gh auth login` — populates `~/.config/gh/hosts.yml` locally |
| TeX Live full | Apt installs a subset; optional `/usr/local/texlive/` for full install |
| GPU drivers | NVIDIA / proprietary drivers |
| Personal paths | Aliases reference `~/Daniel/...`; adjust on new hardware if needed |
| i3 session | Log out/in after first install |

## License

MIT — see repository license file if present.
