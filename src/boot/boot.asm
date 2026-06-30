ORG 0x7C00
[BITS 16]

CODE_SEG EQU gdt_code - gdt_start
DATA_SEG EQU gdt_data - gdt_start

; Jump over BPB
JMP SHORT _boot_start
NOP

; BIOS Parameter Block (BPB)
TIMES 33 DB 0

_boot_start:

    ; Setup CS register (to 0x0)
    JMP 0x0:_setup_real_mode

_setup_real_mode:
    CLI

    ; Setup the segment registers
    XOR AX, AX
    MOV DS, AX
    MOV ES, AX
    MOV SS, AX
    MOV SP, 0x7C00

_enable_a20:

    ; Enable >1MB
    IN AL, 0x92
    TEST AL, 0x2
    JNZ _goto_protected_mode
    OR AL, 0x2
    AND AL, 0xFE
    OUT 0x92, AL

_goto_protected_mode:  

    ; Setup GDT and enable protected bit in CR0  
    LGDT [gdt_descriptor]
    MOV EAX, CR0
    OR EAX, 0x1
    MOV CR0, EAX

    JMP CODE_SEG:_load_kernel

[BITS 32]
_load_kernel:

    ; Setup protected mode selectors
    MOV AX, DATA_SEG
    MOV DS, AX
    MOV ES, AX
    MOV FS, AX
    MOV GS, AX
    MOV SS, AX

    ; Setup stack
    MOV EBP, 0x00200000
    MOV ESP, EBP

    ; Load kernel
    MOV EAX, 1          ; Starting sector
    MOV ECX, 100        ; Number of sectos
    MOV EDI, 0x100000   ; Destiny address
    CALL ata_lba_read

    ; Goto kernel
    JMP CODE_SEG:0x100000

; ==================================================
; Sendo READ command to the Hard Disk Controller.
; ==================================================
ata_lba_read:
    MOV EBX, EAX        ; Backup the LBA
    
    ; Send the highest 4 bits of the LBA
    SHR EAX, 24
    AND EAX, 0xF    ; Selects only 4 bits
    OR EAX, 0xE0    ; Selects the master drive
    MOV DX, 0x1F6
    OUT DX, AL

    ; Send the sector count to read
    MOV EAX, ECX
    MOV DX, 0x1F2
    OUT DX, AL

    ; Send lowest 8 bits of the LBA
    MOV EAX, EBX
    MOV DX, 0x1F3
    OUT DX, AL

    ; Send more bits of the LBA (bits 15:8)
    SHR EAX, 8
    MOV DX, 0x1F4
    OUT DX, AL

    ; Send more bits of the LBA (bits 23:16)
    SHR EAX, 8
    MOV DX, 0x1F5
    OUT DX, AL

    ; Send the read sector command
    MOV DX, 0x1F7
    MOV AL, 0x20
    OUT DX, AL

.next_sector:
    PUSH ECX

.poll_status:

    ; Poll DRQ bit of status port
    MOV DX, 0x1F7
    IN AL, DX
    TEST AL, 0x8
    JZ .poll_status

    MOV ECX, 256
    MOV DX, 0x1F0
    REP INSW        ; Read 256 words from 0x1F0 to ES:EDI

    POP ECX

    LOOP .next_sector

    RET

; GDT entries
gdt_start:

; Offset 0x0
gdt_null:
    DQ 0

; Offset 0x8 (for CS)
gdt_code:
    DW 0xFFFF       ; Limit [15:0]
    DW 0            ; Base [15:0]
    DB 0            ; Base [23:16]
    DB 0x9A         ; Access
    DB 0b11001111   ; Flags and Limit [19:16]
    DB 0            ; Base [31:24]

; Offset 0x10 (for DS, SS, ES, FS and GS)
gdt_data:
    DW 0xFFFF       ; Limit [15:0]
    DW 0            ; Base [15:0]
    DB 0            ; Base [23:16]
    DB 0x92         ; Access
    DB 0b11001111   ; Flags and Limit [19:16]
    DB 0            ; Base [31:24]

gdt_descriptor:
    DW $ - gdt_start - 1    ; Size
    DD gdt_start            ; Offset

; Zero remain sector save the last 2 bytes
TIMES 510 - ($ - $$) DB 0

; Boot Signature
DW 0xAA55
