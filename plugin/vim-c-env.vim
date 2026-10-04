" SPDX-License-Identifier: GPL-3.0-or-later
" vim-c-env: open the built-in cheatsheet (doc/vim-c-env.txt).
"
"   :Cheatsheet         open it in a split (like :help)
"   :vert Cheatsheet    vertical split
"   :tab Cheatsheet     new tab
"   \?                  same as :Cheatsheet

if exists('g:loaded_vim_c_env')
  finish
endif
let g:loaded_vim_c_env = 1

command! -bar Cheatsheet <mods> help vim-c-env

if !hasmapto(':Cheatsheet<CR>', 'n')
  nnoremap <silent> <leader>? :Cheatsheet<CR>
endif

" The cheatsheet is laid out for 78 columns; drop the sign column there.
augroup vim_c_env
  autocmd!
  autocmd BufWinEnter */doc/vim-c-env.txt setlocal signcolumn=no
augroup END
