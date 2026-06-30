[BITS 32]

EXTERN kernel_main

SECTION .entry

GLOBAL _start
_start:
    CALL kernel_main

halt:
    HLT
    JMP halt
