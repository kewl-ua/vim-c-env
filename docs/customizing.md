# Customizing

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/customizing.md)

## Common tweaks

- **Pin a specific clangd** — by default the one on `PATH` is used. To pin
  another, add `"clangd.path": "/path/to/clangd"` to `coc-settings.json`.
- **Drop clang-tidy or the background index** — remove the matching flag from
  `clangd.arguments` in `coc-settings.json`.
- **Leader on Space** — add `let mapleader=" "` at the top of `vimrc`
  (then `\rn` becomes `<Space>rn`, etc.).
- **Add a plugin** — add a `Plug '...'` line between `plug#begin`/`plug#end` in
  `vimrc`, then `:PlugInstall` (or `make update`).
- **Format on save by default** — add `let g:c_format_on_save = 1` before the
  coc block in `vimrc`.
- **Another color scheme** — replace `silent! colorscheme gruvbox` in `vimrc`.

---

## Full config

The complete config, for reference (the source of truth is the `vimrc` and
`coc-settings.json` files in this repo).

<details>
<summary><strong>vimrc</strong></summary>

```vim
set number
set relativenumber

set ignorecase
set smartcase
set incsearch
set hlsearch

set tabstop=4
set shiftwidth=4
set expandtab

set wildmenu
set wildmode=list:longest

syntax on
set background=dark

set mouse=a

set autoread

set hidden

set scrolloff=3
set wrap
set linebreak
set clipboard=unnamedplus

set cursorline
set showcmd
set showmode
set ruler

set incsearch
set hlsearch

set ttimeoutlen=50

" Plugin options that must be set before the plugins load.
let g:NERDCreateDefaultMappings = 0 " only \c<Space>; keeps \ca for coc
let g:gitgutter_map_keys = 0        " own mappings under \g; keeps \h free

call plug#begin('~/.vimfiles/plugged')
Plug 'tpope/vim-sensible'           " sensible defaults
Plug 'scrooloose/nerdtree'          " file explorer
Plug 'vim-airline/vim-airline'      | " status line
Plug 'vim-airline/vim-airline-themes' " airline themes
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | " fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'              " color scheme
Plug 'preservim/nerdcommenter'      " code commenting
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP client (C/C++ via clangd)
Plug 'tpope/vim-fugitive'           " git commands: :Git, blame, diff
Plug 'airblade/vim-gitgutter'       " changed-line signs and hunk actions
call plug#end()

silent! colorscheme gruvbox         " silent: not installed yet on the first run

map <C-n> :NERDTreeToggle<CR>

" Commenting: toggle only (default nerdcommenter maps are off, see above)
nmap <leader>c<Space> <Plug>NERDCommenterToggle
xmap <leader>c<Space> <Plug>NERDCommenterToggle

if has("win32")
    set shell=cmd.exe
    set shellcmdflag=/c
    set t_Co=256
endif

if has("win64")
    set shell=cmd.exe
    set shellcmdflag=/c
    set t_Co=256
endif


" Tab settings for certain file types
autocmd FileType make setlocal noexpandtab softtabstop=0
autocmd FileType typescript,javascript,typescriptreact,javascriptreact setlocal tabstop=2
autocmd FileType typescript,javascript,typescriptreact,javascriptreact setlocal shiftwidth=2
autocmd FileType typescript,javascript,typescriptreact,javascriptreact setlocal softtabstop=2

filetype plugin indent on

" ============================================================
" coc.nvim — language server (clangd for C/C++)
" ============================================================
set updatetime=300          " faster diagnostics
set signcolumn=yes          " keep the sign column so the layout doesn't jump
set nowritebackup           " some LSPs complain about the backup file

" --- Completion ---
" Tab / Shift-Tab navigate the popup, otherwise a normal Tab
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" Enter confirms the selected item
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Ctrl-Space triggers completion manually
inoremap <silent><expr> <c-space> coc#refresh()

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" --- Code navigation ---
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" --- Jump between diagnostics ---
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" --- K: show documentation under the cursor ---
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" --- Refactor / actions (leader = '\' by default) ---
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ca <Plug>(coc-codeaction-cursor)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format)

" Highlight all occurrences of the symbol under the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')


" --- Switch between foo.c and foo.h ---
nnoremap <silent> <leader>h :CocCommand clangd.switchSourceHeader<CR>

" --- Snippets (coc-snippets; snippet files live in UltiSnips/) ---
imap <C-l> <Plug>(coc-snippets-expand)
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

" --- Format on save: off by default, :FormatOnSaveToggle switches it ---
let g:c_format_on_save = get(g:, 'c_format_on_save', 0)
augroup c_format_on_save
  autocmd!
  autocmd BufWritePre *.c,*.h,*.cc,*.cpp,*.hpp
        \ if g:c_format_on_save | silent! call CocAction('format') | endif
augroup END
command! FormatOnSaveToggle let g:c_format_on_save = !g:c_format_on_save
      \ | echo 'format on save: ' . (g:c_format_on_save ? 'on' : 'off')

" ============================================================
" Build and quickfix
" ============================================================
" \m runs :make; compiler errors land in the quickfix window
nnoremap <silent> <leader>m :silent make! <bar> redraw! <bar> cwindow<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>

" ============================================================
" Git (fugitive + gitgutter)
" ============================================================
nnoremap <silent> <leader>gg :Git<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gd :Gdiffsplit<CR>
nmap <expr> ]c &diff ? ']c' : '<Plug>(GitGutterNextHunk)'
nmap <expr> [c &diff ? '[c' : '<Plug>(GitGutterPrevHunk)'
nmap <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)

" ============================================================
" Debugging (built-in Termdebug + gdb)
" ============================================================
" Start with \dd and the program name, e.g. :Termdebug ./demo
if has('terminal') || has('nvim')
  packadd! termdebug
  nnoremap <leader>dd :Termdebug<Space>
else
  " Vim 9.1's Termdebug fails without +terminal, so explain instead of erroring
  nnoremap <leader>dd :echohl WarningMsg <bar> echo 'Debugging needs Vim built with +terminal (see README)' <bar> echohl None<CR>
endif
nnoremap <silent> <leader>dr :Run<CR>
nnoremap <silent> <leader>db :Break<CR>
nnoremap <silent> <leader>dx :Clear<CR>
nnoremap <silent> <leader>dc :Continue<CR>
nnoremap <silent> <leader>dn :Over<CR>
nnoremap <silent> <leader>ds :Step<CR>
nnoremap <silent> <leader>df :Finish<CR>
nnoremap <silent> <leader>de :Evaluate<CR>
nnoremap <silent> <F5>  :Continue<CR>
nnoremap <silent> <F9>  :Break<CR>
nnoremap <silent> <F10> :Over<CR>
nnoremap <silent> <F11> :Step<CR>
```
</details>

<details>
<summary><strong>coc-settings.json</strong></summary>

```json
{
  "clangd.arguments": [
    "--query-driver=**/arm-none-eabi-*",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "-j=4"
  ],
  "snippets.ultisnips.pythonPrompt": false
}
```
</details>
