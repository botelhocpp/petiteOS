EXTERN int_20h_handler
EXTERN int_21h_handler
EXTERN no_interrupt_handler

SECTION .text
GLOBAL idt_load
idt_load:
    PUSH EBP
    MOV EBP, ESP

    MOV EBX, [EBP + 8]
    LIDT [EBX]

    LEAVE
    RET

GLOBAL no_interrupt
no_interrupt:
    CLI
    PUSHAD

    CALL no_interrupt_handler
    
    POPAD
    STI
    IRET

GLOBAL int_20h
int_20h:
    CLI
    PUSHAD

    CALL int_20h_handler
    
    POPAD
    STI
    IRET

GLOBAL int_21h
int_21h:
    CLI
    PUSHAD

    CALL int_21h_handler
    
    POPAD
    STI
    IRET
