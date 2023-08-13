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

PRESENT        equ 1 << 7
NOT_SYS        equ 1 << 4
EXEC           equ 1 << 3
DC             equ 1 << 2
RW             equ 1 << 1
ACCESSED       equ 1 << 0


GRAN_4K       equ 1 << 7
SZ_32         equ 1 << 6
LONG_MODE     equ 1 << 5

    gdt_start:
        gdt_null:
            dd 0x0
            dd 0x0
            dq 0

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
        db PRESENT | NOT_SYS | RW
        db GRAN_4K | SZ_32 | 0xF
        db 0x0

    gdt_end:

    gdt_descriptor:
        dw gdt_end - gdt_start - 1
        dd gdt_start
        dq gdt_start


;Start paging for 64-bit long mode
mov edi, 0x1000
mov cr4, edi
xor eax, eax
mov ecx, 4076
rep stosd
mov edi, cr3

;Setting up tables
mov DWORD [edi], 0x2003
add edi, 0x1000
mov DWORD[edi], 0x3003
add edi, 0x1000
mov DWORD[edi], 0x4003
add edi, 0x1000

;Mapping first 2 megabytes
mov ebx, 0x00000003
mov ecx, 512

.SetEntry:
    mov DWORD[edi], ebx
    add ebx, 0x1000
    add edi, 8
    loop .SetEntry

mov eax, cr4
or eax, 1 << 5
mov cr4, eax

BITS 32
mov eax, cr4
or eax, (1<<12)
mov cr4, eax

;Entering 64-bit long mode
mov ecx, 0xC0000080
rdmsr
or eax, 1 << 8
wrmsr

mov eax, cr0
or eax, 1 << 31
mov cr0, eax

lgdt [gdt_descriptor]
jmp gdt_code:real_mode

[BITS 64]
 
real_mode:
    cli                           
    mov ax, gdt_data              
    mov ds, ax                    
    mov es, ax                    
    mov fs, ax                    
    mov gs, ax                    
    mov ss, ax                    
    mov edi, 0xB8000              
    mov rax, 0x1F201F201F201F20   
    mov ecx, 500                  
    rep stosq
    hlt                           



;;;;;;;;;;;;;;;;;;;;

boot: db 0


times 510-($ - $$) db 0
dw 0xAA55

;;;;;;;;;;;;;;;;;;;;
