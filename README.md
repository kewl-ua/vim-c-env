# vim-env

Моє повне середовище Vim для розробки на **C** — конфіг, bootstrap-скрипт і
візуальна шпаргалка в одному місці.

Мовний сервер — **clangd** через **coc.nvim**; тема — **gruvbox**.

---

## Вимоги

| Інструмент | Навіщо | Перевірка |
|------------|--------|-----------|
| Vim 8.2+ з `+job +timers +channel` | async LSP | `vim --version \| grep +job` |
| Node.js ≥ 16 | рушій coc.nvim | `node --version` |
| clangd | мовний сервер C/C++ | `clangd --version` |
| bear *(опційно)* | генерує `compile_commands.json` з `make` | `bear --version` |

Встановлення системних пакетів (приклади):

```bash
# Gentoo
sudo emerge llvm-core/clang dev-util/bear nodejs

# Debian/Ubuntu
sudo apt install clangd bear nodejs

# Arch
sudo pacman -S clang bear nodejs
```

---

## Встановлення

```bash
git clone <url-цього-репо> vim-env
cd vim-env
./install.sh
```

Скрипт:
1. робить симлінки `vimrc` → `~/.vimrc` і `coc-settings.json` → `~/.vim/coc-settings.json`;
2. ставить **vim-plug**, якщо його нема;
3. ставить плагіни (`PlugInstall`) і розширення **coc-clangd** — headless.

> ⚠️ `install.sh` перезапише наявні `~/.vimrc` і `~/.vim/coc-settings.json`
> симлінками. Збережи свої, якщо вони цінні.

Після цього відредагуй шлях до clangd у `coc-settings.json`, якщо він не
`/usr/lib/llvm/22/bin/clangd`.

---

## Що всередині

```
vim-env/
├── vimrc                 # головний конфіг (→ ~/.vimrc)
├── coc-settings.json     # налаштування coc/clangd (→ ~/.vim/coc-settings.json)
├── install.sh            # bootstrap
├── cheatsheet/
│   └── index.html        # візуальна шпаргалка (gruvbox, відкрити в браузері)
└── README.md
```

**Плагіни** (через vim-plug): coc.nvim (LSP), NERDTree (файли), fzf + fzf.vim
(пошук), vim-airline (статусбар), gruvbox (тема), nerdcommenter (коментарі),
vim-surround, vim-sensible.

---

## Робочий цикл C

```bash
cd <проєкт>
bear -- make      # один раз, або коли змінились флаги/файли
vim main.c        # clangd сам підхопить compile_commands.json
```

Для одного файлу `bear` не потрібен — clangd працює одразу.
Для проєкту без `make` достатньо `compile_flags.txt` у корені (по флагу на рядок).

---

## Гарячі клавіші (leader = `\`)

Повна візуальна версія — **`cheatsheet/index.html`** (відкрити у браузері).

| Клавіша | Дія |
|---------|-----|
| `gd` / `gr` | до визначення / усі використання |
| `gy` / `gi` | до типу / реалізації |
| `K` | документація під курсором |
| `]g` / `[g` | наступна / попередня помилка |
| `Tab` / `Shift-Tab` / `Enter` | навігація / підтвердження автодоповнення |
| `\rn` | перейменувати символ |
| `\ca` | code action (quick-fix) |
| `\f` | форматувати (clang-format) |
| `Ctrl-n` | дерево файлів (NERDTree) |
| `:Files` / `:Rg текст` | fuzzy-пошук файлів / по вмісту |
| `\c<space>` | за/роз-коментувати |

**Корисні команди:** `:CocInfo`, `:CocList diagnostics`, `:CocList extensions`,
`:CocCommand clangd.switchSourceHeader` (стрибок `.c` ↔ `.h`), `:PlugInstall`,
`:PlugUpdate`, `:CocUpdate`.
