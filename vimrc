set encoding=utf-8
runtime defaults.vim

colo habamax
set aw nu rnu "nowrap "Autowrite number relativenumber nowrap
set noet sr ts=8 sts=0 sw=0

inoremap jk <ESC>

set pt=<C-K>
nnoremap <F7> :make CXXFLAGS="-std=c++11 -Wall -Wextra" %:r<CR>

"---------------------------- PERSONALES
"Para navegar mejor las softwrapped
noremap j gj
noremap k gk

set autoindent

"Búsqueda en archivos basada en learn vim github
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" EL ROLLO: Todos los archivos sin extensión (texto normal) tabs de 8
" y softtabstop de 4. De entrada, los archivos CON extensión, softtabstop y
" shiftwidth de 8. Luego para cosas concretas, metemos editorconfig.
augroup NoExtSTS
	autocmd!
	autocmd BufRead,BufNewFile * if empty(expand('%:e')) | setlocal softtabstop=4 | endif
augroup END

packadd! editorconfig

"Poner como leaderkey la coma
let mapleader = ","


"Map key to delete every swap file (puede haber
"swap files con otras extensiones, pero espero no acumular tantos)
"RECUERDA que para usar este comando tienes que haber entrado al archivo
"desde el directorio en el que se encuentra (porque el filename % no va bien
"con -name en otro caso, creo)
nnoremap <leader>sw :!find . -type f -maxdepth 1 -name '.%.sw[ponmlkjihgfedcba]'  -delete

call plug#begin()
Plug 'SirVer/ultisnips' "Snippets
Plug 'lervag/vimtex' " Pal latexx
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'KeitaNakamura/tex-conceal.vim'
call plug#end()

"Config de netrw
let g:netrw_liststyle= 3 " Que el estilo del árbol sea natural, creo
let g:netrw_banner = 0 " Que no aparezca la ayuda

"Para que funcionen los aliases
let $BASH_ENV = "~/.bash_aliases"



