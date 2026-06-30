#ifndef CORE_H
#define CORE_H

#include <stdint.h>

extern uint8_t inb(uint16_t port);

extern uint16_t inw(uint16_t port);

extern void outb(uint16_t port, uint8_t value);

extern void outw(uint16_t port, uint16_t value);

#define HALT() do { asm volatile("hlt"); } while(1)

#define CLI()       asm volatile("cli")

#define STI()       asm volatile("sti")

#endif // CORE_H