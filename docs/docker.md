# Docker

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/docker.md)

Try the whole environment without installing anything. The image has Vim with
`+terminal` (so the debugger works), clangd, gdb, bear and the ARM toolchain.

```bash
docker build -t vim-c-env .
docker run --rm -it vim-c-env                         # opens example/main.c
docker run --rm -it -v "$PWD":/work -w /work vim-c-env vim yourfile.c
```

Each release tag (`v*`) also publishes the image to the GitHub Container
Registry, after `make test` passes inside it:

```bash
docker run --rm -it ghcr.io/kewl-ua/vim-c-env
```
