# Embedded (ARM Cortex-M)

[← vim-c-env](../README.md) · [All docs](README.md) · **English** · [Українська](uk/embedded.md)

The same setup works for microcontroller firmware. `example-arm/` is a minimal
bare-metal project for an STM32F407 (STM32F4-Discovery) that blinks the green
LED on PD12: register-level `main.c`, a `startup.c` with the vector table, and a
linker script.

```bash
sudo apt install gcc-arm-none-eabi libnewlib-arm-none-eabi stlink-tools
cd example-arm
bear -- make          # blink.elf, blink.bin and compile_commands.json
make flash            # write blink.bin with st-flash
vim main.c
```

**Why `--query-driver`.** `coc-settings.json` starts clangd with
`--query-driver=**/arm-none-eabi-*`. That lets clangd ask the cross compiler
for its own include paths. Without it, clangd can't find the toolchain's newlib
headers (`<string.h>`, `<stdlib.h>`, everything HAL and CMSIS pull in) and
marks the code red. Checked with `clangd --check` on a file that includes them:

| clangd flags | Result |
|--------------|--------|
| default | 3 errors (`'string.h' file not found`, ...) |
| `--query-driver=**/arm-none-eabi-*` | 0 errors |

The pattern only lets clangd run compilers whose name starts with
`arm-none-eabi-`. For another toolchain, add its pattern to the same flag,
comma-separated, for example `**/riscv64-unknown-elf-*`.
