;;;;;;;;;;;;;;;;;;;;;;;
ORG 0x7c00
kernel equ 0x1000
;;;;;;;;;;;;;;;;;;;;;;;

mov [boot], dl
xor ax, ax
mov es, ax
mov ds, ax
mov sp, bp

;;;;;;;;;;;;;;;;;;;;;;;
call kernel_control
call begin_protected
;;;;;;;;;;;;;;;;;;;;;;;

kernel_control: 

    call load_kern
;;;;;;;;;;;;;;;;;;;;;;;

    load_kern:
        BITS 16

        mov bx, kernel
        mov dh, 33

        mov ah, 0x02
        mov al, dh
        mov ch, 0x00
        mov dh, 0x00
        mov cl, 0x02
        int 0x13 

;;;;;;;;;;;;;;;;;;;;;

        mov ah, 0x0
        mov al, 0x3
        int 0x10

;;;;;;;;;;;;;;;;;;;;;

begin_protected:
    BITS 16
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:protected
    jmp $

    BITS 32
    protected:
        mov ax, DATA_SEG
	    mov ds, ax
	    mov ss, ax
	    mov es, ax
	    mov fs, ax
	    mov gs, ax
	    mov ebp, 0x90000
        mov esp, ebp
        jmp kernel


    CODE_SEG equ gdt_code - gdt_start
    DATA_SEG equ gdt_data - gdt_start



;;;;;;;;;;;;;;;;;;;;

    gdt_start:
        gdt_null:
            dd 0x0
            dd 0x0

    gdt_code:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0

    gdt_data:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0

    gdt_end:

    gdt_descriptor:
        dw gdt_end - gdt_start - 1
        dd gdt_start


;;;;;;;;;;;;;;;;;;;;

boot: db 0


times 510-($ - $$) db 0
dw 0xAA55

;;;;;;;;;;;;;;;;;;;;
