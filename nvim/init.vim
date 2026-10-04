" SPDX-License-Identifier: GPL-3.0-or-later
" vim-c-env for Neovim: reuse the Vim config from this repo.
" install.sh links this file to ~/.config/nvim/init.vim when nothing is there.

let s:repo = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

" vim-plug lives in ~/.vim/autoload; the repo adds :Cheatsheet, help, snippets.
set runtimepath^=~/.vim runtimepath+=~/.vim/after
execute 'set runtimepath+=' . fnameescape(s:repo)
let &packpath = &runtimepath

" Same coc-settings.json as Vim.
let g:coc_config_home = s:repo

execute 'source ' . fnameescape(s:repo . '/vimrc')
