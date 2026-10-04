# Типові проблеми

[← vim-c-env](../../README.uk.md) · [Уся документація](README.md) · [English](../troubleshooting.md) · **Українська**

| Симптом | Причина / рішення |
|---------|-------------------|
| Немає доповнення | `:CocInfo` — clangd має бути запущений; `:CocList extensions` — чи є coc-clangd |
| `clangd: command not found` у `:CocInfo` | встановіть clangd (див. [Встановлення](installation.md#встановлення)) або додайте `"clangd.path"` у `coc-settings.json` |
| Помилки на `#include "my.h"` | немає `compile_commands.json` / `compile_flags.txt` — див. [Робочий цикл C](c-workflow.md#робочий-цикл-c) |
| `Tab` вставляє табуляцію замість доповнення | перевірте, що блок coc є у `vimrc` і клієнт coc запущений (`:CocInfo`) |
| `\dd` пише, що Vim потребує `+terminal` | Termdebug у Vim 9.1 без нього не працює. Поставте повну збірку (`vim-nox`, `vim-gtk3`; Gentoo: `USE=terminal`) або користуйтеся Neovim |
| Нічого не запускається | `vim --version \| grep +job` має показати `+job`; старий Vim без `+job` не потягне coc |
