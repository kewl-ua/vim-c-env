/* SPDX-License-Identifier: GPL-3.0-or-later
 * Blink the green LED (PD12) on an STM32F4-Discovery, register level. */
#include <stdint.h>

#define RCC_BASE      0x40023800u
#define GPIOD_BASE    0x40020C00u

#define RCC_AHB1ENR   (*(volatile uint32_t *)(RCC_BASE + 0x30u))
#define GPIOD_MODER   (*(volatile uint32_t *)(GPIOD_BASE + 0x00u))
#define GPIOD_ODR     (*(volatile uint32_t *)(GPIOD_BASE + 0x14u))

#define LED_PIN       12u

static void delay(volatile uint32_t ticks)
{
    while (ticks--) {
    }
}

int main(void)
{
    RCC_AHB1ENR |= 1u << 3;                     /* clock for GPIOD */
    GPIOD_MODER &= ~(3u << (LED_PIN * 2u));     /* PD12 -> general output */
    GPIOD_MODER |= 1u << (LED_PIN * 2u);

    for (;;) {
        GPIOD_ODR ^= 1u << LED_PIN;
        delay(500000u);
    }
}
