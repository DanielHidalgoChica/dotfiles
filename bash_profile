source .bashrc

# Created by `pipx` on 2025-05-14 17:35:32
PATH="$PATH:/home/daniel/.local/bin"
PATH=/usr/local/texlive/2025/bin/x86_64-linux:$PATH

# Show current branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\h \[\033[32m\]\w - \$(parse_git_branch)\[\033[00m\] $ "
