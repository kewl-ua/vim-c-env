#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Bootstrap this Vim environment:
#   - symlink vimrc + coc-settings.json into place
#   - install vim-plug, then the plugins, then coc-clangd
#
# clangd and bear are system packages — install them with your distro's
# package manager (see README). This script does not touch them.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ">> symlinking config"
ln -sf "$HERE/vimrc" "$HOME/.vimrc"
mkdir -p "$HOME/.vim"
ln -sf "$HERE/coc-settings.json" "$HOME/.vim/coc-settings.json"

echo ">> registering the repo as a Vim package (:Cheatsheet, :help vim-c-env)"
mkdir -p "$HOME/.vim/pack/vim-c-env/start"
ln -sfn "$HERE" "$HOME/.vim/pack/vim-c-env/start/vim-c-env"
vim -Es -u NONE -c "helptags $HERE/doc" -c 'qa' </dev/null || true

if command -v nvim >/dev/null 2>&1; then
  NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  if [ -L "$NVIM_DIR/init.vim" ] || { [ ! -e "$NVIM_DIR/init.vim" ] && [ ! -e "$NVIM_DIR/init.lua" ]; }; then
    echo ">> linking the Neovim config"
    mkdir -p "$NVIM_DIR"
    ln -sfn "$HERE/nvim/init.vim" "$NVIM_DIR/init.vim"
  else
    echo ">> $NVIM_DIR already has a config; left alone (see README, Neovim)"
  fi
fi

echo ">> installing vim-plug (if missing)"
PLUG="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG" ]; then
  curl -fLo "$PLUG" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo ">> installing plugins (headless)"
vim -Es -u "$HOME/.vimrc" -c 'PlugInstall --sync' -c 'qa' </dev/null || true

echo ">> installing coc-clangd and coc-snippets (headless)"
vim -Es -u "$HOME/.vimrc" -c 'CocInstall -sync coc-clangd coc-snippets' -c 'qa' </dev/null || true

echo
echo "Done. Make sure clangd is installed and on PATH:"
echo "  clangd --version"
echo "If it is elsewhere, edit \"clangd.path\" in coc-settings.json."
