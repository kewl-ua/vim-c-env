# Installation

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/installation.md)

## Requirements

| Tool | Why | Check |
|------|-----|-------|
| <img src="https://cdn.simpleicons.org/vim" height="14" alt=""> Vim 8.2+ with `+job +timers +channel` | async LSP | `vim --version \| grep +job` |
| <img src="https://cdn.simpleicons.org/nodedotjs" height="14" alt=""> Node.js ≥ 16 | coc.nvim runtime | `node --version` |
| <img src="https://cdn.simpleicons.org/llvm/262D3A/C9CDD6" height="14" alt=""> clangd | C/C++ language server | `clangd --version` |
| bear *(optional)* | generates `compile_commands.json` from `make` | `bear --version` |
| gdb *(optional)* | debugger behind `:Termdebug`; Vim also needs `+terminal` | `gdb --version` |
| <img src="https://cdn.simpleicons.org/git" height="14" alt=""> git, <img src="https://cdn.simpleicons.org/curl/073551/7FB3D5" height="14" alt=""> curl | clone + download vim-plug | — |

Check everything at once with **`make doctor`**. Per-OS setup is in
[Installation](#installation).

---

## Installation

These steps assume a freshly installed OS. Install the prerequisites for your
platform, then clone the repo and run the bootstrap.

### <img src="https://cdn.simpleicons.org/linux" height="20" alt=""> Linux

Prerequisites: Vim built with `+job`, Node.js, clangd, bear, git, curl.

#### <img src="https://cdn.simpleicons.org/debian" height="18" alt=""> Debian / <img src="https://cdn.simpleicons.org/ubuntu" height="18" alt=""> Ubuntu

```bash
sudo apt update
sudo apt install -y vim-nox nodejs npm clangd bear gdb git curl
```

Install `vim-nox` (or `vim-gtk3`). The minimal `vim-tiny` has no `+job`, and
coc.nvim needs it.

#### <img src="https://cdn.simpleicons.org/fedora" height="18" alt=""> Fedora

```bash
sudo dnf install -y vim-enhanced nodejs clang-tools-extra bear gdb git curl
```

clangd ships in `clang-tools-extra`.

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

The `terminal` USE flag gives Vim the `+terminal` feature that the debugger
needs.

For UNIX system programming (man pages, Valgrind, strace) see the extra
packages in [UNIX programming](unix.md#tools-to-install).

#### Then, on any distro

```bash
git clone git@github.com:kewl-ua/vim-c-env.git
cd vim-c-env
make doctor      # verify that every tool is found
make install     # symlinks + vim-plug + plugins + coc-clangd
make example     # optional: build the demo project
vim example/main.c
```

`make doctor` reports every prerequisite, and `make example` builds the demo
through bear:

![make doctor and make example](../assets/doctor.gif)

### <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/windows11/windows11-original.svg" height="20" alt=""> Windows

#### Recommended: WSL2

WSL2 runs a real Linux, so the Linux steps work unchanged. In an admin
PowerShell:

```powershell
wsl --install -d Ubuntu
```

Reboot, open **Ubuntu** from the Start menu, then follow the **Debian / Ubuntu**
steps above inside it.

#### Native Windows (gVim)

```powershell
winget install vim.vim OpenJS.NodeJS LLVM.LLVM Git.Git
```

`install.sh` is a bash script and doesn't run on native Windows, so copy the
files by hand. From the cloned repo, in PowerShell:

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

Open gVim and run `:PlugInstall`, `:CocInstall coc-clangd coc-snippets` and
`:helptags ALL` (for `:Cheatsheet`). The config already switches the shell to
`cmd.exe` on Windows.

### <img src="https://cdn.simpleicons.org/apple/000000/FFFFFF" height="20" alt=""> macOS

```bash
xcode-select --install          # compilers and make
brew install vim node llvm bear git
```

Homebrew keeps clangd inside the `llvm` keg, off the default `PATH`. Add it:

```bash
echo 'export PATH="$(brew --prefix llvm)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Then clone and bootstrap as in [Then, on any distro](#then-on-any-distro).

### Notes

> **Where clangd is found.** coc-clangd uses the `clangd` on your `PATH`. If
> yours lives elsewhere, add `"clangd.path"` to `coc-settings.json` and set it
> to the output of `command -v clangd`.

> ⚠️ **Existing config.** `make install` replaces `~/.vimrc` and
> `~/.vim/coc-settings.json` with **symlinks** into this repo. Back up your own
> files first. `make uninstall` later removes only those symlinks.

---

## Uninstall

```bash
make uninstall     # removes only our symlinks: ~/.vimrc, coc-settings.json, the Vim package, nvim init.vim
```

Plugins in `~/.vimfiles/plugged`, vim-plug, and coc extensions stay — remove them
by hand if you want a clean slate.
