" Backend para vscode-neovim (Cursor/VS Code). No cargar plugins aquí.
if exists('g:vscode')
  source ~/.vimrc_minimal
else
  " Neovim en terminal: misma config mínima
  source ~/.vimrc_minimal
endif
