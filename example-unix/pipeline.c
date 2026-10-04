/* SPDX-License-Identifier: GPL-3.0-or-later
 * pipeline: run "cmd1 | cmd2" with fork, pipe, dup2, exec and waitpid.
 *   ./pipeline ls wc        same as: ls | wc
 *   ./pipeline -v ls wc     also report each child's PID and exit code */
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static int verbose;

static void die(const char *msg)
{
    perror(msg);
    exit(EXIT_FAILURE);
}

/* Fork and exec cmd with one end of the pipe as its stdin or stdout. */
static pid_t spawn(const char *cmd, int fds[2], int stdio_fd)
{
    pid_t pid = fork();
    if (pid == -1)
        die("fork");
    if (pid == 0) {
        int end = (stdio_fd == STDOUT_FILENO) ? fds[1] : fds[0];
        if (dup2(end, stdio_fd) == -1)
            die("dup2");
        close(fds[0]);
        close(fds[1]);
        execlp(cmd, cmd, (char *)NULL);
        die(cmd); /* reached only if exec failed */
    }
    return pid;
}

static int reap(pid_t pid, const char *cmd)
{
    int status;
    if (waitpid(pid, &status, 0) == -1)
        die("waitpid");
    int code = WIFEXITED(status) ? WEXITSTATUS(status) : 128 + WTERMSIG(status);
    if (verbose)
        fprintf(stderr, "%s (pid %ld) exited with %d\n", cmd, (long)pid, code);
    return code;
}

int main(int argc, char *argv[])
{
    int opt;
    while ((opt = getopt(argc, argv, "v")) != -1) {
        switch (opt) {
        case 'v':
            verbose = 1;
            break;
        default:
            fprintf(stderr, "usage: %s [-v] cmd1 cmd2\n", argv[0]);
            return 2;
        }
    }
    if (argc - optind != 2) {
        fprintf(stderr, "usage: %s [-v] cmd1 cmd2\n", argv[0]);
        return 2;
    }
    const char *left = argv[optind];
    const char *right = argv[optind + 1];

    int fds[2];
    if (pipe(fds) == -1)
        die("pipe");
    pid_t writer = spawn(left, fds, STDOUT_FILENO);
    pid_t reader = spawn(right, fds, STDIN_FILENO);
    close(fds[0]);
    close(fds[1]);

    reap(writer, left);
    return reap(reader, right);
}
