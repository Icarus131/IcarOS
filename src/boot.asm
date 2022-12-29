BITS 16
ORG 0x7c00                  ;Setting origin point to BIOS set MBR origin point [Magic Address]

mov si, screen
call print


print:
    mov bx, 0

.main:
    lodsb                   ;Loading char
    cmp al, 0               
    je .done                ;jump to done
    call print_string       ;otherwise call print to output text
    jmp .main               ;jumping back into .main


.done:
    ret                     ; Returning

print_string:
    mov ah, 0eh
    int 0x10
    ret                     

jmp $                       ; Hanging the bootloader by jumping to the same point

screen: db 'IcarOS', 0      ; Printing text to screen


times 510-($ - $$) db 0     ; Adding extra bytes as boot sig needs to be 512
dw 0xAA55                   ; Little-endian format for intel
