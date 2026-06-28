# Contexto de Migración de Dotfiles (AGENTS.md)

## Objetivo
Migrar un entorno de trabajo personalizado (i3wm en Ubuntu) a nuevo hardware. La estrategia consiste en abandonar las instantáneas del sistema a nivel de sistema operativo (Timeshift) en favor de un control de versiones centralizado mediante Git, aplicando el estándar XDG Base Directory (`~/.config`).

## Estado Actual del Repositorio
- **Ruta local**: `~/dotfiles`
- **Script de gestión (`make.sh`)**: Enlaza archivos de `~/` y directorios XDG en `~/.config/` desde `config/`, con backup en `~/dotfiles_old/`.
- **Estructura XDG**: `config/i3/`, `config/picom/` versionados y enlazados.
- **Dependencias**: `packages-desktop.txt` (stack i3wm; pendiente `packages-base.txt`, `packages-dev.txt`, `install.sh`).

## Triaje de `~/.config` — Registro de decisiones

| Entrada | Decisión | Estado | Notas |
|---------|----------|--------|-------|
| `i3` | Consolidar | Hecho | `~/.config/i3` → `config/i3/`; eliminado `~/.i3` obsoleto |
| `picom` | Consolidar | Hecho | `~/.config/picom` → `config/picom/` |
| `i3blocks` | Consolidar parcial | Hecho | Solo `config/i3/i3blocks.conf`; scripts vía paquete apt (`/usr/share/i3blocks/`); clon upstream eliminado |
| `neofetch` | Consolidar | Pendiente | |
| `gtk-3.0` | Consolidar | Pendiente | |
| `gh` | Consolidar | Pendiente | |
| `nvim`, `coc` | Purgar | Pendiente | Decisión: Vim únicamente |
| Apps opcionales | Revisar | Pendiente | spotify, transmission, godot, wireshark, VirtualBox |
| Perfiles runtime | Ignorar | — | Chrome, Cursor, Code, JetBrains, LibreOffice, pulse |

## Deuda técnica resuelta
- Eliminado symlink roto `~/.i3` → `~/dotfiles/i3`
- `i3blocks.conf` apunta a `~/.config/i3/i3blocks.conf` (no `~/.i3/`)
- Scripts i3blocks usan `/usr/share/i3blocks/$BLOCK_NAME` (paquete apt), no clon en `~/.config/i3blocks/`

## Próximo Paso Inmediato
Auditar stack i3 implícito sin config XDG propia: `rofi`, `dunst`, `feh`, y consolidar `neofetch`, `gtk-3.0`, `gh`.
