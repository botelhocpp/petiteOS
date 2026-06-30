#ifndef KERNEL_H
#define KERNEL_H

#include "interrupt/idt.h"
#include "interrupt/pic.h"
#include "core/core.h"
#include "display/vga.h"
#include "display/terminal.h"

void kernel_main(void);

#endif // KERNEL_H
