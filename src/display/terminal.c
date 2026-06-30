#include "terminal.h"

#include "vga.h"

static int terminal_x = 0;
static int terminal_y = 0;

void terminal_puts(const char *str) {
    for(int i = 0; str[i] != '\0'; i++) {
        terminal_putc(str[i]);
    }
}

void terminal_putc(char c) {
    if(c == '\n') {
        terminal_x = 0;
        terminal_y++;
        return;
    }

    vga_putc(c, VGA_WHITE_COLOR, VGA_BLACK_COLOR, terminal_x, terminal_y);

    /* Word-wrap */
    if(++terminal_x >= VGA_WIDTH) {
        terminal_x = 0;
        terminal_y++;
    }
}

void terminal_clear(void) {
    vga_clear(VGA_BLACK_COLOR);
}