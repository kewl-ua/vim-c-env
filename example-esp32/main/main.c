/* SPDX-License-Identifier: GPL-3.0-or-later
 * Blink an LED from a FreeRTOS task, on any ESP32 chip (Xtensa or RISC-V).
 * LED_GPIO is 2 on most ESP32 DevKits; change it for your board. */
#include <stdbool.h>

#include "driver/gpio.h"
#include "esp_log.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#define LED_GPIO GPIO_NUM_2

static const char *TAG = "blink";

static void blink_task(void *arg)
{
    (void)arg;
    bool on = false;
    for (;;) {
        gpio_set_level(LED_GPIO, on);
        ESP_LOGI(TAG, "LED %s", on ? "on" : "off");
        on = !on;
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

void app_main(void)
{
    gpio_reset_pin(LED_GPIO);
    gpio_set_direction(LED_GPIO, GPIO_MODE_OUTPUT);
    xTaskCreate(blink_task, "blink", 2048, NULL, 5, NULL);
}
