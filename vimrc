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

call plug#begin('~/.vimfiles/plugged')
Plug 'tpope/vim-sensible'           " Базовые настройки
Plug 'scrooloose/nerdtree'          " Файловый менеджер
Plug 'vim-airline/vim-airline'      | " Статусная строка
Plug 'vim-airline/vim-airline-themes' " Темы для airline
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | " Fuzzy findergG
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'              " Цветовая схема
Plug 'preservim/nerdcommenter'      " Комментирование кода
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP-клиент (C/C++ через clangd)
call plug#end()

map <C-n> :NERDTreeToggle<CR>

if has("win32")
    set shell=cmd.exe
    set shellcmdflag=/c
    set t_Co=256
    colorscheme gruvbox
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
" coc.nvim — языковой сервер (для C/C++ работает clangd)
" ============================================================
set updatetime=300          " быстрее показываются диагностики
set signcolumn=yes          " колонка для значков ошибок не прыгает
set nowritebackup           " некоторые LSP ругаются на backup-файл

" --- Автодополнение ---
" Tab / Shift-Tab — навигация по popup, иначе обычный Tab
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" Enter подтверждает выбранный вариант
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Ctrl-Space — вызвать автодополнение вручную
inoremap <silent><expr> <c-space> coc#refresh()

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" --- Навигация по коду ---
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" --- Переход по ошибкам/предупреждениям ---
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" --- K: показать документацию под курсором ---
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" --- Рефакторинг / действия (leader = '\' по умолчанию) ---
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ca <Plug>(coc-codeaction-cursor)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format)

" Подсветка всех вхождений символа под курсором
autocmd CursorHold * silent call CocActionAsync('highlight')

