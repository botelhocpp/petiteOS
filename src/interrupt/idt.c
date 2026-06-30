#include "idt.h"

#include "interrupt/pic.h"
#include "core/core.h"
#include "kernel/config.h"
#include "memory/memory.h"
#include "display/terminal.h"

#define PRESENT_INTERRUPT       (1U << 7)
#define PRIVILEGE_LEVEL_RING0   (0b00 << 5)
#define PRIVILEGE_LEVEL_RING3   (0b11 << 5)
#define INTERRUPT_GATE_32B      (0x0E)
#define TRAP_GATE_32B           (0x0F)

extern void idt_load(idtr_desc *idtr_ptr);

extern void int_20h(void);

extern void int_21h(void);

extern void no_interrupt(void);

/* PIT ISR */
extern void int_20h_handler(void) {
    outb(PIC1_CMD, PIC_EOI);
}

/* Keyboard ISR */
extern void int_21h_handler(void) {
    char c = inb(0x60);

    terminal_putc(c);

    outb(PIC1_CMD, PIC_EOI);
}

extern void no_interrupt_handler(void) {
    outb(PIC1_CMD, PIC_EOI);
}

static idt_desc idt_descriptors[KERNEL_TOTAL_INTERRUPTS];

static idtr_desc idtr_descriptor;

static void idt_divide_by_zero_handler(void) {
    terminal_puts("[pOS] exception thrown: divide by zero.\n");

    HALT();
}

void idt_set(int irq_num, void *idt_addr) {
    idt_desc *desc = &idt_descriptors[irq_num];

    desc->offset_1 = ((uint32_t) idt_addr) & 0xFFFF;
    desc->selector = KERNEL_CODE_SELECTOR;
    desc->zero = 0x00;
    desc->type_attr = PRESENT_INTERRUPT | PRIVILEGE_LEVEL_RING3 | INTERRUPT_GATE_32B;
    desc->offset_2 = (((uint32_t) idt_addr) >> 16) & 0xFFFF;
}

void idt_init(void) {
    memset(idt_descriptors, 0, sizeof(idt_descriptors));

    idtr_descriptor.limit = sizeof(idt_descriptors) - 1;
    idtr_descriptor.base = (uint32_t) &idt_descriptors;

    for(int i = 0; i < KERNEL_TOTAL_INTERRUPTS; i++) {
        idt_set(i, &no_interrupt);
    }

    idt_set(IDT_INT(0x0), &idt_divide_by_zero_handler);
    idt_set(IDT_INT(0x20), &int_20h);
    idt_set(IDT_INT(0x21), &int_21h);

    idt_load(&idtr_descriptor);
}
