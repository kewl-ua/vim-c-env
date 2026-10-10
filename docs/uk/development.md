# Розробка

[← vim-c-env](../../README.uk.md) · [Уся документація](README.md) · [English](../development.md) · **Українська**

## Таргети Makefile

| Команда | Що робить |
|---------|-----------|
| `make` / `make help` | список таргетів |
| `make doctor` | перевіряє можливості Vim, Node, clangd, bear, gdb і Neovim |
| `make install` | повний bootstrap (`install.sh`) |
| `make link` | лише симлінки конфігів і Vim-пакета (без плагінів) |
| `make update` | `PlugUpdate` + `CocUpdate` |
| `make example` | збирає приклад на C |
| `make example-unix` | збирає й запускає POSIX-приклад pipeline |
| `make example-arm` | збирає приклад для Cortex-M4 (потрібен `arm-none-eabi-gcc`) |
| `make test` | smoke-тест встановленого середовища: Vim, Neovim, coc, clangd і приклад |
| `make hero` | перегенерує анімовану шапку README і превʼю для соцмереж |
| `make demos` | перезнімає гіфки README ([деталі](#запис-демо)) |
| `make clean` | прибирає артефакти збірки прикладів |
| `make uninstall` | прибирає створені репозиторієм симлінки |

---

## Тести і CI

[`ci.yml`](../../.github/workflows/ci.yml) запускається на кожен push: shellcheck і
vint, перевірка help-сторінки, потім чисті `make install` і `make test` на
Ubuntu та macOS.

---

## Запис демо

Кожна гіфка в README зроблена скриптом `scripts/record-demos.sh` (`make demos`).
Він керує Vim через tmux з конфігом цього репозиторію, записує через asciinema
і рендерить через agg. Скрипт працює на тимчасовій копії `example/`, тож
репозиторій лишається недоторканим. `scripts/record-demos.sh hover git`
перезнімає лише ці дві. Демо дебагера записується в Docker-образі, якщо
локальний Vim не має `+terminal`.

Анімовану шапку README малює `scripts/make-hero.py` (`make hero`): кожен кадр —
SVG, відрендерений через rsvg-convert, а gif збирає ffmpeg. Останній кадр стає
`assets/social-preview.png`.

---

## Структура репозиторію

```
vim-c-env/
├── vimrc                 # main config (→ ~/.vimrc)
├── nvim/init.vim         # Neovim entry point (→ ~/.config/nvim/init.vim)
├── coc-settings.json     # coc/clangd settings (→ ~/.vim/coc-settings.json)
├── install.sh            # bootstrap
├── Makefile              # convenience targets (install/update/doctor/...)
├── Dockerfile            # the whole environment in a container
├── .github/workflows/    # CI (lint + install test) and Docker publishing
├── scripts/
│   ├── smoke-test.sh     # make test: headless checks of the setup
│   ├── smoke.vim         # the Vim-side half of those checks
│   ├── record-demos.sh   # re-records the README gifs (make demos)
│   ├── make-hero.py      # animated README header + social preview (make hero)
│   └── esp-clangd-setup.sh # writes .clangd for an ESP-IDF project
├── _config.yml           # GitHub Pages / SEO settings
├── assets/               # demo gifs + social preview image
├── UltiSnips/
│   └── c.snippets        # C snippets for coc-snippets
├── doc/
│   └── vim-c-env.txt     # cheatsheet as a Vim help page (:Cheatsheet)
├── plugin/
│   └── vim-c-env.vim     # defines :Cheatsheet and \?
├── example-arm/          # bare-metal STM32F407 blink (Cortex-M4)
├── example-esp32/        # ESP-IDF FreeRTOS blink, any ESP32 chip
├── example-unix/         # POSIX pipeline: fork, pipe, exec; asan/valgrind/strace targets
├── example/
│   ├── main.c            # demo project
│   ├── Makefile          # build (via bear when present)
│   └── .clang-format     # formatting style
├── docs/                 # this documentation (docs/uk/: Ukrainian)
├── README.md
├── README.uk.md          # this README in Ukrainian
└── LICENSE               # GNU GPL v3
```

**Плагіни** (vim-plug): coc.nvim, NERDTree, fzf + fzf.vim, vim-airline (+themes),
gruvbox, nerdcommenter, vim-surround, vim-sensible, vim-fugitive, vim-gitgutter.
Вбудований: Termdebug. Розширення coc: coc-clangd, coc-snippets.
