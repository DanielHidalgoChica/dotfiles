"Configuraciones para el visualizador de pdf con latex
if empty(v:servername) && exists('*remote_startserver')
    call remote_startserver('VIM')
endif

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

"Para no usar los mappings en insert mode de vimtex
let g:vimtex_imaps_enabled = 0
let g:vimtex_quickfix_open_on_warning = 0 "no abrir el quickfix en warnings
" Filter out some compilation warning messages from QuickFix display
let g:vimtex_quickfix_ignore_filters = [
      \ 'Underfull \\hbox',
      \ 'Overfull \\hbox',
      \ 'LaTeX Warning: .\+ float specifier changed to',
      \ 'LaTeX hooks Warning',
      \ 'Package siunitx Warning: Detected the "physics" package:',
      \ 'Package hyperref Warning: Token not allowed in a PDF string',
      \]
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_compiler_latexmk = {
  \ 'aux_dir': 'build',
  \ 'options': [
  \   '-verbose',
  \   '-file-line-error',
  \   '-synctex=1',
  \   '-interaction=nonstopmode',
  \   '-outdir=build',
  \   '-shell-escape',
  \ ],
  \}

