SECTION .text

; uint8_t inb(uint16_t port);
GLOBAL inb
inb:
    PUSH EBP
    MOV EBP, ESP

    MOV EDX, [EBP + 8]

    XOR EAX, EAX
    IN AL, DX

    LEAVE
    RET

; uint16_t inw(uint16_t port);
GLOBAL inw
inw:
    PUSH EBP
    MOV EBP, ESP

    MOV EDX, [EBP + 8]

    XOR EAX, EAX
    IN AX, DX

    LEAVE
    RET

; void outb(uint16_t port, uint8_t value);
GLOBAL outb
outb:
    PUSH EBP
    MOV EBP, ESP

    MOV EAX, [EBP + 12]
    MOV EDX, [EBP + 8]

    OUT DX, AL

    LEAVE
    RET

; void outw(uint16_t port, uint16_t value);
GLOBAL outw
outw:
    PUSH EBP
    MOV EBP, ESP

    MOV EAX, [EBP + 12]
    MOV EDX, [EBP + 8]

    OUT DX, AX

    LEAVE
    RET
