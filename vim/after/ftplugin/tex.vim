let maplocalleader = ','

"keys para compilación
noremap <localleader>l <Cmd>update<CR><Cmd>VimtexCompileSS<CR>
noremap <localleader>c <Cmd>update<CR><Cmd>VimtexCompile<CR>

"Forward search
nmap <localleader>v <plug>(vimtex-view)

"Configuración apañá del conceal
setlocal conceallevel=1
hi! Conceal guifg=#A0A0A0 guibg=#111111 ctermfg=grey ctermbg=black


