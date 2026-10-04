# vim-c-env — Vim as a C/C++ IDE with clangd

**English** · [Українська](README.uk.md)

![Vim](https://img.shields.io/badge/Vim-019733?logo=vim&logoColor=white)
![C](https://img.shields.io/badge/C-A8B9CC?logo=c&logoColor=black)
![clangd](https://img.shields.io/badge/clangd-LLVM-262D3A?logo=llvm&logoColor=white)
![coc.nvim](https://img.shields.io/badge/LSP-coc.nvim-8BC34A)
![Node.js](https://img.shields.io/badge/Node.js-%E2%89%A516-5FA04E?logo=nodedotjs&logoColor=white)
![Platforms](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey)
[![CI](https://github.com/kewl-ua/vim-c-env/actions/workflows/ci.yml/badge.svg)](https://github.com/kewl-ua/vim-c-env/actions/workflows/ci.yml)
[![License: GPL v3](https://img.shields.io/badge/license-GPL--3.0-blue?logo=gnu&logoColor=white)](LICENSE)

A ready-made **Vim setup for C and C++**: the **clangd** language server wired
in through **coc.nvim**, plus snippets, builds into quickfix, **gdb** debugging
and git. One command installs it on Linux, macOS or Windows; it also runs in
Neovim and Docker.

![vim-c-env: Vim in the centre with clangd, coc.nvim, snippets, build, debugger, git, files, Neovim, Docker and ARM support around it](assets/hero.gif)

## Features

- **Code intelligence** from clangd: completion, go-to-definition, references,
  hover docs, live diagnostics, rename, code actions, clang-tidy.
- **Formatting** with clang-format, on demand or on save.
- **Snippets** for C: `main`, `for`, `guard`, `st`, `mal`, and more.
- **Build** with `make` from Vim; errors land in the quickfix list.
- **Debug** with gdb in Vim's Termdebug, with F5/F9/F10/F11 keys.
- **Git** status, blame, diff and per-hunk staging.
- **UNIX programming:** `\k` opens the right man page; POSIX snippets; an example
  set up for sanitizers, Valgrind and strace.
- **Embedded:** clangd sees the `arm-none-eabi` toolchain; an STM32 example is included.
- **Cheatsheet inside Vim:** `:Cheatsheet`.

In a real session:

![Vim with clangd: go-to-definition, hover, completion and clang-format](assets/demo.gif)

Every feature has its own gif in [Features in action](docs/features.md).

## Quick start

On Debian or Ubuntu (other systems: [Installation](docs/installation.md)):

```bash
sudo apt install -y vim-nox nodejs npm clangd bear gdb git curl
git clone git@github.com:kewl-ua/vim-c-env.git && cd vim-c-env
make install     # back up your ~/.vimrc first: it becomes a symlink
vim example/main.c
```

No install at all: `docker build -t vim-c-env . && docker run --rm -it vim-c-env`.

## Essential keys

Leader is `\`. All keys: [Keybindings](docs/keybindings.md), or `:Cheatsheet` in Vim.

| Key | Action | Key | Action |
|-----|--------|-----|--------|
| `gd` / `gr` | definition / references | `\rn` | rename |
| `K` | documentation | `\ca` | code action |
| `]g` / `[g` | next / previous diagnostic | `\f` | format |
| `Tab` / `Enter` | pick / accept completion | `\h` | `.c` ↔ `.h` |
| `Ctrl-l` | expand snippet | `\m` | make, errors to quickfix |
| `\dd ./prog` | start the debugger | `F9` / `F10` / `F11` | break / over / into |
| `Ctrl-n` | file tree | `\gg` | git status |
| `\k` | man page (C sections first) | `:Cheatsheet` | all keys inside Vim |

## Documentation

| | |
|-|-|
| [Installation](docs/installation.md) | Linux distros, Windows, macOS; uninstall |
| [Features in action](docs/features.md) | a gif for every feature |
| [Keybindings](docs/keybindings.md) | every mapping by topic |
| [C workflow](docs/c-workflow.md) | `compile_commands.json`, bear, CMake; the example |
| [UNIX programming](docs/unix.md) | man pages, POSIX flags, sanitizers, Valgrind, strace |
| [Embedded (ARM Cortex-M)](docs/embedded.md) | STM32 example, clangd `--query-driver` |
| [Customizing](docs/customizing.md) | common tweaks and the full config |
| [Troubleshooting](docs/troubleshooting.md) | symptoms and fixes |
| [Neovim](docs/neovim.md) · [Docker](docs/docker.md) | other ways to run it |
| [How it works](docs/how-it-works.md) · [Development](docs/development.md) | internals, tests, CI |

## License

[GNU GPL v3.0 or later](LICENSE). Copyright (C) 2026 kewl-ua.
