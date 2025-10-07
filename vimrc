set encoding=utf-8
set number "Que salgan los números en las líneas
set rnu "Relative numbering
set nocompatible "Evita la compatibilidad con Vi y te quita de problemas

set hidden "Para cambiar de buffer sin guardar
set hlsearch "Para que highlightee los resultados de las búsquedas
set mouse=a "Poder gestionar tamaños de ventanas con ratón

"Siempre busca con very-magic
nnoremap / /\v
"Mostrar el comando que se está insertando abajo a la izquierda
"en la pantalla
set showcmd
"Mostrar la statusline con el flename
set laststatus=2

"Mapeo de jk a la tecla Esc en modo insertar
inoremap jk <ESC>


"Case insensitive al menos que haya alguna con mayúsucla
set ignorecase
set smartcase

"Permitir sintaxis
syntax on

"El autoindent me gusta la verdad
set autoindent

"Uso medio estándar del grep con ripgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" Tamaño en espacios del caracter de tab (opciones
" recomendadas en vim para tabstop, y
" softabstop=shiftwidth=num_espacios_por_tab)
set tabstop=8
set softtabstop=4
set shiftwidth=4
set noexpandtab

"Si uso yaml, meter 2 espacios por los tabs
autocmd FileType yml,yaml setlocal tabstop=8 shiftwidth=2 softtabstop=2 expandtab


filetype on
filetype indent on "Para que reconozca el tipo
		   "de archivo y ajuste en función
		   "de eso
filetype plugin on

"Editorconfig para config de estilo especifica de proyectos
packadd! editorconfig

"Pal paste toggle
function! TogglePaste()
    if(&paste == 0)
        set paste
        echo "Paste Mode Enabled"
    else
        set nopaste
        echo "Paste Mode Disabled"
    endif
endfunction

"Poner como leaderkey la coma
let mapleader = ","
map <leader>p :call TogglePaste()<cr>
"Fin paste toggle

"Map key to delete every swap file (puede haber
"swap files con otras extensiones, pero espero no acumular tantos)
"RECUERDA que para usar este comando tienes que haber entrado al archivo
"desde el directorio en el que se encuentra (porque el filename % no va bien
"con -name en otro caso, creo)
map <leader>sw :!find . -type f -maxdepth 1 -name '.%.sw[ponmlkjihgfedcba]'  -delete

call plug#begin()
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-peekaboo' "Lo de las macros
call plug#end()

"Colores, esquema en .vim/colors
set termguicolors
colorscheme true-monochrome



" Use <C-K> to clear the highlighting of :set hlsearch.
if maparg('<C-K>', 'n') ==# ''
  nnoremap <silent> <C-K> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-K>
endif

"Config de netrw
let g:netrw_liststyle= 3 " Que el estilo del árbol sea natural, creo
let g:netrw_banner = 0 " Que no aparezca la ayuda

"Para que funcionen los aliases
let $BASH_ENV = "~/.bash_aliases"

"Configuración para Latex basada en Castell
Plug 'sirver/ultisnips'
    let g:UltiSnipsExpandTrigger = '<tab>'
    let g:UltiSnipsJumpForwardTrigger = '<tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

Plug 'lervag/vimtex'
    let g:tex_flavor='latex'
    let g:vimtex_view_method='zathura'
    let g:vimtex_quickfix_mode=0

Plug 'KeitaNakamura/tex-conceal.vim'
    set conceallevel=1
    let g:tex_conceal='abdmg'
    hi Conceal ctermbg=none

"setlocal spell
"set spelllang=es,en_us
"inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
