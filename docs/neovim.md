# Neovim

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/neovim.md)

The same config runs in Neovim 0.8+ through [`nvim/init.vim`](../nvim/init.vim).
It loads this repo's `vimrc`, adds the repo to `runtimepath` (for
`:Cheatsheet`, the help page and snippets), and points coc at the same
`coc-settings.json`.

`make install` links it to `~/.config/nvim/init.vim` only when you have no
Neovim config yet. If you do, it leaves yours alone; add this line to it instead:

```vim
source ~/path/to/vim-c-env/nvim/init.vim
```

Neovim always has a built-in terminal, so the debugger works there even where
Vim was built without `+terminal`. `make test` repeats the Vim checks in Neovim.
