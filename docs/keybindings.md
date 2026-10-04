# Keybindings

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/keybindings.md)

Inside Vim: **`:Cheatsheet`** or **`\?`** opens this reference as a help page
(`:help vim-c-env`). In a browser: **`cheatsheet/index.html`**
(`make cheatsheet`). Leader key is `\`.

**Navigation**
| Key | Action |
|-----|--------|
| `gd` / `gr` | go to definition / all references |
| `gy` / `gi` | go to type / implementation |
| `K` | documentation under the cursor |
| `\k` | man page, C sections first ([details](unix.md#man-pages-k)) |
| `]g` / `[g` | next / previous diagnostic |
| `Ctrl-o` / `Ctrl-i` | jump back / forward |

**Completion**
| Key | Action |
|-----|--------|
| `Tab` / `Shift-Tab` | down / up the list |
| `Enter` | confirm the selection |
| `Ctrl-Space` | trigger manually |

**Refactor / code**
| Key | Action |
|-----|--------|
| `\rn` | rename the symbol everywhere |
| `\ca` | code action (quick-fix) |
| `\h` | switch between `foo.c` and `foo.h` |
| `\f` | format (clang-format) |
| `:FormatOnSaveToggle` | format C/C++ files on every `:w` |

**Snippets** (type a trigger, then `Ctrl-l`, or pick it from the completion menu)
| Key / trigger | Action |
|---------------|--------|
| `main` `for` `if` `sw` `st` `guard` `pr` `mal` | C snippet triggers ([full list](../UltiSnips/c.snippets)) |
| `fork` `pipe` `waitpid` `sigaction` `getopt` `tcpserver` | UNIX snippets ([details](unix.md#snippets)) |
| `Ctrl-l` | expand the trigger before the cursor |
| `Ctrl-j` / `Ctrl-k` | next / previous placeholder |

**Build and quickfix**
| Key | Action |
|-----|--------|
| `\m` | run `:make`; errors open in the quickfix list |
| `]q` / `[q` | next / previous error |
| `Enter` (in quickfix) | jump to that error |

**Debugging** (gdb via Termdebug; build with `-g`)
| Key | Action |
|-----|--------|
| `\dd` | start: type the program, e.g. `\dd ./demo` |
| `\db` / `F9` | breakpoint on the cursor line |
| `\dx` | clear the breakpoint |
| `\dr` | run |
| `\dc` / `F5` | continue |
| `\dn` / `F10` | step over |
| `\ds` / `F11` | step into |
| `\df` | finish the current function |
| `\de` / `K` | evaluate the expression under the cursor |

**Git**
| Key | Action |
|-----|--------|
| `\gg` | status (fugitive): `s` stages, `cc` commits |
| `\gb` | blame |
| `\gd` | diff against the index |
| `]c` / `[c` | next / previous changed hunk |
| `\gp` / `\gs` / `\gu` | preview / stage / undo the hunk |

**Files / search / edit**
| Key / command | Action |
|---------------|--------|
| `Ctrl-n` | file tree (NERDTree) |
| `:Files` / `:Rg text` | fuzzy-find files / by content |
| `\c<space>` | toggle comment |
| `ysiw"` / `cs"'` / `ds"` | surround / change / delete quotes |

**Inside NERDTree** (after `Ctrl-n`)
| Key | Action |
|-----|--------|
| `o` / `Enter` | open file or expand directory |
| `t` | open in a new tab |
| `i` / `s` | open in a horizontal / vertical split |
| `p` | jump to parent directory |
| `R` | refresh the tree |
| `m` | menu: create / delete / move / copy |
| `I` | toggle hidden files |
| `q` | close the tree |

![NERDTree](../assets/files.gif)

**Inside fzf** (`:Files`, `:Rg`)
| Key | Action |
|-----|--------|
| `Enter` | open the selection |
| `Ctrl-t` | open in a new tab |
| `Ctrl-x` / `Ctrl-v` | open in a horizontal / vertical split |
| `Tab` / `Shift-Tab` | multi-select (where supported) |
| `Esc` | cancel |

**Surround** (vim-surround), with the cursor on a word
| Keys | Action |
|------|--------|
| `ysiw"` | wrap the word in `"` |
| `cs"'` | change surrounding `"` to `'` |
| `ds"` | delete surrounding `"` |
| `yss)` | wrap the whole line in `()` |

**Commands:** `:Cheatsheet`, `:FormatOnSaveToggle`, `:Termdebug ./prog`, `:CocInfo`, `:CocList diagnostics`, `:CocList extensions`,
`:CocCommand clangd.switchSourceHeader` (`.c` ↔ `.h`), `:PlugInstall`, `:PlugUpdate`.
