# SPDX-License-Identifier: GPL-3.0-or-later
# vim-c-env in a container: try the whole setup without installing anything.
#
#   docker build -t vim-c-env .
#   docker run --rm -it vim-c-env                      # opens example/main.c
#   docker run --rm -it -v "$PWD":/work -w /work vim-c-env vim yourfile.c
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 TERM=xterm-256color

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      vim-nox nodejs npm clangd bear gdb make gcc libc6-dev git curl ca-certificates \
      gcc-arm-none-eabi libnewlib-arm-none-eabi \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash dev
USER dev
WORKDIR /home/dev

COPY --chown=dev:dev . /home/dev/vim-c-env
RUN cd vim-c-env && ./install.sh && make -C example >/dev/null

WORKDIR /home/dev/vim-c-env
CMD ["vim", "example/main.c"]
