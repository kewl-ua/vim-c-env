" SPDX-License-Identifier: GPL-3.0-or-later
" Headless checks run by scripts/smoke-test.sh. Results go to $VCE_SMOKE_OUT.
let s:results = []

function! s:Check(name, ok) abort
  call add(s:results, (a:ok ? 'ok   ' : 'FAIL ') . a:name)
endfunction

call s:Check('vim starts without errors', empty(v:errmsg))
call s:Check('gruvbox is active', get(g:, 'colors_name', '') ==# 'gruvbox')
call s:Check(':Cheatsheet exists', exists(':Cheatsheet') == 2)
call s:Check(':FormatOnSaveToggle exists', exists(':FormatOnSaveToggle') == 2)
call s:Check(':Git exists (fugitive)', exists(':Git') == 2)
call s:Check(':NERDTreeToggle exists', exists(':NERDTreeToggle') == 2)
call s:Check('\ca runs the coc code action', maparg('\ca', 'n') =~# 'coc-codeaction')
call s:Check('\c<Space> toggles comments', maparg('\c<Space>', 'n') =~# 'NERDCommenterToggle')
call s:Check('\h switches source/header', maparg('\h', 'n') =~# 'switchSourceHeader')
call s:Check('\m runs make', maparg('\m', 'n') =~# 'make')
call s:Check('<C-l> expands snippets', maparg('<C-l>', 'i') =~# 'coc-snippets-expand')
call s:Check('\k opens C man pages', maparg('\k', 'n') =~# 'CMan')
call s:Check(':Man exists', exists(':Man') == 2)

if !empty($VCE_REPO)
  execute 'edit ' . fnameescape($VCE_REPO . '/example-esp32/main/main.c')
  call s:Check('\m builds ESP-IDF projects with idf.py', &l:makeprg =~# '^idf\.py ')
  execute 'edit ' . fnameescape($VCE_REPO . '/example/main.c')
  call s:Check('\m stays make outside ESP-IDF', &l:makeprg ==# '' || &l:makeprg ==# 'make')
  enew
endif

try
  help vim-c-env-debug
  call s:Check('help page vim-c-env opens', &filetype ==# 'help')
  helpclose
catch
  call s:Check('help page vim-c-env opens (' . v:exception . ')', 0)
endtry

if has('terminal') || has('nvim')
  call s:Check(':Termdebug exists', exists(':Termdebug') == 2)
endif

call writefile(s:results, $VCE_SMOKE_OUT)
qa!
