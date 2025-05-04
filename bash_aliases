shopt -s expand_aliases

alias uni='cd /home/daniel/Daniel/University/DGIIM/III/segundo_cuatrimestre'
alias ise='cd /home/daniel/Daniel/University/DGIIM/III/segundo_cuatrimestre/ISE'
alias var='cd /home/daniel/Daniel/University/DGIIM/III/segundo_cuatrimestre/VAR_COMP/PresentacionesImprimir'
alias ia='cd /home/daniel/Daniel/University/DGIIM/III/segundo_cuatrimestre/IA/practicas/p2'

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


# Comodidad SO
alias lsblk="lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINTS,FSTYPE,LABEL"
