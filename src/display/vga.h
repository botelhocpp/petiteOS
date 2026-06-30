#ifndef VGA_H
#define VGA_H

#include <stdint.h>

#define VGA_BLACK_COLOR             (0x0)
#define VGA_WHITE_COLOR             (0xF)

#define VGA_WIDTH                   (80)
#define VGA_HEIGHT                  (25)

#define VGA_BUFFER                  ((uint16_t *) (0xB8000))
#define VGA_POS(_x, _y)             ((_y * VGA_WIDTH) + _x)
#define VGA_CHAR(_char, _bg, _fg)   ((((((_bg) & 0xF) << 4) | ((_fg) & 0xF)) << 8) | (_char))

void vga_puts(const char *str, int fg_color, int bg_color, int x, int y);

void vga_putc(char c, int fg_color, int bg_color, int x, int y);

void vga_clear(int bg_color);

#endif // VGA_H
