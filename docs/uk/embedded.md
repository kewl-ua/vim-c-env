# Вбудовані системи (ARM Cortex-M)

[← vim-c-env](../../README.uk.md) · [Уся документація](README.md) · [English](../embedded.md) · **Українська**

Той самий конфіг працює і для прошивок мікроконтролерів. `example-arm/` —
мінімальний bare-metal проєкт для STM32F407 (STM32F4-Discovery), що блимає
зеленим світлодіодом на PD12: `main.c` на рівні регістрів, `startup.c` з
таблицею векторів і лінкер-скрипт.

```bash
sudo apt install gcc-arm-none-eabi libnewlib-arm-none-eabi stlink-tools
cd example-arm
bear -- make          # blink.elf, blink.bin і compile_commands.json
make flash            # записати blink.bin через st-flash
vim main.c
```

**Навіщо `--query-driver`.** `coc-settings.json` запускає clangd з
`--query-driver=**/arm-none-eabi-*`. Так clangd може спитати в крос-компілятора
його власні шляхи до заголовків. Без цього clangd не знаходить заголовки newlib
з тулчейна (`<string.h>`, `<stdlib.h>` і все, що тягнуть HAL і CMSIS) і
підсвічує код червоним. Перевірено через `clangd --check` на файлі, що їх
підключає:

| Прапорці clangd | Результат |
|-----------------|-----------|
| за замовчуванням | 3 помилки (`'string.h' file not found`, ...) |
| `--query-driver=**/arm-none-eabi-*` | 0 помилок |

Шаблон дозволяє clangd запускати лише компілятори, чия назва починається з
`arm-none-eabi-`. Для іншого тулчейна додайте його шаблон у той самий прапорець
через кому, наприклад `**/riscv64-unknown-elf-*`.
