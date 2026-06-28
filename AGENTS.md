# Contexto de Migración de Dotfiles (AGENTS.md)

Documento de referencia para agentes y para retomar el trabajo de migración. El README es la guía de usuario; este archivo registra decisiones, estado y pendientes.

## Objetivo

Migrar un entorno de trabajo personalizado (i3wm en Ubuntu) a nuevo hardware. Estrategia: abandonar instantáneas a nivel de SO (Timeshift) en favor de Git + estándar XDG Base Directory (`~/.config`).

## Estado actual del repositorio

| Área | Estado |
|------|--------|
| Symlinks | `make.sh` idempotente; backups en `~/dotfiles_old/` |
| Bootstrap | `install.sh` — apt por capas + `make.sh` + vim-plug |
| Editor | **Vim únicamente** (nvim/coc purgados) |
| WM / desktop | `config/i3/`, `config/picom/` |
| XDG versionado | `config/gtk-3.0/`, `config/gh/config.yml` |
| Dependencias apt | `packages-base.txt`, `packages-desktop.txt`, `packages-dev.txt` |

### Estructura del repo

```
~/dotfiles/
├── install.sh              # bootstrap máquina nueva
├── make.sh                 # symlinks HOME + ~/.config
├── packages-base.txt       # git, curl, build-essential
├── packages-desktop.txt    # stack i3wm
├── packages-dev.txt        # vim, LaTeX, gh, ripgrep, fzf
├── scripts/
│   └── purge-nvim-coc.sh   # utilidad puntual (ya ejecutada)
├── config/                 # → ~/.config/* (XDG)
│   ├── i3/
│   ├── picom/
│   ├── gtk-3.0/
│   └── gh/config.yml       # hosts.yml NO versionado (local)
├── vim/, vimrc             # → ~/.vim, ~/.vimrc
├── bashrc, bash_aliases, bash_profile, xprofile
├── gitconfig, editorconfig, vimrc_minimal
└── AGENTS.md, README.md
```

Convención: todo lo que vive en `~/.config/foo` va en `dotfiles/config/foo`, salvo archivos con secretos (p. ej. `gh/hosts.yml`), que se enlazan como archivo suelto.

### Bootstrap (máquina nueva)

```bash
git clone <repo> ~/dotfiles && cd ~/dotfiles
./install.sh              # base + desktop + dev + symlinks + vim-plug
./install.sh --list       # dry-run
./install.sh --desktop-only
./install.sh --skip-apt   # solo symlinks y vim-plug
```

**Fuera de apt** (manual): wallpaper `~/Daniel/Personal/black.jpeg`, TeX Live en `/usr/local/texlive/` si aplica, drivers GPU, AppImages, `gh auth login`.

## Plan de migración — progreso

| Fase | Todo | Estado |
|------|------|--------|
| Deuda XDG | `fix-xdg-debt` | Hecho |
| Dependencias | `create-packages-layers` | Hecho |
| Bootstrap | `create-install-sh` | Hecho |
| Auditoría i3 | `audit-i3-stack` | Hecho |
| Purgas | `purge-nvim-coc` | Hecho |
| Documentación | `update-docs` | Hecho |
| Apps opcionales | `audit-optional-apps` | **Pendiente** |

## Tareas pendientes

### 1. `audit-optional-apps` (requiere decisión del usuario)

Revisar uso y decidir consolidar / ignorar / purgar para cada entrada en `~/.config`:

| App | Archivos aprox. | Notas |
|-----|-----------------|-------|
| spotify | ~8 | ¿uso habitual? |
| transmission | config extensa | cliente torrent |
| godot | — | motor de juegos |
| wireshark | ~5 | perfil de captura |
| VirtualBox | — | VMs; config migra mal |

### 2. Post-migración en hardware nuevo (checklist operativo)

- [ ] `./install.sh` o capas según necesidad
- [ ] Reiniciar sesión i3
- [ ] `gh auth login`
- [ ] Wallpaper y rutas `~/Daniel/...`
- [ ] Drivers GPU / fuentes si aplica
- [ ] Validar audio (pulse), WiFi (NetworkManager), LaTeX (`vim` + `.tex` de prueba)

## Triaje de `~/.config` — registro de decisiones

| Entrada | Decisión | Estado | Notas |
|---------|----------|--------|-------|
| `i3` | Consolidar | Hecho | `config/i3/`; eliminado `~/.i3` obsoleto |
| `picom` | Consolidar | Hecho | `config/picom/` |
| `i3blocks` | Consolidar parcial | Hecho | Solo `i3blocks.conf`; scripts vía apt (`/usr/share/i3blocks/`) |
| `gtk-3.0` | Consolidar | Hecho | Solo `settings.ini`; `bookmarks` local |
| `gh` | Consolidar parcial | Hecho | Solo `config.yml`; `hosts.yml` en `.gitignore` |
| `neofetch` | Defaults apt | Hecho | Sin config personalizada relevante |
| `rofi`, `dunst`, `feh` | Defaults apt | Hecho | Sin config XDG; registrados en `packages-desktop.txt` |
| `nvim`, `coc` | Purgar | Hecho | Backup en `~/dotfiles_old/nvim-coc-purge-*` |
| Apps opcionales | Revisar | Pendiente | spotify, transmission, godot, wireshark, VirtualBox |
| Perfiles runtime | Ignorar | — | Chrome, Cursor, Code, JetBrains, LibreOffice, pulse |

## Flujo LaTeX (Vim)

| Capacidad | Implementación | apt |
|-----------|----------------|-----|
| Compilación | vimtex + latexmk (`build/`, `-shell-escape`) | texlive-*, latexmk |
| PDF + SyncTeX | zathura | zathura |
| Snippets | UltiSnips en `vim/UltiSnips/` | vim-plug |
| Conceal | tex-conceal.vim | vim-plug |
| Atajos | `,l` SS, `,c` compilar, `,v` view | — |
| Refocus | xdotool tras forward search | xdotool |

## Deuda técnica resuelta

- Symlink roto `~/.i3` eliminado
- `i3blocks.conf` en ruta XDG correcta
- i3blocks scripts desde paquete apt, no clon upstream
- `make.sh` idempotente (sin symlinks recursivos en re-ejecuciones)
- nvim/coc eliminados; PATH de `/opt/nvim-linux64` quitado de `bashrc`

## Próximo paso inmediato

`audit-optional-apps`: sesión de triaje con el usuario para spotify, transmission, godot, wireshark y VirtualBox.
