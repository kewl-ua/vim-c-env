# Troubleshooting

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/troubleshooting.md)

| Symptom | Cause / fix |
|---------|-------------|
| No completion | `:CocInfo` — clangd should be green; `:CocList extensions` — is coc-clangd there |
| `clangd: command not found` in `:CocInfo` | install clangd (see [Installation](installation.md#installation)) or add `"clangd.path"` to `coc-settings.json` |
| Complains about `#include "my.h"` | no `compile_commands.json` / `compile_flags.txt` — see [C workflow](c-workflow.md#c-workflow) |
| `Tab` inserts a tab instead of completing | make sure the coc block in `vimrc` is present and the coc client is running (`:CocInfo`) |
| `\dd` says Vim needs `+terminal` | Vim 9.1's Termdebug fails without it. Install a full build (`vim-nox`, `vim-gtk3`; Gentoo: `USE=terminal`) or use Neovim |
| Nothing starts | `vim --version \| grep +job` must show `+job`; old Vim without `+job` can't run coc |
