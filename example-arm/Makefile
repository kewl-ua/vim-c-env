# SPDX-License-Identifier: GPL-3.0-or-later
# Bare-metal Cortex-M4 example (STM32F407).
#   bear -- make     build blink.elf / blink.bin and compile_commands.json
#   make flash       write blink.bin with st-flash (stlink tools)
PREFIX  ?= arm-none-eabi-
CC       = $(PREFIX)gcc
OBJCOPY  = $(PREFIX)objcopy
SIZE     = $(PREFIX)size

CPU      = -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard
CFLAGS   = $(CPU) -std=c11 -O2 -g -Wall -Wextra -ffreestanding -ffunction-sections
LDFLAGS  = $(CPU) -T stm32f407.ld -nostdlib -Wl,--gc-sections

SRCS     = main.c startup.c
OBJS     = $(SRCS:.c=.o)

all: blink.bin

blink.elf: $(OBJS) stm32f407.ld
	$(CC) $(LDFLAGS) -o $@ $(OBJS)
	$(SIZE) $@

blink.bin: blink.elf
	$(OBJCOPY) -O binary $< $@

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

flash: blink.bin
	st-flash write blink.bin 0x08000000

clean:
	rm -f $(OBJS) blink.elf blink.bin compile_commands.json

.PHONY: all flash clean
