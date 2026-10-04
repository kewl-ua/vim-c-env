#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Re-record the README gifs from this repo's own config.
#
#   scripts/record-demos.sh               # every demo
#   scripts/record-demos.sh hover git     # only these
#
# Needs tmux, asciinema and agg, plus the plugins installed (make install).
# Vim runs with this repo's vimrc and coc-settings.json, on a scratch copy of
# example/, so the repo itself is never modified. The debugger demo needs Vim
# with +terminal; without it, that demo runs inside the vim-c-env Docker image
# (docker build -t vim-c-env .).
set -u

REPO="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$REPO/assets"
WORK="$(mktemp -d)"
W=92; H=28
DEMO=vce_demo; REC=vce_rec

cleanup() {
  tmux kill-session -t "$DEMO" 2>/dev/null
  tmux kill-session -t "$REC" 2>/dev/null
  if [ -n "${VCE_KEEP:-}" ]; then echo "kept: $WORK"; else rm -rf "$WORK"; fi
}
trap cleanup EXIT

export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"   # common agg locations
for tool in tmux asciinema agg vim; do
  command -v "$tool" >/dev/null || { echo "missing: $tool" >&2; exit 1; }
done

# Scratch copy of the example, with compile_commands.json for clangd.
cp -r "$REPO/example" "$WORK/example"
make -s -C "$WORK/example" >/dev/null 2>&1

VIM="vim -Nu '$REPO/vimrc' --cmd \"let g:coc_config_home='$REPO'\""
IN_EXAMPLE="cd '$WORK/example' &&"

send() { tmux send-keys -t "$DEMO" "$@"; }
quit() { send Escape; sleep 0.3; send -l ':qa!'; send Enter; }

# rec NAME LAUNCH DRIVER [WIDTH HEIGHT]
rec() {
  local name=$1 launch=$2 driver=$3 w=${4:-$W} h=${5:-$H}
  echo ">> $name"
  tmux kill-session -t "$DEMO" 2>/dev/null; tmux kill-session -t "$REC" 2>/dev/null
  tmux new-session -d -s "$DEMO" -x "$w" -y "$h" "$launch"
  tmux set-option -t "$DEMO" status off >/dev/null
  sleep 1.2
  tmux new-session -d -s "$REC" -x "$w" -y "$h" \
    "asciinema rec --overwrite -c 'tmux attach -r -t $DEMO' '$WORK/$name.cast'; tmux wait -S ${REC}_done"
  tmux set-option -t "$REC" status off >/dev/null
  sleep 1.5
  "$driver" & local pid=$!
  timeout 120 tmux wait "${REC}_done"
  wait "$pid" 2>/dev/null
  agg --idle-time-limit 1.0 --speed 1.2 --font-size 15 "$WORK/$name.cast" "$OUT/$name.gif" >/dev/null 2>&1
  printf '   %s\n' "$(du -h "$OUT/$name.gif" | cut -f1)"
}

# ---------------------------------------------------------------- drivers --
# Searches target real symbols: the comment in main.c also mentions
# project_t and banner, and clangd has nothing to resolve inside a comment.

d_demo() { sleep 7
  send -l 'G'; sleep 0.8
  send -l '?banner(&self)'; send Enter; sleep 1.8
  send -l 'gd'; sleep 2.8
  send C-o; sleep 2.0
  send -l '/project_t self'; send Enter; sleep 1.1
  send -l 'K'; sleep 3.2
  send Escape; sleep 1.0
  send -l '/return 0'; send Enter; sleep 0.9
  send -l 'O'; sleep 0.7
  send -l 'pri'; sleep 2.6
  send Escape; sleep 1.1
  send -l 'u'; sleep 1.4
  send -l '\f'; sleep 2.8; quit; }

d_completion() { sleep 6.5
  send -l '/return 0'; send Enter; sleep 0.8
  send -l 'O'; sleep 0.6
  send -l 'self.'; sleep 1.9
  send Tab; sleep 0.9
  send Enter; sleep 1.3
  send Escape; sleep 1.0
  send -l 'uuu'; sleep 0.8; quit; }

d_navigation() { sleep 6.5
  send -l 'G'; sleep 0.4
  send -l '?banner(&self)'; send Enter; sleep 1.4
  send -l 'gd'; sleep 2.3
  send C-o; sleep 1.8
  send -l '/project_t self'; send Enter; sleep 1.0
  send -l 'gr'; sleep 3.2
  send Escape; sleep 1.0; quit; }

d_hover() { sleep 6.5
  send -l '/banner(&self)'; send Enter; sleep 1.0
  send -l 'K'; sleep 3.0
  send Escape; sleep 0.9
  send -l '/strlen'; send Enter; sleep 0.9
  send -l 'K'; sleep 3.0
  send Escape; sleep 0.7; quit; }

d_diagnostics() { sleep 6.5
  send -l 'G'; sleep 0.4
  send -l 'O'; sleep 0.5
  send -l 'oopsie_undeclared;'; sleep 0.3
  send Escape; sleep 3.3
  send -l ']g'; sleep 3.2
  send -l 'u'; sleep 1.3; quit; }

d_rename() { sleep 6.5
  send -l '/project_t self'; send Enter; sleep 1.0
  send -l '\rn'; sleep 1.6
  send C-u; sleep 0.4
  send -l 'widget_t'; send Enter; sleep 3.2
  send Escape; sleep 1.2; quit; }

