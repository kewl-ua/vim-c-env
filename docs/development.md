# Development

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/development.md)

## Makefile targets

| Command | What it does |
|---------|--------------|
| `make` / `make help` | list the targets |
| `make doctor` | check Vim features, Node, clangd, bear, gdb and Neovim |
| `make install` | full bootstrap (`install.sh`) |
| `make link` | only symlink the config files and the Vim package (no plugins) |
| `make update` | `PlugUpdate` + `CocUpdate` |
| `make cheatsheet` | open `cheatsheet/index.html` in a browser |
| `make example` | build the example C project |
| `make example-arm` | build the Cortex-M4 example (needs `arm-none-eabi-gcc`) |
| `make test` | smoke-test the installed setup: Vim, Neovim, coc, clangd and the example |
| `make demos` | re-record the README gifs ([details](#recording-the-demos)) |
| `make clean` | remove the example build artifacts |
| `make uninstall` | remove the symlinks this repo created |

---

## Tests and CI

[`ci.yml`](../.github/workflows/ci.yml) runs on every push: shellcheck and vint,
the help page layout, then a clean `make install` and `make test` on Ubuntu and
macOS.

---

## Recording the demos

Every gif in this README comes from `scripts/record-demos.sh` (`make demos`).
It drives Vim through tmux with this repo's config, records with asciinema and
renders with agg. It works on a scratch copy of `example/`, so the repo stays
untouched. `scripts/record-demos.sh hover git` re-records only those two. The
debugger demo uses the Docker image when the local Vim lacks `+terminal`.

---

## Repository layout

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
│   └── record-demos.sh   # re-records the README gifs (make demos)
├── _config.yml           # GitHub Pages / SEO settings
├── assets/               # demo gifs + social preview image
├── UltiSnips/
│   └── c.snippets        # C snippets for coc-snippets
├── doc/
│   └── vim-c-env.txt     # cheatsheet as a Vim help page (:Cheatsheet)
├── plugin/
│   └── vim-c-env.vim     # defines :Cheatsheet and \?
├── cheatsheet/
│   └── index.html        # visual cheatsheet (gruvbox)
├── example-arm/          # bare-metal STM32F407 blink (Cortex-M4)
├── example/
│   ├── main.c            # demo project
│   ├── Makefile          # build (via bear when present)
│   └── .clang-format     # formatting style
├── docs/                 # this documentation (docs/uk/: Ukrainian)
├── README.md
├── README.uk.md          # this README in Ukrainian
└── LICENSE               # GNU GPL v3
```

**Plugins** (vim-plug): coc.nvim, NERDTree, fzf + fzf.vim, vim-airline (+themes),
gruvbox, nerdcommenter, vim-surround, vim-sensible, vim-fugitive, vim-gitgutter.
Built in: Termdebug. coc extensions: coc-clangd, coc-snippets.
