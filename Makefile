# SPDX-License-Identifier: GPL-3.0-or-later
# vim-c-env — management targets.
# Run `make` (or `make help`) to list them.
VIM ?= vim
PACKDIR := $(HOME)/.vim/pack/vim-c-env/start
.DEFAULT_GOAL := help

.PHONY: help install link update doctor cheatsheet example example-arm demos clean uninstall

help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## full bootstrap: symlinks + vim-plug + plugins + coc-clangd
	@./install.sh

link: ## only symlink vimrc + coc-settings.json into place
	@ln -sf "$(CURDIR)/vimrc" "$(HOME)/.vimrc"
	@mkdir -p "$(HOME)/.vim"
	@ln -sf "$(CURDIR)/coc-settings.json" "$(HOME)/.vim/coc-settings.json"
	@mkdir -p "$(PACKDIR)"
	@ln -sfn "$(CURDIR)" "$(PACKDIR)/vim-c-env"
	@$(VIM) -Es -u NONE -c "helptags $(CURDIR)/doc" -c 'qa' </dev/null || true
	@echo "linked ~/.vimrc, ~/.vim/coc-settings.json and the Vim package -> $(CURDIR)"

update: ## update plugins (PlugUpdate) and coc extensions (CocUpdate)
	@$(VIM) -Es -u "$(HOME)/.vimrc" -c 'PlugUpdate --sync' -c 'qa' </dev/null || true
	@$(VIM) -Es -u "$(HOME)/.vimrc" -c 'CocUpdate' -c 'qa' </dev/null || true
	@echo "plugins and coc extensions updated"

doctor: ## check that required tools are present
	@echo "vim    : $$(command -v $(VIM) || echo MISSING)"
	@$(VIM) --version 2>/dev/null | grep -q '+job'    && echo "  +job     ok" || echo "  +job     MISSING"
	@$(VIM) --version 2>/dev/null | grep -q '+timers' && echo "  +timers  ok" || echo "  +timers  MISSING"
	@$(VIM) --version 2>/dev/null | grep -q '+channel'&& echo "  +channel ok" || echo "  +channel MISSING"
	@echo "node   : $$(command -v node   || echo MISSING) $$(node --version 2>/dev/null)"
	@echo "clangd : $$(command -v clangd || echo MISSING) $$(clangd --version 2>/dev/null | head -1)"
	@echo "bear   : $$(command -v bear   || echo 'MISSING (optional)')"
	@echo "gdb    : $$(command -v gdb    || echo 'MISSING (optional, for debugging)')"
	@$(VIM) --version 2>/dev/null | grep -q '+terminal' && echo "  +terminal ok (debugging)" || echo "  +terminal MISSING (optional, needed for :Termdebug)"

cheatsheet: ## open the HTML cheatsheet in a browser
	@xdg-open cheatsheet/index.html 2>/dev/null \
	  || open cheatsheet/index.html 2>/dev/null \
	  || echo "open cheatsheet/index.html manually"

example: ## build the example C project (uses bear if present)
	@$(MAKE) --no-print-directory -C example

example-arm: ## build the Cortex-M4 example (needs arm-none-eabi-gcc)
	@$(MAKE) --no-print-directory -C example-arm

demos: ## re-record the README gifs (needs tmux, asciinema, agg)
	@scripts/record-demos.sh

clean: ## remove example build artifacts
	@$(MAKE) --no-print-directory -C example clean
	@$(MAKE) --no-print-directory -C example-arm clean

uninstall: ## remove the symlinks this repo created (leaves plugins intact)
	@if [ -L "$(HOME)/.vimrc" ]; then rm -f "$(HOME)/.vimrc"; echo "removed ~/.vimrc symlink"; \
	  else echo "~/.vimrc is not our symlink — left alone"; fi
	@if [ -L "$(HOME)/.vim/coc-settings.json" ]; then rm -f "$(HOME)/.vim/coc-settings.json"; echo "removed coc-settings.json symlink"; \
	  else echo "~/.vim/coc-settings.json is not our symlink — left alone"; fi
	@if [ -L "$(PACKDIR)/vim-c-env" ]; then rm -f "$(PACKDIR)/vim-c-env"; echo "removed the Vim package symlink"; \
	  else echo "no Vim package symlink to remove"; fi
