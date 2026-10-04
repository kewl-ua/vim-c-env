# Neovim

[← vim-c-env](../../README.uk.md) · [Уся документація](README.md) · [English](../neovim.md) · **Українська**

Той самий конфіг працює в Neovim 0.8+ через [`nvim/init.vim`](../../nvim/init.vim).
Він завантажує `vimrc` з цього репозиторію, додає репозиторій у `runtimepath`
(для `:Cheatsheet`, help-сторінки й сніпетів) і вказує coc на той самий
`coc-settings.json`.

`make install` створює симлінк `~/.config/nvim/init.vim` лише тоді, коли у вас
ще немає конфігу Neovim. Якщо він є, `make install` його не чіпає; додайте в
нього рядок:

```vim
source ~/path/to/vim-c-env/nvim/init.vim
```

У Neovim термінал вбудований завжди, тож дебагер працює там навіть тоді, коли
Vim зібраний без `+terminal`. `make test` повторює перевірки Vim у Neovim.
