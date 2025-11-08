set encoding=utf-8
set number "Que salgan los números en las líneas
set rnu "Relative numbering
set nocompatible "Evita la compatibilidad con Vi y te quita de problemas

set hidden "Para cambiar de buffer sin guardar
set hlsearch "Para que highlightee los resultados de las búsquedas
set mouse=a "Poder gestionar tamaños de ventanas con ratón

"Mostrar el comando que se está insertando abajo a la izquierda
"en la pantalla
set showcmd
"Mostrar la statusline con el flename
set laststatus=2

"Mapeo de jk a la tecla Esc en modo insertar
inoremap jk <ESC>

"Para copiar directamente al final de la línea
noremap Y y$

"Para navegar mejor las softwrapped
noremap j gj
noremap k gk

"Case insensitive al menos que haya alguna con mayúsucla
set ignorecase
set smartcase

"Permitir sintaxis
syntax on

"El autoindent me gusta la verdad
set autoindent

"Colores, esquema en .vim/colors
set termguicolors

colorscheme true-monochrome
"Uso medio estándar del grep con ripgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" Tamaño en espacios del caracter de tab (opciones
" recomendadas en vim para tabstop, y
" softabstop=shiftwidth=num_espacios_por_tab)
set tabstop=8
set softtabstop=0
set shiftwidth=0
set noexpandtab
"

"Para que los archivos sin extensión tengan softtabstop 4
" EL ROLLO: Todos los archivos sin extensión (texto normal) tabs de 8
" y softtabstop de 4. De entrada, los archivos CON extensión, softtabstop y
" shiftwidth de 8. Luego para cosas concretas, metemos editorconfig.
augroup NoExtSTS
	autocmd!
	autocmd BufRead,BufNewFile * if empty(expand('%:e')) | setlocal softtabstop=4 | endif
augroup END


filetype on
filetype indent on "Para que reconozca el tipo
		   "de archivo y ajuste en función
		   "de eso
filetype plugin on

"Editorconfig para config de estilo especifica de proyectos
packadd! editorconfig

"Poner como leaderkey la coma
let mapleader = ","

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
map <leader>a :call TogglePaste()<cr>
"Fin paste toggle


"Map key to delete every swap file (puede haber
"swap files con otras extensiones, pero espero no acumular tantos)
"RECUERDA que para usar este comando tienes que haber entrado al archivo
"desde el directorio en el que se encuentra (porque el filename % no va bien
"con -name en otro caso, creo)
map <leader>sw :!find . -type f -maxdepth 1 -name '.%.sw[ponmlkjihgfedcba]'  -delete

"Configuraciones para el visualizador de pdf con latex
if empty(v:servername) && exists('*remote_startserver')
    call remote_startserver('VIM')
endif


call plug#begin()
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-peekaboo' "Lo de las macros
Plug 'SirVer/ultisnips' "Snippets
Plug 'lervag/vimtex' " Pal latexx
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'KeitaNakamura/tex-conceal.vim'
call plug#end()



"Ctrl-f para tirar de fuzzysearch
" y leader f para tirar de búsqueda en archivo
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>

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
    let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

nnoremap <silent> <leader>u :w<bar>call UltiSnips#RefreshSnippets()<CR>


