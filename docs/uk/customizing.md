# Налаштування

[← vim-c-env](../../README.uk.md) · [Уся документація](README.md) · [English](../customizing.md) · **Українська**

## Типові зміни

- **Конкретний clangd** — за замовчуванням береться той, що в `PATH`. Щоб
  закріпити інший, додайте `"clangd.path": "/path/to/clangd"` у
  `coc-settings.json`.
- **Без clang-tidy чи фонового індексу** — приберіть відповідний прапорець зі
  списку `clangd.arguments` у `coc-settings.json`.
- **Leader на пробілі** — додайте `let mapleader=" "` на початок `vimrc`
  (тоді `\rn` стане `<Space>rn` і т. д.).
- **Новий плагін** — додайте рядок `Plug '...'` між `plug#begin` і `plug#end` у
  `vimrc`, потім `:PlugInstall` (або `make update`).
- **Форматування при збереженні за замовчуванням** — додайте
  `let g:c_format_on_save = 1` перед блоком coc у `vimrc`.
- **Інша кольорова схема** — замініть `silent! colorscheme gruvbox` у `vimrc`.

---

## Повний конфіг

Повний конфіг лежить у файлах [`vimrc`](../../vimrc), [`coc-settings.json`](../../coc-settings.json)
і [`nvim/init.vim`](../../nvim/init.vim). Англійський README містить його повну копію в
розділі [Full config](../customizing.md#full-config).
