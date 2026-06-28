#!/bin/bash
#########################
# .make.sh
# Creates symlinks from the home dir to dotfiles in ~/dotfiles
#########################

dir=~/dotfiles
olddir=~/dotfiles_old

# Archivos que van en la raíz del usuario (~/.archivo)
home_files="bashrc bash_profile bash_aliases vimrc vim xprofile gitconfig editorconfig vimrc_minimal"

# Directorios que van en ~/.config/ (~/.config/directorio)
# Añade aquí picom, alacritty, rofi, etc., según los vayas agregando a dotfiles/config/
config_files="i3 picom"

echo "Creando $olddir para backups..."
mkdir -p "$olddir"
mkdir -p ~/.config

cd "$dir" || exit

echo "Procesando archivos del HOME..."
for file in $home_files; do
    if [ -e ~/.$file ]; then
        mv ~/.$file "$olddir"/
    fi
    ln -sf "$dir/$file" ~/.$file
done

echo "Procesando archivos de ~/.config..."
for folder in $config_files; do
    if [ -e ~/.config/$folder ]; then
        mv ~/.config/$folder "$olddir"/
    fi
    ln -sf "$dir/config/$folder" ~/.config/$folder
done

echo "Proceso completado."
