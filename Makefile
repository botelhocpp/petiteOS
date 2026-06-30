# =============================================================================
# FILES AND DIRECTORIES
# =============================================================================

BIN_DIR = 		./bin/
BUILD_DIR = 	./build/
BUILD_DIRS =	./build/kernel/ 	\
				./build/display/ 	\
				./build/interrupt/ 	\
				./build/core/ 		\
				./build/memory/ 

OS = $(BIN_DIR)/os.bin

FILES =	./build/kernel/kernel.asm.o		\
		./build/kernel/kernel.c.o 		\
		./build/display/terminal.c.o	\
		./build/display/vga.c.o			\
		./build/interrupt/idt.c.o		\
		./build/interrupt/pic.c.o		\
		./build/interrupt/idt.asm.o		\
		./build/memory/memory.c.o		\
		./build/core/core.asm.o

INCLUDES = -I./src/

# =============================================================================
# TOOLCHAIN
# =============================================================================

TC = i686-elf
CC = $(TC)-gcc
LD = $(TC)-ld
AS = nasm

CFLAGS = $(INCLUDES) -g -ffreestanding -falign-jumps -falign-functions 		\
		-falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer \
		-finline-functions -Wno-unused-function -fno-builtin -Werror 		\
		-Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib 			\
		-nostartfiles -nodefaultlibs -Wall -O0 -Iinc -std=gnu99
LDFLAGS = $(CFLAGS) -T ./src/kernel/kernel.ld

# =============================================================================
# TARGETS
# =============================================================================

$(OS):./bin/boot.bin ./bin/kernel.bin
	cat $^ > $@
	dd if=/dev/zero bs=512 count=100 >> $@

./bin/boot.bin: ./src/boot/boot.asm
	$(AS) -g -f bin $< -o $@

./bin/kernel.bin: ./build/kernel/kernel.module.o
	$(CC) $(LDFLAGS) $< -o $@

./build/kernel/kernel.module.o: $(FILES)
	$(LD) -g -relocatable $^ -o $@

./build/%.asm.o: ./src/%.asm
	$(AS) -g -f elf32 $< -o $@

./build/%.c.o: ./src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

./%/:
	mkdir -p $@

# =============================================================================
# COMMANDS
# =============================================================================

all: build

build: $(BUILD_DIRS) $(OS)

run: $(OS)
	qemu-system-x86_64 -hda $<

debug: $(OS)
	gdb -ex "add-symbol-file ./build/kernel/kernel.module.o 0x100000" \
		-ex "target remote | qemu-system-x86_64 -hda $< -S -gdb stdio" \
		-ex "set architecture i386" -ex "layout asm" \
		
view: $(OS)
	bless $<

dump: $(OS)
	ndisasm $<

clean:
	rm -rf ./bin/* ./build/*

.PHONY: all build run debug view clean
