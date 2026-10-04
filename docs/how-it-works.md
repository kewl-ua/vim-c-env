# How it works

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/how-it-works.md)

## Architecture

How the pieces talk to each other while you edit:

```mermaid
flowchart LR
    you["You editing<br/>main.c"] --> vim["Vim"]
    vim <-->|"LSP (JSON-RPC)"| coc["coc.nvim<br/>+ coc-clangd"]
    coc <--> clangd["clangd"]
    clangd -->|reads| cc["compile_commands.json"]
    clangd -->|indexes| src["your .c / .h files"]
    clangd -.->|"completion, diagnostics,<br/>go-to, format"| vim
```

Vim is the editor, **coc.nvim** is the LSP client, **clangd** is the brain that
actually understands C. clangd learns your build flags from
`compile_commands.json` and indexes your sources, then feeds results back to Vim.

---

## What make install does

`install.sh` (or `make install`):

1. **Symlinks** `vimrc → ~/.vimrc` and `coc-settings.json → ~/.vim/coc-settings.json`.
   Edit the files in the repo and changes take effect immediately; `git pull`
   updates the config.
2. **vim-plug** is downloaded to `~/.vim/autoload/plug.vim` if missing.
3. **Plugins** are installed headless (`PlugInstall`). The plugin directory is
   `~/.vimfiles/plugged` (set in `vimrc`).
4. **coc-clangd** and **coc-snippets** are installed as coc extensions;
   coc-clangd starts the `clangd` it finds on your `PATH`, with the flags from
   `coc-settings.json`.
5. **The repo itself** is linked as a Vim package
   (`~/.vim/pack/vim-c-env/start/vim-c-env`), so Vim loads `plugin/` (the
   `:Cheatsheet` command) and `doc/` (the help page) automatically.
6. **Neovim**, if installed and not configured yet, gets
   `~/.config/nvim/init.vim` linked to `nvim/init.vim`.

clangd itself is a **system package** — the script does not touch it.

The bootstrap flow:

```mermaid
flowchart TD
    a["make install"] --> b["symlink vimrc + coc-settings.json"]
    b --> c{"vim-plug<br/>present?"}
    c -->|no| d["download plug.vim"]
    c -->|yes| e["PlugInstall (plugins)"]
    d --> e
    e --> f["CocInstall coc-clangd<br/>+ coc-snippets"]
    f --> g["ready to use"]
```

And what happens the moment you open a C file:

```mermaid
sequenceDiagram
    participant V as Vim
    participant C as coc.nvim
    participant D as clangd
    V->>C: open main.c
    C->>D: initialize + didOpen
    D->>D: read compile_commands.json, index
    D-->>V: diagnostics (underlines)
    V->>C: type "pri"
    C->>D: completion request
    D-->>V: printf, putchar, ...
```
