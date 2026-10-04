#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Checks that an installed vim-c-env works. Used by CI and `make test`.
#
#   scripts/smoke-test.sh                  # test the installed ~/.vimrc
#   VIMRC=./vimrc COC_HOME=. scripts/smoke-test.sh   # test the repo's files
set -u

REPO="$(cd "$(dirname "$0")/.." && pwd)"
VIMRC="${VIMRC:-$HOME/.vimrc}"
OUT="$(mktemp)"
trap 'rm -f "$OUT"' EXIT
fail=0

report() { # name, command
  if eval "$2" >/dev/null 2>&1; then echo "ok   $1"; else echo "FAIL $1"; fail=1; fi
}

# 1. Vim-side checks (see scripts/smoke.vim)
coc_cmd=()
[ -n "${COC_HOME:-}" ] && coc_cmd=(--cmd "let g:coc_config_home='$COC_HOME'")
VCE_SMOKE_OUT="$OUT" vim -Nu "$VIMRC" "${coc_cmd[@]}" -Es \
  -S "$REPO/scripts/smoke.vim" </dev/null >/dev/null 2>&1
if [ -s "$OUT" ]; then
  cat "$OUT"
  grep -q '^FAIL' "$OUT" && fail=1
else
  echo "FAIL vim did not run scripts/smoke.vim"; fail=1
fi

# 2. coc extensions
EXT="$HOME/.config/coc/extensions/node_modules"
report "coc-clangd is installed" "[ -d '$EXT/coc-clangd' ]"
report "coc-snippets is installed" "[ -d '$EXT/coc-snippets' ]"

# 3. The example builds, runs, and clangd sees no errors in it
report "example builds" "make -s -C '$REPO/example'"
report "example runs" "'$REPO/example/demo' | grep -q 'Hello from'"
report "clangd --check example/main.c: 0 errors" \
  "cd '$REPO/example' && clangd --check=main.c 2>&1 | grep -q 'All checks completed, 0 errors'"

# 4. Help page layout
report "help page fits in 78 columns" "! awk 'length > 78 { bad = 1 } END { exit !bad }' '$REPO/doc/vim-c-env.txt'"

exit $fail
