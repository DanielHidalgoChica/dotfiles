shopt -s expand_aliases

alias uni='cd /home/daniel/Daniel/Universidad/DGIIM/IV/segundo_cuatrimestre'

# Vainas swapping keys
alias sc='setxkbmap -option ctrl:swapcaps'
alias salt='setxkbmap -option altwin:swap_lalt_lwin'
alias uswap='setxkbmap -option'
alias usc='setxkbmap -option && setxkbmap -option altwin:swap_lalt_lwin'
alias dani='cd ~/Daniel/Personal'
alias sl='ls'
alias lls='ls'



# Comodidad SO

# -e 7 para no mostrar loop
alias lsblk="lsblk -e 7 -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINTS,FSTYPE,LABEL,PARTTYPENAME"

alias restartpulse="systemctl --user stop pulseaudio.socket pulseaudio.service; \
killall -9 pulseaudio 2>/dev/null; \
rm -rf ~/.config/pulse/* /run/user/$(id -u)/pulse; \
systemctl --user start pulseaudio.service"

# Miscellaneous
alias python="python3"

