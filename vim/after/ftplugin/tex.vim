let maplocalleader = ','

"keys para compilación
noremap <localleader>l <Cmd>update<CR><Cmd>VimtexCompileSS<CR>
noremap <localleader>c <Cmd>update<CR><Cmd>VimtexCompile<CR>

"Forward search
nmap <localleader>v <plug>(vimtex-view)

"Configuración apañá del conceal
setlocal conceallevel=1
hi! Conceal guifg=#A0A0A0 guibg=#111111 ctermfg=grey ctermbg=black


"Configuraciones sexta parte del tutorial para que el focus vuelva
"a vim después del forward search
if !exists("s:vim_window_id")
  let s:vim_window_id = trim(system("xdotool getactivewindow"))
endif

function! s:TexFocusVim() abort
  " Give window manager time to recognize focus moved to Zathura;
  " tweak the 200m (200 ms) as needed for your hardware and window manager.
  sleep 200m

  " Refocus Vim and redraw the screen
  silent execute "!xdotool windowfocus " . s:vim_window_id
  redraw!
endfunction

augroup vimtex_event_focus
  au!
  au User VimtexEventView call s:TexFocusVim()
augroup END
