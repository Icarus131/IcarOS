section .text
    [BITS 32]
    [extern main]
    call main
    jmp $
