#ifndef IDT_H
#define IDT_H

#include <stdint.h>

typedef struct __attribute__((packed)) {
        uint16_t limit;
        uint32_t base;
} idtr_desc;

typedef struct __attribute__((packed)) {
    uint16_t offset_1;  // Offset bits 0 - 15
    uint16_t selector;  // Selector thats in our GDT
    uint8_t zero;       // Does nothing, unused set to zero
    uint8_t type_attr;  // Descriptor type and attributes
    uint16_t offset_2;  // Offset bits 16-31
} idt_desc;

#define IDT_INT(x)      (x)

#define interrupt_enable()  STI()

#define interrupt_disable() CLI()

void idt_init(void);

void idt_set(int irq_num, void *idt_addr);

#endif // IDT_H