#!/bin/bash
#########################
# make.sh
# Creates symlinks from the home dir to dotfiles in ~/dotfiles
# Idempotent: safe to re-run; backs up only local copies that differ from dotfiles.
#########################

set -euo pipefail

dir=~/dotfiles
olddir=~/dotfiles_old

home_files="bashrc bash_profile bash_aliases vimrc vim xprofile gitconfig editorconfig vimrc_minimal"
config_files="i3 picom gtk-3.0 nvim"
config_single_files="gh/config.yml restic/exclude.txt"

resolve_path() {
    readlink -f "$1" 2>/dev/null || realpath "$1" 2>/dev/null || echo "$1"
}

is_linked_to() {
    local link=$1 target=$2
    [ -L "$link" ] && [ "$(resolve_path "$link")" = "$(resolve_path "$target")" ]
}

backup_entry() {
    local src=$1
    local rel=$2
    local dest="$olddir/$rel"
    local parent

    parent=$(dirname "$dest")
    mkdir -p "$parent"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        dest="${dest}.bak.$(date +%Y%m%d-%H%M%S)"
    fi

    mv "$src" "$dest"
    echo "  backup: $src -> $dest"
}

ensure_symlink() {
    local target=$1
    local link=$2

    if is_linked_to "$link" "$target"; then
        echo "  ok: $link"
        return
    fi

    if [ -e "$link" ] || [ -L "$link" ]; then
        backup_entry "$link" "$(basename "$link")"
    fi

    ln -sf "$target" "$link"
    echo "  link: $link -> $target"
}

ensure_home_symlink() {
    local file=$1
    local target="$dir/$file"
    local link=~/.${file}

    if is_linked_to "$link" "$target"; then
        echo "  ok: $link"
        return
    fi

    if [ -e "$link" ] || [ -L "$link" ]; then
        backup_entry "$link" "$file"
    fi

    ln -sf "$target" "$link"
    echo "  link: $link -> $target"
}

ensure_config_dir_symlink() {
    local folder=$1
    local target="$dir/config/$folder"
    local link=~/.config/$folder

    if is_linked_to "$link" "$target"; then
        echo "  ok: $link"
        return
    fi

    if [ -e "$link" ] || [ -L "$link" ]; then
        backup_entry "$link" "$folder"
    fi

    ln -sf "$target" "$link"
    echo "  link: $link -> $target"
}

ensure_config_file_symlink() {
    local rel=$1
    local target="$dir/config/$rel"
    local link=~/.config/$rel
    local parent

    parent=$(dirname "$link")
    mkdir -p "$parent"

    if is_linked_to "$link" "$target"; then
        echo "  ok: $link"
        return
    fi

    if [ -e "$link" ] && [ ! -L "$link" ]; then
        backup_entry "$link" "$rel"
    elif [ -L "$link" ]; then
        backup_entry "$link" "$rel"
    fi

    ln -sf "$target" "$link"
    echo "  link: $link -> $target"
}

echo "Creando $olddir para backups..."
mkdir -p "$olddir" ~/.config

cd "$dir" || exit 1

echo "Procesando archivos del HOME..."
for file in $home_files; do
    ensure_home_symlink "$file"
done

echo "Procesando directorios de ~/.config..."
for folder in $config_files; do
    ensure_config_dir_symlink "$folder"
done

echo "Procesando archivos sueltos de ~/.config..."
for rel in $config_single_files; do
    ensure_config_file_symlink "$rel"
done

echo "Proceso completado."
