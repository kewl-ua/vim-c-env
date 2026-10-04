# SPDX-License-Identifier: GPL-3.0-or-later
# POSIX example: ./pipeline ls wc  ==  ls | wc
#   make            build ./pipeline (through bear when present)
#   make run        ./pipeline -v ls wc
#   make asan       build with AddressSanitizer + UBSan and run
#   make valgrind   run under valgrind: leaks, invalid reads and writes
#   make strace     show the pipe/fork/exec/dup2/wait system calls
CFLAGS = -std=c11 -D_POSIX_C_SOURCE=200809L -Wall -Wextra -Wpedantic -g
TARGET = pipeline
BEAR  := $(shell command -v bear 2>/dev/null)

$(TARGET): pipeline.c
ifeq ($(BEAR),)
	$(CC) $(CFLAGS) -o $@ $<
else
	$(BEAR) -- $(CC) $(CFLAGS) -o $@ $<
endif

run: $(TARGET)
	./$(TARGET) -v ls wc

asan: pipeline.c
	$(CC) $(CFLAGS) -fsanitize=address,undefined -fno-omit-frame-pointer -o $(TARGET)-asan $<
	./$(TARGET)-asan -v ls wc

valgrind: $(TARGET)
	valgrind --leak-check=full --error-exitcode=1 ./$(TARGET) ls wc

strace: $(TARGET)
	strace -f -e trace=pipe,pipe2,clone,clone3,fork,vfork,execve,dup2,dup3,wait4 ./$(TARGET) ls wc

clean:
	rm -f $(TARGET) $(TARGET)-asan compile_commands.json

.PHONY: run asan valgrind strace clean
