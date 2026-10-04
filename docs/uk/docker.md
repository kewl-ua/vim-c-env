# Docker

[← vim-c-env](../../README.uk.md) · [Уся документація](README.md) · [English](../docker.md) · **Українська**

Спробуйте все середовище, нічого не встановлюючи. В образі є Vim з `+terminal`
(тож дебагер працює), clangd, gdb, bear і ARM-тулчейн.

```bash
docker build -t vim-c-env .
docker run --rm -it vim-c-env                         # відкриває example/main.c
docker run --rm -it -v "$PWD":/work -w /work vim-c-env vim yourfile.c
```

Кожен тег релізу (`v*`) також публікує образ у GitHub Container Registry,
після того як усередині нього проходить `make test`:

```bash
docker run --rm -it ghcr.io/kewl-ua/vim-c-env
```
