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
