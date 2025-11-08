# dotfiles
Config files for VIM, i3wm, bash, X11, etc.

Following guide in https://blog.smalleycreative.com/using-git-and-github-to-manage-your-dotfiles/

About where each thing is modified when messing with pluggins in vim:

    - Global variables from plugins or other global configurations for these to work  at .vim/plugin
    - Own generic or filetype specific plugins at .vim/plugin or .vim/ftplugin respectively
    - Modifications that are not global, such as keybindings, at .vim/after/plugin or .vim/after/ftplugin
