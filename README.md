# vim-env

Моє повне середовище **Vim для розробки на C** — конфіг, bootstrap, приклад
проєкту та візуальна шпаргалка в одному репозиторії.

Мовний сервер — **clangd** через **coc.nvim**; тема — **gruvbox**.
VSCode-подібний досвід (автодоповнення, переходи, діагностики, рефакторинг),
але у Vim і повністю локально.

---

## Зміст

- [Можливості](#можливості)
- [Вимоги](#вимоги)
- [Швидкий старт](#швидкий-старт)
- [Таргети Makefile](#таргети-makefile)
- [Як це влаштовано](#як-це-влаштовано)
- [Робочий цикл C](#робочий-цикл-c)
- [Приклад проєкту](#приклад-проєкту)
- [Гарячі клавіші](#гарячі-клавіші)
- [Налаштування під себе](#налаштування-під-себе)
- [Траблшутинг](#траблшутинг)
- [Структура репозиторію](#структура-репозиторію)
- [Видалення](#видалення)

---

## Можливості

- **LSP для C/C++** через clangd: автодоповнення, `gd`/`gr`, hover, діагностики,
  перейменування, code actions, форматування (clang-format).
- **clang-tidy** увімкнено (лінтер статичного аналізу).
- **Фоновий індекс** проєкту (швидкі переходи по всій кодовій базі).
- Файловий менеджер (NERDTree), fuzzy-пошук (fzf), статусбар (airline),
  коментування (nerdcommenter), робота з дужками/лапками (vim-surround).
- Один `./install.sh` або `make install` піднімає все з нуля.

---

## Вимоги

| Інструмент | Навіщо | Перевірка |
|------------|--------|-----------|
| Vim 8.2+ з `+job +timers +channel` | async LSP | `vim --version \| grep +job` |
| Node.js ≥ 16 | рушій coc.nvim | `node --version` |
| clangd | мовний сервер C/C++ | `clangd --version` |
| bear *(опційно)* | генерує `compile_commands.json` з `make` | `bear --version` |
| git, curl | клон + завантаження vim-plug | — |

Усе разом перевіряється командою **`make doctor`**.

Встановлення системних пакетів:

```bash
# Gentoo
sudo emerge llvm-core/clang dev-util/bear nodejs

# Debian / Ubuntu
sudo apt install clangd bear nodejs

# Arch
sudo pacman -S clang bear nodejs

# macOS (Homebrew)
brew install llvm bear node
```

---

## Швидкий старт

```bash
git clone <url-цього-репо> vim-env
cd vim-env
make doctor      # перевірити залежності
make install     # симлінки + vim-plug + плагіни + coc-clangd
make example     # зібрати приклад і згенерувати compile_commands.json
vim example/main.c
```

> ⚠️ `install` перезапише `~/.vimrc` і `~/.vim/coc-settings.json`
> **симлінками** на цей репозиторій. Збережи свої копії, якщо вони цінні
> (`make uninstall` потім приберe лише ці симлінки).

---

## Таргети Makefile

| Команда | Що робить |
|---------|-----------|
| `make` / `make help` | список таргетів |
| `make doctor` | перевірити vim-фічі, node, clangd, bear |
| `make install` | повний bootstrap (`install.sh`) |
| `make link` | тільки симлінки конфігів (без плагінів) |
| `make update` | `PlugUpdate` + `CocUpdate` |
| `make cheatsheet` | відкрити `cheatsheet/index.html` у браузері |
| `make example` | зібрати приклад C-проєкту |
| `make clean` | прибрати артефакти прикладу |
| `make uninstall` | прибрати створені симлінки |

---

## Як це влаштовано

`install.sh` (або `make install`):

1. **Симлінки** `vimrc → ~/.vimrc` і `coc-settings.json → ~/.vim/coc-settings.json`.
   Правиш файли в репо — зміни одразу діють; `git pull` оновлює конфіг.
2. **vim-plug** завантажується в `~/.vim/autoload/plug.vim`, якщо його нема.
3. **Плагіни** ставляться headless (`PlugInstall`). Каталог плагінів —
   `~/.vimfiles/plugged` (заданий у `vimrc`).
4. **coc-clangd** ставиться як coc-розширення; воно спілкується з clangd за
   шляхом із `coc-settings.json`.

clangd сам по собі — **системний пакет**, скрипт його не чіпає.

---

## Робочий цикл C

```bash
cd <проєкт>
bear -- make      # один раз, або коли змінились флаги / додались файли
vim main.c        # clangd сам підхопить compile_commands.json
```

- **Один файл** — `bear` не потрібен, clangd працює одразу з дефолтними флагами.
- **Проєкт без `make`** — поклади `compile_flags.txt` у корінь, по флагу на рядок:
  ```
  -std=c11
  -Wall
  -Iinclude
  ```
- **CMake** — додай `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, і він згенерує
  `compile_commands.json` сам.

Чому це треба: без списку флагів clangd не знає твоїх `-I`-інклудів і `-D`-дефайнів
і буде лаятись на `#include` та макроси.

---

## Приклад проєкту

`example/` — мінімальний C-проєкт, щоб одразу перевірити середовище:

```bash
make example          # bear -- gcc ... → demo + compile_commands.json
./example/demo        # Hello from vim-env — vim-env (2026)
vim example/main.c    # спробуй gd / K / \f / автодоповнення
```

Там же лежить `.clang-format` — стиль, яким форматує `\f` (4 пробіли, 100 колонок).

---

## Гарячі клавіші

Повна візуальна версія — **`cheatsheet/index.html`** (`make cheatsheet`).
Leader-клавіша — `\`.

**Навігація**
| Клавіша | Дія |
|---------|-----|
| `gd` / `gr` | до визначення / усі використання |
| `gy` / `gi` | до типу / реалізації |
| `K` | документація під курсором |
| `]g` / `[g` | наступна / попередня помилка |
| `Ctrl-o` / `Ctrl-i` | назад / вперед по стрибках |

**Автодоповнення**
| Клавіша | Дія |
|---------|-----|
| `Tab` / `Shift-Tab` | вниз / вгору по списку |
| `Enter` | підтвердити вибір |
| `Ctrl-Space` | викликати вручну |

**Рефакторинг / код**
| Клавіша | Дія |
|---------|-----|
| `\rn` | перейменувати символ усюди |
| `\ca` | code action (quick-fix) |
| `\f` | форматувати (clang-format) |

**Файли / пошук / правки**
| Клавіша / команда | Дія |
|-------------------|-----|
| `Ctrl-n` | дерево файлів (NERDTree) |
| `:Files` / `:Rg текст` | fuzzy-пошук файлів / по вмісту |
| `\c<space>` | за/роз-коментувати |
| `ysiw"` / `cs"'` / `ds"` | обгорнути / змінити / прибрати лапки |

**Команди:** `:CocInfo`, `:CocList diagnostics`, `:CocList extensions`,
`:CocCommand clangd.switchSourceHeader` (`.c` ↔ `.h`), `:PlugInstall`, `:PlugUpdate`.

---

## Налаштування під себе

- **Інший шлях до clangd** — поправ `clangd.path` у `coc-settings.json`
  (дізнатись шлях: `command -v clangd`).
- **Прибрати clang-tidy або фоновий індекс** — прибери відповідний прапор зі
  списку `clangd.arguments` у `coc-settings.json`.
- **Leader на пробіл** — додай `let mapleader=" "` на початок `vimrc`
  (тоді `\rn` стане `<Space>rn` і т.д.).
- **Новий плагін** — додай рядок `Plug '...'` між `plug#begin`/`plug#end`
  у `vimrc`, потім `:PlugInstall` (або `make update`).
- **gruvbox і в терміналі** — зараз `colorscheme gruvbox` у `vimrc` увімкнено
  лише під Windows; винеси рядок із `if has("win32")`, щоб діяв і на Linux.

---

## Траблшутинг

| Симптом | Причина / фікс |
|---------|----------------|
| Нема автодоповнення | `:CocInfo` — clangd має бути зелений; `:CocList extensions` — чи є coc-clangd |
| `clangd: command not found` у `:CocInfo` | поправ `clangd.path` у `coc-settings.json` |
| Лається на `#include "мій.h"` | нема `compile_commands.json`/`compile_flags.txt` — див. [Робочий цикл](#робочий-цикл-c) |
| `Tab` вставляє таб, а не доповнення | перевір, що блок coc у `vimrc` на місці і coc-клієнт запущений (`:CocInfo`) |
| Нічого не стартує | `vim --version \| grep +job` має бути `+job`; старий Vim без `+job` не потягне coc |

---

## Структура репозиторію

```
vim-env/
├── vimrc                 # головний конфіг (→ ~/.vimrc)
├── coc-settings.json     # налаштування coc/clangd (→ ~/.vim/coc-settings.json)
├── install.sh            # bootstrap
├── Makefile              # зручні таргети (install/update/doctor/...)
├── cheatsheet/
│   └── index.html        # візуальна шпаргалка (gruvbox)
├── example/
│   ├── main.c            # демо-проєкт
│   ├── Makefile          # збірка (через bear, якщо є)
│   └── .clang-format     # стиль форматування
└── README.md
```

**Плагіни** (vim-plug): coc.nvim, NERDTree, fzf + fzf.vim, vim-airline (+themes),
gruvbox, nerdcommenter, vim-surround, vim-sensible.

---

## Видалення

```bash
make uninstall     # прибирає лише симлінки ~/.vimrc і ~/.vim/coc-settings.json
```

Плагіни в `~/.vimfiles/plugged`, vim-plug і coc-розширення лишаються —
за потреби прибери їх вручну.
