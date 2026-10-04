# UNIX programming

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/unix.md)

The setup covers system programming on Linux, the BSDs and macOS: man pages in
Vim, POSIX-aware clangd, snippets for the usual system calls, and an example
wired up for sanitizers, Valgrind and strace.

## Man pages: `\k`

`\k` opens the man page for the word under the cursor in a split. It looks in
the C sections first, in this order: **3** (C library), **2** (system calls),
**3p** (POSIX), **7** (overviews). That matters because many C names are also
commands:

| Word | `:Man word` opens | `\k` opens |
|------|-------------------|------------|
| `printf` | printf(1), the shell command | printf(3) |
| `waitpid` | waitpid(1), a command | wait(2), where it is documented |

Searching section 3 alone isn't enough either: `man 3 fork` finds fork(3am), a
GNU Awk module. So `\k` accepts a page only when its section matches exactly,
and `fork` lands on fork(2).

Inside the man page, `CTRL-]` follows a reference such as `pipe(2)`, and `:q`
closes it. `K` stays clangd's hover, which shows the declaration from the
headers clangd actually used.

## POSIX feature macros

With a strict standard such as `-std=c11`, glibc hides everything that is not
ISO C: `getline`, `strdup`, `fileno`, `fork`'s friends. clangd then reports
"implicit declaration" errors even though the code is fine. Measured with
`clangd --check` on a small file that uses them:

| Flags | clangd result |
|-------|---------------|
| `-std=c11` | 4 errors |
| `-std=c11 -D_POSIX_C_SOURCE=200809L` | 0 errors |
| `-std=gnu11` | 0 errors |

Pick one: define `_POSIX_C_SOURCE` (portable POSIX.1-2008), `_GNU_SOURCE`
(everything glibc has), or use a `gnu` standard. Put it in `CFLAGS` so the
compiler and clangd agree, or at the top of the file with the `posix` snippet.

## Snippets

Type the trigger, then `Ctrl-l`; `Ctrl-j` / `Ctrl-k` move between fields.

| Trigger | Expands to |
|---------|------------|
| `posix` | `#define _POSIX_C_SOURCE 200809L` |
| `die` | a `die()` helper: `perror` and `exit(EXIT_FAILURE)` |
| `fork` | `fork()` with error, child and parent branches |
| `waitpid` | `waitpid()` plus `WIFEXITED` / `WEXITSTATUS` |
| `pipe` | `pipe()` with an error check |
| `sigaction` | a signal handler installed with `sigaction` |
| `getopt` | a `getopt()` option loop |
| `getline` | read a stream line by line, then free the buffer |
| `tcpserver` | `socket`, `SO_REUSEADDR`, `bind` and `listen` |

The full list is in [`UltiSnips/c.snippets`](../UltiSnips/c.snippets).

## The example

[`example-unix/pipeline.c`](../example-unix/pipeline.c) runs `cmd1 | cmd2`
itself: `pipe`, `fork`, `dup2`, `execlp`, `waitpid`, and `getopt` for `-v`.

```bash
cd example-unix
make run         # ./pipeline -v ls wc: the same as ls | wc, plus child exit codes
make asan        # rebuilt with AddressSanitizer and UBSan, then run
make valgrind    # leak and memory check
make strace      # the pipe/clone/dup2/execve/wait4 calls, per process
```

On this machine `make valgrind` reports 0 errors and 0 bytes in use at exit.
`compile_flags.txt` in the same folder shows how to give clangd flags without
any build system.

## Debugging processes

`\dd ./pipeline` starts gdb (see [Keybindings](keybindings.md)). By default gdb
stays with the parent after `fork`. To follow the child instead, type this in
the gdb window before running:

```
set follow-fork-mode child
set detach-on-fork off
```

## Tools to install

These are optional; `make doctor` reports which ones it finds.

| System | Command |
|--------|---------|
| Debian / Ubuntu | `sudo apt install manpages-dev manpages-posix-dev valgrind strace` |
| Fedora | `sudo dnf install man-pages valgrind strace` |
| Arch / Manjaro | `sudo pacman -S man-pages valgrind strace` |
| openSUSE | `sudo zypper install man-pages valgrind strace` |
| Gentoo | `sudo emerge sys-apps/man-pages sys-apps/man-pages-posix dev-debug/valgrind dev-debug/strace` |
| macOS | man pages ship with the system. Use `make asan` instead of Valgrind (not available on Apple Silicon) and `dtruss` instead of strace |
