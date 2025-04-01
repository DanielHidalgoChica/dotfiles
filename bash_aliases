shopt -s expand_aliases

alias uni='cd /home/daniel/Daniel/University/DGIIM/III/segundo_cuatrimestre'

# Vainas swapping keys
alias sc='setxkbmap -option ctrl:swapcaps'
alias salt='setxkbmap -option altwin:swap_lalt_lwin'
alias uswap='setxkbmap -option'
alias usc='setxkbmap -option && setxkbmap -option altwin:swap_lalt_lwin'
alias dani='cd ~/Daniel/Personal'
alias sl='ls'
alias lls='ls'

# Vainas tortura pulseaudio
alias restartpulse='pulseaudio --k &&
		    pulseaudio  --start &&
		    start-pulseaudio-x11 &&
		    pactl info'
