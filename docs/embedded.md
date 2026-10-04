# Embedded: ARM Cortex-M and ESP32

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

---

## ESP32 (ESP-IDF)

`example-esp32/` is an ESP-IDF 5.3+/6.x project: a FreeRTOS task that blinks an
LED, for any ESP32 chip. Three things make clangd work on it, all checked with
ESP-IDF 6.1 in Espressif's Docker image:

1. **Flags.** `compile_commands.json` from ESP-IDF carries GCC-only flags
   (`-fno-shrink-wrap`, `-fstrict-volatile-bitfields`, `-mlongcalls`, ...) that
   clangd rejects.
2. **Xtensa.** Upstream clangd doesn't know the Xtensa target (ESP32, S2, S3);
   Espressif's clangd does. `. $IDF_PATH/export.sh` puts it on `PATH`, and
   coc-clangd uses the `clangd` on `PATH`.
3. **Builtin headers.** Espressif's clangd package ships without clang's builtin
   headers, so even `<stdbool.h>` is "not found". They come from the
   `esp-clang` toolchain.

`scripts/esp-clangd-setup.sh` handles all three: it installs `esp-clang` and
`esp-clangd` if missing and writes a `.clangd` that drops the GCC-only flags and
points clangd at the builtin headers.

```bash
. "$IDF_PATH/export.sh"
cd example-esp32                  # or your own ESP-IDF project
idf.py set-target esp32s3 && idf.py build
~/path/to/vim-c-env/scripts/esp-clangd-setup.sh
vim main/main.c                   # from this same shell
```

clangd finds `build/compile_commands.json` by itself. Results on `main.c`:

| Chip | Core | Before | After the setup script |
|------|------|--------|------------------------|
| ESP32 | Xtensa | 8 errors | 0 |
| ESP32-S3 | Xtensa | 8 errors | 0 |
| ESP32-C3 | RISC-V | 5 errors, check aborted | 0 |
| ESP32-C6 | RISC-V | 8 errors | 0 |

In an ESP-IDF project `\m` runs `idf.py build` instead of `make`, so build
errors still land in quickfix. Flash and watch the serial output with
`idf.py flash monitor` in a terminal. The `app_main` snippet expands to an
entry point with a FreeRTOS task.
