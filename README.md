# Dotfiles

Personal configuration files for my development environment.

![Shell](https://img.shields.io/badge/Shell-Bash-green)
![Editor](https://img.shields.io/badge/Editor-Vim-brightgreen)
![WM](https://img.shields.io/badge/WM-i3-blue)

## Contents

- [Overview](#overview)
- [What's Included](#whats-included)
- [Installation](#installation)
- [Vim Configuration](#vim-configuration)
- [License](#license)

## Overview

This repository contains my personal dotfiles for a Linux development environment. The setup script automatically creates symlinks from your home directory to the configuration files, with automatic backup of any existing configs.

## What's Included

| Component | Description |
|-----------|-------------|
| **Vim** | Full configuration with plugin management via [vim-plug](https://github.com/junegunn/vim-plug), UltiSnips snippets, and vimtex for LaTeX |
| **i3wm** | Tiling window manager config with i3blocks status bar |
| **Bash** | Shell aliases, profile, and rc customizations |
| **Git** | Global gitconfig |
| **EditorConfig** | Consistent coding styles across editors |
| **X11** | xprofile for X session startup |

### Notable Features

- **LaTeX Workflow**: Extensive UltiSnips snippets for LaTeX (`vim/UltiSnips/`), vimtex integration, and tex-conceal for prettier editing
- **Fuzzy Finding**: FZF integration for fast file and buffer navigation
- **Auto Pairs**: Automatic bracket/quote pairing

## Installation

```sh
git clone https://github.com/DanielHidalgoChica/dotfiles.git ~/dotfiles
cd ~/dotfiles
./make.sh
```

The script will:
1. Create a backup directory (`~/dotfiles_old`) for existing dotfiles
2. Move any existing dotfiles to the backup directory
3. Create symlinks from `~/.config_name` → `~/dotfiles/config_name`

**Files symlinked:** `bashrc`, `bash_profile`, `bash_aliases`, `vimrc`, `vim`, `xprofile`, `i3`, `gitconfig`, `editorconfig`, `vimrc_minimal`

## Vim Configuration

### Directory Structure

| Path | Purpose |
|------|---------|
| `.vim/plugin/` | Global plugin variables and configurations |
| `.vim/ftplugin/` | Filetype-specific plugin settings |
| `.vim/after/plugin/` | Non-global modifications (keybindings, overrides) |
| `.vim/after/ftplugin/` | Filetype-specific overrides |
| `.vim/UltiSnips/` | Custom snippet definitions |

### Plugins

Managed via [vim-plug](https://github.com/junegunn/vim-plug):

- **[vimtex](https://github.com/lervag/vimtex)** - LaTeX editing and compilation
- **[UltiSnips](https://github.com/SirVer/ultisnips)** - Snippet engine
- **[fzf.vim](https://github.com/junegunn/fzf.vim)** - Fuzzy finder integration
- **[auto-pairs](https://github.com/jiangmiao/auto-pairs)** - Auto-close brackets/quotes
- **[vim-peekaboo](https://github.com/junegunn/vim-peekaboo)** - Register preview
- **[tex-conceal.vim](https://github.com/KeitaNakamura/tex-conceal.vim)** - Pretty LaTeX symbols

## License

MIT License - feel free to use and modify as you see fit.
