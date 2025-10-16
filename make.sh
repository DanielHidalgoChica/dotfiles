#!/bin/bash
#########################
# .make.sh
# Tis script creates symlinks from the home dir to any
# desired dotfiles in ~/dotfiles
#########################


# Varibales


dir=~/dotfiles          # dotfiles dir
olddir=~/dotfiles_old   # odl dotfiles backup

# List of files to symlink in home
files="bashrc bash_profile bash_aliases vimrc vim xprofile i3 gitconfig editorconfig latexmkrc"


# create dotfiles_old in homedir

echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles dir
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory
# then create symlinks

for file in $files; do
	echo "Moving any existing dotfiles from ~ to $olddir"
	mv ~/.$file $olddir
	echo "Creating symlink to $file in home directory."
	ln -s $dir/$file ~/.$file
done


# Specific one for i3 config
#i3config_folder=~/.config/i3
#i3config_file=config
#
#ln -s $dir/$i3config_file $i3config_folder
