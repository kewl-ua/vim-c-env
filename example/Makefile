# Example C project — demonstrates the clangd workflow.
#   make            build ./demo (via bear if present, so clangd gets flags)
#   make clean      remove build artifacts
CC     = gcc
CFLAGS = -Wall -Wextra -std=c11 -g
TARGET = demo

# Use bear to capture compile_commands.json when it is installed,
# otherwise just build normally.
BEAR := $(shell command -v bear 2>/dev/null)

$(TARGET): main.c
ifeq ($(BEAR),)
	$(CC) $(CFLAGS) -o $(TARGET) main.c
	@echo "note: 'bear' not found — no compile_commands.json generated"
else
	$(BEAR) -- $(CC) $(CFLAGS) -o $(TARGET) main.c
endif

clean:
	rm -f $(TARGET) compile_commands.json
	rm -rf .cache

.PHONY: clean
