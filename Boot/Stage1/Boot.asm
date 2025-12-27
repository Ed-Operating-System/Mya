BITS 16
ORG 0x7c00 ; Boot sector load address

MyaS1_start:
    jmp 0x0000:.MyaS1_main
    .MyaS1_main:
        xor ax, ax ; Zero all segment registers
        mov ss, ax
        mov ds, ax
        mov es, ax

        mov sp, 0x7c00 ; Equiv to MyaS1_start
        cld

        mov [Mya_Boot_Drive], dl

        mov ax, (MyaS2_start - MyaS1_start) / 512
        mov cx, (MyaKernel_end - MyaS2_start) / 512

        mov bx, MyaS2_start
        xor dx, dx

        call MyaR_Read_Disk

        jmp MyaS2_start

Mya_Boot_Drive: db 0

%include "Disk.asm"

times 510 - ($ - $$) db 0
dw 0xAA55 ; Boot signature
