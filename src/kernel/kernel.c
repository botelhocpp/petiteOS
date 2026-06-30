#include "kernel.h"

void kernel_main(void) {
    idt_init();
    pic_init();

    interrupt_enable();

    terminal_clear();
    terminal_puts("[pOS] Booting petiteOS...\n");

    while(1);
}
