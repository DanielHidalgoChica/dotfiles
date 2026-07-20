# ~/.bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return ;;
esac

# History
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Update window size after each command
shopt -s checkwinsize

# Enable ** globbing
shopt -s globstar

# less
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colors for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias alert='notify-send --urgency=low \
-i "$([ $? = 0 ] && echo terminal || echo error)" \
"$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Personal aliases
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Bash completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Git prompt
if [ -f /usr/lib/git-core/git-sh-prompt ]; then
    . /usr/lib/git-core/git-sh-prompt
elif [ -f /usr/share/git/completion/git-prompt.sh ]; then
    . /usr/share/git/completion/git-prompt.sh
fi

# Prompt colors
BLUE="\[\033[1;34m\]"
YELLOW="\[\033[33m\]"
RESET="\[\033[0m\]"

# Minimal prompt:
# ~/ruta (rama)
# $
PS1="${BLUE}\w${YELLOW}\$(__git_ps1 ' (%s)')${RESET}\$ "

# Terminal title (optional)
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;\w\a\]$PS1"
        ;;
esac

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# pipx
export PATH="$PATH:$HOME/.local/bin"

# fzf + ripgrep
if command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --files'
    export FZF_DEFAULT_OPTS='-m'
fi
