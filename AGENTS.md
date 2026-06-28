# Contexto de Migración de Dotfiles (AGENTS.md)

## Objetivo
Migrar un entorno de trabajo personalizado (i3wm en Ubuntu) a nuevo hardware. La estrategia consiste en abandonar las instantáneas del sistema a nivel de sistema operativo (Timeshift) en favor de un control de versiones centralizado mediante Git, aplicando el estándar XDG Base Directory (`~/.config`).

## Estado Actual del Repositorio
- **Ruta local**: `~/dotfiles`
- **Archivos rastreados**: Configuraciones de Bash (`bashrc`, `bash_profile`, `bash_aliases`), entorno de Vim extenso y estructurado (enfocado en LaTeX mediante `vimtex`, `ultisnips` y `fzf`), `.xprofile` y configuración base de `i3`.
- **Script de gestión (`make.sh`)**: Ha sido modificado para diferenciar y procesar archivos de la raíz del usuario (`~/`) y directorios XDG (`~/.config/`), con creación de backups automáticos.
- **Déficit técnico actual**: El repositorio carece de estructura XDG, no contiene configuraciones de periféricos esenciales (emulador de terminal, compositor `picom`, lanzador `rofi`, demonio de notificaciones) y falta un registro de las dependencias de software.

## Plan de Acción
1. **Auditoría de entorno (`~/.config`)**: Revisar secuencialmente la estructura de configuración local.
2. **Evaluación de componentes**:
   - Detectar paquetes obsoletos (deprecated) o sin uso real.
      - Identificar solapamientos técnicos (múltiples herramientas resolviendo el mismo problema).
      3. **Triaje y estructuración**: Para cada componente auditado, tomar una decisión binaria: purgar del sistema o consolidar en `~/dotfiles/config/` (añadiéndolo simultáneamente al script `make.sh` y al futuro archivo `packages.txt`).
      4. **Cierre**: Consolidar la lista definitiva de dependencias de software del entorno.

      ## Próximo Paso Inmediato
      Procesar la salida del comando `ls -1 ~/.config` proporcionada por el usuario para comenzar la auditoría individualizada de directorios y paquetes.
