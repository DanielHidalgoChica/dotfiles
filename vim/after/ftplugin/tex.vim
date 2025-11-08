"Configuraciones para el visualizador de pdf con latex
if empty(v:servername) && exists('*remote_startserver')
    call remote_startserver('VIM')
endif

" Como este .vim/after está en la rtp, carga solo los que debe
" esto al parecer no se necesita porque llamando al directorio hermano tex las cosas parecen funcionar
runtime! ftplugin/tex/*.vim