d_format() { sleep 6.0
  send -l ':%s/    /        /g'; send Enter; sleep 1.5
  send -l ':noh'; send Enter; sleep 1.0
  send -l '\f'; sleep 3.6; quit; }

d_files() { sleep 3.5
  send C-n; sleep 1.8
  send -l '/Makefile'; send Enter; sleep 0.8
  send -l 'o'; sleep 1.8
  send C-n; sleep 1.5; quit; }

d_cheatsheet() { sleep 2.5
  send -l '\?'; sleep 2.4
  send -l '/|vim-c-env-completion|'; send Enter; sleep 0.9
  send -l 'l'; sleep 0.3
  send C-]; sleep 2.6
  send C-o; sleep 1.6
  send -l '/|vim-c-env-debug|'; send Enter; sleep 0.8
  send -l 'l'; sleep 0.3
  send C-]; sleep 2.8
  send -l ':q'; send Enter; sleep 1.3; quit; }

d_snippets() { sleep 6.5
  send -l 'i'; sleep 0.3
  send -l 'inc'; send C-l; sleep 1.4
  send Escape; sleep 0.4
  send -l 'o'; send Enter; sleep 0.3
  send -l 'main'; send C-l; sleep 1.4
  send -l 'for'; send C-l; sleep 1.4
  send C-j; sleep 0.6
  send C-j; sleep 0.4
  send -l '3'; sleep 0.6
  send C-j; sleep 0.6
  send -l 'pr'; send C-l; sleep 1.2
  send -l '%zu'; sleep 0.6
  send C-j; sleep 0.3
  send C-j; sleep 0.4
  send -l 'i'; sleep 0.8
  send Escape; sleep 2.5; quit; }

d_build() { sleep 6.0
  send -l ':%s/return 0;/return oops;/'; send Enter; sleep 0.8
  send -l ':w'; send Enter; sleep 0.8
  send -l '\m'; sleep 4.0
  send Enter; sleep 2.0
  send -l 'u'; sleep 0.8
  send -l ':w'; send Enter; sleep 0.8
  send -l '\m'; sleep 4.0; quit; }

d_git() { sleep 6.0
  send -l '/vim-env"'; send Enter; sleep 0.6
  send -l 'ct"vim-c-env'; send Escape; sleep 0.5
  send -l 'G'; send -l 'O'; send -l '// TODO: read the name from argv'; send Escape; sleep 0.4
  send -l ':w'; send Enter; sleep 2.5
  send -l 'gg'; send -l ']c'; sleep 1.2
  send -l '\gp'; sleep 2.6
  send -l ':pclose'; send Enter; sleep 0.6
  send -l '\gg'; sleep 3.0
  send -l ':q'; send Enter; sleep 0.6; quit; }

d_debug() { sleep 4.0
  send -l '\dd'; send -l './demo'; send Enter; sleep 3.0
  send C-w; send -l 'p'; sleep 0.6
  send -l ':Source'; send Enter; sleep 0.8
  send -l '/banner(&self)'; send Enter; sleep 0.8
  send -l '\db'; sleep 1.0
  send -l '\dr'; sleep 2.8
  send -l '\ds'; sleep 2.2
  send -l '\dn'; sleep 2.2
  send -l '/p->name'; send Enter; sleep 0.6
  send -l '\de'; sleep 2.8
  send -l '\dc'; sleep 2.5
  send -l ':qa!'; send Enter; sleep 0.5; send Enter; }

d_doctor() { sleep 1.3
  send -l 'make doctor'; send Enter; sleep 3.0
  send -l 'make example'; send Enter; sleep 3.0
  send -l 'exit'; send Enter; }

# ------------------------------------------------------------------ runs --
git_scratch() {
  ( cd "$WORK/example" && git init -q && git add -A \
      && git -c user.name=demo -c user.email=demo@example.invalid commit -qm init )
}

run() {
  case $1 in
    demo|completion|navigation|hover|diagnostics|rename|format|files|cheatsheet|build)
      rec "$1" "$IN_EXAMPLE $VIM main.c" "d_$1" ;;
    snippets)
      rec snippets "$IN_EXAMPLE $VIM prog.c" d_snippets ;;
    git)
      git_scratch
      rec git "$IN_EXAMPLE $VIM main.c" d_git ;;
    debug)
      if vim --version | grep -q '+terminal'; then
        rec debug "$IN_EXAMPLE $VIM main.c" d_debug 110 34
      elif docker image inspect vim-c-env >/dev/null 2>&1; then
        rec debug "docker run --rm -it -w /home/dev/vim-c-env/example vim-c-env vim main.c" d_debug 110 34
      else
        echo ">> debug: skipped (needs Vim with +terminal or the vim-c-env Docker image)"
      fi ;;
    doctor)
      rec doctor "cd '$REPO' && exec env PS1='\\w\\$ ' bash --norc -i" d_doctor ;;
    *) echo "unknown demo: $1" >&2 ;;
  esac
}

ALL="demo completion navigation hover diagnostics rename format files cheatsheet snippets build git debug doctor"
mkdir -p "$OUT"
for name in ${@:-$ALL}; do run "$name"; done
