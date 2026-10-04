#!/usr/bin/env bash
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

echo ">> installing vim-plug (if missing)"
PLUG="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$PLUG" ]; then
  curl -fLo "$PLUG" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo ">> installing plugins (headless)"
vim -Es -u "$HOME/.vimrc" -c 'PlugInstall --sync' -c 'qa' </dev/null || true

echo ">> installing coc-clangd (headless)"
vim -Es -u "$HOME/.vimrc" -c 'CocInstall -sync coc-clangd' -c 'qa' </dev/null || true

echo
echo "Done. Make sure clangd is installed and on PATH:"
echo "  clangd --version"
echo "If it is elsewhere, edit \"clangd.path\" in coc-settings.json."
