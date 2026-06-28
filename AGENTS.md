# Contexto de Migración de Dotfiles (AGENTS.md)

## Objetivo
Migrar un entorno de trabajo personalizado (i3wm en Ubuntu) a nuevo hardware. La estrategia consiste en abandonar las instantáneas del sistema a nivel de sistema operativo (Timeshift) en favor de un control de versiones centralizado mediante Git, aplicando el estándar XDG Base Directory (`~/.config`).

## Estado Actual del Repositorio
- **Ruta local**: `~/dotfiles`
- **`make.sh`**: Enlaza archivos de `~/` y directorios XDG en `~/.config/` desde `config/`, con backup en `~/dotfiles_old/`.
- **`install.sh`**: Bootstrap en máquina nueva — `apt` por capas + `make.sh` + `vim +PlugInstall` (primera vez).
- **Estructura XDG versionada**: `config/i3/`, `config/picom/`, `config/gtk-3.0/`, `config/gh/config.yml`.
- **Dependencias apt**: `packages-base.txt`, `packages-desktop.txt`, `packages-dev.txt`.

### Bootstrap (máquina nueva)
```bash
git clone <repo> ~/dotfiles && cd ~/dotfiles
./install.sh              # base + desktop + dev + symlinks + vim-plug
./install.sh --list       # dry-run: muestra paquetes por capa
./install.sh --desktop-only
./install.sh --skip-apt   # solo symlinks y vim-plug (sin apt)
```

**Fuera de apt** (manual): wallpaper `~/Daniel/Personal/black.jpeg`, TeX Live en `/usr/local/texlive/` si aplica, drivers GPU, AppImages.

## Plan de migración — progreso

| Fase | Todo | Estado |
|------|------|--------|
| Deuda XDG | `fix-xdg-debt` — rutas i3/picom, i3blocks | Hecho |
| Dependencias | `create-packages-layers` — `packages-*.txt` | Hecho |
| Bootstrap | `create-install-sh` — `install.sh` modular | Hecho |
| Auditoría | `audit-i3-stack` — rofi, dunst, feh, neofetch, gtk-3.0, gh | Hecho |
| Purgas | `purge-nvim-coc` — eliminar nvim/coc; validar Vim+LaTeX | Pendiente |
| Apps opcionales | `audit-optional-apps` — spotify, transmission, etc. | Pendiente |
| Documentación | `update-docs` — README, checklist migración | Pendiente |

## Triaje de `~/.config` — Registro de decisiones

| Entrada | Decisión | Estado | Notas |
|---------|----------|--------|-------|
| `i3` | Consolidar | Hecho | `~/.config/i3` → `config/i3/`; eliminado `~/.i3` obsoleto |
| `picom` | Consolidar | Hecho | `~/.config/picom` → `config/picom/` |
| `i3blocks` | Consolidar parcial | Hecho | Solo `config/i3/i3blocks.conf`; scripts vía paquete apt (`/usr/share/i3blocks/`) |
| `gtk-3.0` | Consolidar | Hecho | Solo `settings.ini` (tema oscuro); `bookmarks` es local/regenerable |
| `gh` | Consolidar parcial | Hecho | Solo `config.yml` enlazado; `hosts.yml` local (auth, en `.gitignore`) |
| `neofetch` | Defaults apt | Hecho | Sin `~/.config/neofetch` personalizado relevante; paquete en `packages-desktop.txt` |
| `rofi` | Defaults apt | Hecho | Sin config XDG; launcher vía flags en `config/i3/config` (`$mod+d`) |
| `dunst` | Defaults apt | Hecho | Sin config XDG; usa `/etc/xdg/dunst/dunstrc`; arranque vía `dunst.service` (systemd user) |
| `feh` | Defaults apt | Hecho | Sin config XDG; wallpaper en `exec_always` de `config/i3/config` |
| `nvim`, `coc` | Purgar | Pendiente | Decisión: Vim únicamente |
| Apps opcionales | Revisar | Pendiente | spotify, transmission, godot, wireshark, VirtualBox |
| Perfiles runtime | Ignorar | — | Chrome, Cursor, Code, JetBrains, LibreOffice, pulse |

## Auditoría stack i3 implícito (resumen)

| Herramienta | Config XDG | En dotfiles | Referencia |
|-------------|------------|-------------|------------|
| rofi | No | — (defaults) | `config/i3/config` línea 65 |
| dunst | No | — (defaults) | systemd `dunst.service` |
| feh | No | — (defaults) | `config/i3/config` línea 275 |
| neofetch | Stock (`package_managers=on`) | No versionar | paquete apt; sin uso en i3 |
| gtk-3.0 | `settings.ini` | `config/gtk-3.0/` | prefer-dark-theme |
| gh | `config.yml` | `config/gh/config.yml` | `gitconfig` + `packages-dev.txt` |

## Deuda técnica resuelta
- Eliminado symlink roto `~/.i3` → `~/dotfiles/i3`
- `i3blocks.conf` apunta a `~/.config/i3/i3blocks.conf` (no `~/.i3/`)
- Scripts i3blocks usan `/usr/share/i3blocks/$BLOCK_NAME` (paquete apt), no clon en `~/.config/i3blocks/`

## Próximo Paso Inmediato
`purge-nvim-coc`: eliminar `~/.config/nvim` y `~/.config/coc` del sistema; confirmar que el flujo LaTeX con Vim (`vimtex`, `latexmk`, `zathura`) cubre las necesidades.
