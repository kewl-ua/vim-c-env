# Встановлення

[← vim-c-env](../../README.uk.md) · [Уся документація](README.md) · [English](../installation.md) · **Українська**

## Вимоги

| Інструмент | Навіщо | Перевірка |
|------------|--------|-----------|
| <img src="https://cdn.simpleicons.org/vim" height="14" alt=""> Vim 8.2+ з `+job +timers +channel` | асинхронний LSP | `vim --version \| grep +job` |
| <img src="https://cdn.simpleicons.org/nodedotjs" height="14" alt=""> Node.js ≥ 16 | рушій coc.nvim | `node --version` |
| <img src="https://cdn.simpleicons.org/llvm/262D3A/C9CDD6" height="14" alt=""> clangd | мовний сервер C/C++ | `clangd --version` |
| bear *(необовʼязково)* | створює `compile_commands.json` з `make` | `bear --version` |
| gdb *(необовʼязково)* | дебагер для `:Termdebug`; Vim також потребує `+terminal` | `gdb --version` |
| <img src="https://cdn.simpleicons.org/git" height="14" alt=""> git, <img src="https://cdn.simpleicons.org/curl/073551/7FB3D5" height="14" alt=""> curl | клонування і завантаження vim-plug | — |

Усе разом перевіряє **`make doctor`**. Кроки для кожної ОС — у розділі
[Встановлення](#встановлення).

---

## Встановлення

Кроки розраховані на щойно встановлену систему. Поставте залежності для своєї
платформи, потім клонуйте репозиторій і запустіть bootstrap.

### <img src="https://cdn.simpleicons.org/linux" height="20" alt=""> Linux

Потрібні: Vim з `+job`, Node.js, clangd, bear, git, curl.

#### <img src="https://cdn.simpleicons.org/debian" height="18" alt=""> Debian / <img src="https://cdn.simpleicons.org/ubuntu" height="18" alt=""> Ubuntu

```bash
sudo apt update
sudo apt install -y vim-nox nodejs npm clangd bear gdb git curl
```

Ставте `vim-nox` (або `vim-gtk3`). У мінімальному `vim-tiny` немає `+job`, а
coc.nvim без нього не працює.

#### <img src="https://cdn.simpleicons.org/fedora" height="18" alt=""> Fedora

```bash
sudo dnf install -y vim-enhanced nodejs clang-tools-extra bear gdb git curl
```

clangd входить до пакета `clang-tools-extra`.

#### <img src="https://cdn.simpleicons.org/archlinux" height="18" alt=""> Arch Linux / Manjaro

```bash
sudo pacman -S --needed vim nodejs clang bear gdb git curl
```

#### <img src="https://cdn.simpleicons.org/opensuse" height="18" alt=""> openSUSE

```bash
sudo zypper install -y vim nodejs clang-tools bear gdb git curl
```

#### <img src="https://cdn.simpleicons.org/gentoo/54487A/DDDAEC" height="18" alt=""> Gentoo

```bash
echo "app-editors/vim terminal" | sudo tee -a /etc/portage/package.use/vim
sudo emerge -q app-editors/vim net-libs/nodejs llvm-core/clang dev-util/bear dev-debug/gdb
```

USE-прапорець `terminal` дає Vim можливість `+terminal`, потрібну дебагеру.

#### Далі, на будь-якому дистрибутиві

```bash
git clone git@github.com:kewl-ua/vim-c-env.git
cd vim-c-env
make doctor      # перевірити, що всі інструменти знайдено
make install     # симлінки + vim-plug + плагіни + coc-clangd
make example     # необовʼязково: зібрати демо-проєкт
vim example/main.c
```

`make doctor` звітує про кожну залежність, а `make example` збирає демо через
bear:

![make doctor і make example](../../assets/doctor.gif)

### <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/windows11/windows11-original.svg" height="20" alt=""> Windows

#### Рекомендовано: WSL2

WSL2 запускає справжній Linux, тож кроки для Linux працюють без змін. У
PowerShell від адміністратора:

```powershell
wsl --install -d Ubuntu
```

Перезавантажтеся, відкрийте **Ubuntu** з меню «Пуск» і виконайте всередині
кроки для **Debian / Ubuntu** вище.

#### Нативний Windows (gVim)

```powershell
winget install vim.vim OpenJS.NodeJS LLVM.LLVM Git.Git
```

`install.sh` — bash-скрипт і на нативному Windows не запуститься, тому файли
копіюються вручну. З теки клонованого репозиторію, у PowerShell:

```powershell
copy vimrc "$HOME\_vimrc"
New-Item -ItemType Directory "$HOME\vimfiles\autoload" -Force | Out-Null
copy coc-settings.json "$HOME\vimfiles\coc-settings.json"
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim `
  -OutFile "$HOME\vimfiles\autoload\plug.vim"
New-Item -ItemType Directory "$HOME\vimfiles\pack\vim-c-env\start" -Force | Out-Null
New-Item -ItemType Junction "$HOME\vimfiles\pack\vim-c-env\start\vim-c-env" `
  -Target (Get-Location) | Out-Null
```

Відкрийте gVim і виконайте `:PlugInstall`, `:CocInstall coc-clangd coc-snippets`
та `:helptags ALL` (для `:Cheatsheet`). Конфіг сам перемикає оболонку на
`cmd.exe` у Windows.

### <img src="https://cdn.simpleicons.org/apple/000000/FFFFFF" height="20" alt=""> macOS

```bash
xcode-select --install          # компілятори і make
brew install vim node llvm bear git
```

Homebrew тримає clangd усередині keg `llvm`, поза стандартним `PATH`. Додайте
його:

```bash
echo 'export PATH="$(brew --prefix llvm)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Далі клонуйте й запустіть bootstrap, як у розділі
[Далі, на будь-якому дистрибутиві](#далі-на-будь-якому-дистрибутиві).

### Примітки

> **Де шукається clangd.** coc-clangd бере `clangd` з `PATH`. Якщо він
> встановлений деінде, додайте `"clangd.path"` у `coc-settings.json` зі
> значенням з `command -v clangd`.

> ⚠️ **Наявний конфіг.** `make install` замінює `~/.vimrc` і
> `~/.vim/coc-settings.json` **симлінками** на цей репозиторій. Спершу збережіть
> свої файли. `make uninstall` потім прибере лише ці симлінки.

---

## Видалення

```bash
make uninstall     # прибирає лише наші симлінки: ~/.vimrc, coc-settings.json, Vim-пакет, nvim init.vim
```

Плагіни в `~/.vimfiles/plugged`, vim-plug і розширення coc лишаються —
приберіть їх вручну, якщо хочете повністю очистити систему.
