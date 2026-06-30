#ifndef PIC_H
#define PIC_H

#define PIC1            (0x20)
#define PIC1_CMD        (PIC1 + 0)
#define PIC1_DATA       (PIC1 + 1)

#define PIC2            (0xA0)
#define PIC2_CMD        (PIC2 + 0)
#define PIC2_DATA       (PIC2 + 1)

#define PIC_INIT        (0x11)
#define PIC_8086_MODE   (0x01)
#define PIC1_IRQ_OFFSET (0x20)
#define PIC2_IRQ_OFFSET (0x28)

#define PIC_CASCADE_IRQ (0x2)

#define PIC_EOI         (0x20)

/* Remap PIC IRQs to INT 0x20. */
void pic_init(void);

#endif // PIC_H
