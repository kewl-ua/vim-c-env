# Вбудовані системи: ARM Cortex-M і ESP32

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

---

## ESP32 (ESP-IDF)

`example-esp32/` — проєкт ESP-IDF 5.3+/6.x: FreeRTOS-задача, що блимає
світлодіодом, для будь-якого чипа ESP32. Щоб clangd на ньому працював, треба
три речі. Усе перевірено на ESP-IDF 6.1 в Docker-образі Espressif:

1. **Прапорці.** У `compile_commands.json` від ESP-IDF є прапорці, які розуміє
   лише GCC (`-fno-shrink-wrap`, `-fstrict-volatile-bitfields`, `-mlongcalls`,
   ...), і clangd на них лається.
2. **Xtensa.** Звичайний clangd не знає таргет Xtensa (ESP32, S2, S3), а clangd
   від Espressif знає. `. $IDF_PATH/export.sh` додає його в `PATH`, а
   coc-clangd бере `clangd` саме звідти.
3. **Вбудовані заголовки.** Пакет clangd від Espressif постачається без
   вбудованих заголовків clang, тож навіть `<stdbool.h>` «не знайдено». Вони є в
   тулчейні `esp-clang`.

`scripts/esp-clangd-setup.sh` закриває всі три пункти: за потреби встановлює
`esp-clang` і `esp-clangd` та пише `.clangd`, який прибирає GCC-only прапорці й
вказує clangd на вбудовані заголовки.

```bash
. "$IDF_PATH/export.sh"
cd example-esp32                  # або ваш ESP-IDF-проєкт
idf.py set-target esp32s3 && idf.py build
~/path/to/vim-c-env/scripts/esp-clangd-setup.sh
vim main/main.c                   # з цього ж shell
```

clangd сам знаходить `build/compile_commands.json`. Результати на `main.c`:

| Чип | Ядро | До | Після скрипта |
|-----|------|----|---------------|
| ESP32 | Xtensa | 8 помилок | 0 |
| ESP32-S3 | Xtensa | 8 помилок | 0 |
| ESP32-C3 | RISC-V | 5 помилок, перевірка обірвалась | 0 |
| ESP32-C6 | RISC-V | 8 помилок | 0 |

В ESP-IDF-проєкті `\m` запускає `idf.py build` замість `make`, тож помилки
збірки так само потрапляють у quickfix. Прошивка й моніторинг порту —
`idf.py flash monitor` у терміналі. Сніпет `app_main` розгортається в точку
входу з FreeRTOS-задачею.
