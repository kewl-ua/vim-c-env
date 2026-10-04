/* SPDX-License-Identifier: GPL-3.0-or-later
 * Minimal Cortex-M startup: vector table, .data copy, .bss clear. */
#include <stdint.h>

extern uint32_t _estack, _sidata, _sdata, _edata, _sbss, _ebss;
int main(void);

void Reset_Handler(void)
{
    uint32_t *src = &_sidata;
    for (uint32_t *dst = &_sdata; dst < &_edata;)
        *dst++ = *src++;
    for (uint32_t *dst = &_sbss; dst < &_ebss;)
        *dst++ = 0;
    main();
    for (;;) {
    }
}

void Default_Handler(void)
{
    for (;;) {
    }
}

__attribute__((section(".isr_vector"), used))
static void (*const vectors[])(void) = {
    (void (*)(void))&_estack,   /* initial stack pointer */
    Reset_Handler,              /* reset */
    Default_Handler,            /* NMI */
    Default_Handler,            /* HardFault */
};
