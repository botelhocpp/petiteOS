#include "vga.h"

void vga_puts(const char *str, int fg_color, int bg_color, int x, int y) {
    int x_pos = x;
    int y_pos = y;

    for(int i = 0; str[i] != '\0'; i++) {
        vga_putc(str[i], fg_color, bg_color, x_pos, y_pos);

        /* Word-wrap */
        if(++x_pos >= VGA_WIDTH) {
            x_pos = 0;
            y_pos++;
        }
    }
}

void vga_putc(char c, int fg_color, int bg_color, int x, int y) {
    const int pos = VGA_POS(x, y);

    VGA_BUFFER[pos] = VGA_CHAR(c, bg_color, fg_color);
}

void vga_clear(int bg_color) {
    for(int i = 0; i < VGA_WIDTH; i++) {
        for(int j = 0; j < VGA_HEIGHT; j++) {
        const int pos = VGA_POS(i, j);

            VGA_BUFFER[pos] = VGA_CHAR('\0', bg_color, bg_color);
        }
    }
}
