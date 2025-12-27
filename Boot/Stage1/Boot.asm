BITS 16
ORG 0x7c00 ; Boot sector load address

jmp short MyaS1_start

Mya_Boot_Drive: db 0
Mya_Boot_Success_MSG: db "Mya S1: OK", 0

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
        mov cx, 1

        mov bx, MyaS2_start
        xor dx, dx

        call MyaR_Read_Disk

        mov si, Mya_Boot_Success_MSG
        call MyaR_PrintLine

        jmp MyaS2_start

Mya_Hang: hlt
    jmp Mya_Hang

%include "Boot/Stage1/Print.asm"
%include "Boot/Stage1/Disk.asm"

times 510 - ($ - $$) db 0
dw 0xAA55 ; Boot signature
