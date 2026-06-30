#include "pic.h"

#include "core/core.h"

void pic_init(void) {
    /* ICW1 - Init in cascade mode */
    outb(PIC1_CMD, PIC_INIT);
    outb(PIC2_CMD, PIC_INIT);

    /* ICW2 - Map IRQs to 0x20 (PIC1) and 0x28 (PIC2)  */
    outb(PIC1_DATA, PIC1_IRQ_OFFSET);
    outb(PIC2_DATA, PIC2_IRQ_OFFSET);

    /* ICW3 - Cascade */
    outb(PIC1_DATA, (1 << PIC_CASCADE_IRQ));
    outb(PIC2_DATA, PIC_CASCADE_IRQ);

    /* ICW4 - x86 Mode */
    outb(PIC1_DATA, PIC_8086_MODE);
    outb(PIC2_DATA, PIC_8086_MODE);

    /* Unmask both PICs */
    outb(PIC1_DATA, 0x00);
    outb(PIC2_DATA, 0x00);
}
