BITS 16
ORG 0x7c00 ; Boot sector load address

jmp short MyaS1_start

Mya_Boot_Drive: db 0
Mya_Boot_Start_MSG: db "Entering Mya Stage 1...", 0
Mya_Boot_Success_MSG: db "Mya S1: OK", 0

MYA_VERSION_MSG: db "Mya Bootloader Version 1.3", 0
MYA_VERSION_DIVIDER_MSG: db "--------------------------", 0
MYA_BLANK_LINE_MSG: db "", 0

MyaS1_start:
    call .MyaS1_main
    jmp Mya_Hang

.MyaS1_main:
    mov si, MYA_VERSION_MSG
    call MyaR_PrintLine

    mov si, MYA_VERSION_DIVIDER_MSG
    call MyaR_PrintLine

    mov si, MYA_BLANK_LINE_MSG
    call MyaR_PrintLine

    mov si, Mya_Boot_Start_MSG
    call MyaR_PrintLine

    cli

    xor ax, ax ; Zero all segment registers
    mov ss, ax
    mov ds, ax
    mov es, ax

    mov sp, 0x7c00 ; Equiv to MyaS1_start

    sti
    cld
    
    mov [Mya_Boot_Drive], dl

    mov ax, (Mya_Stage2_start - Mya_Stage1_start) / 512
    mov cx, (Mya_Stage2_end - Mya_Stage2_start) / 512
    mov bx, 0x7e00
    xor dx, dx

    call MyaR_Read_Disk
    
    mov si, Mya_Boot_Success_MSG
    call MyaR_PrintLine

    jmp 0x0000:0x7E00 ; Equiv to call MyaS2_start

Mya_Hang: hlt
    jmp Mya_Hang

%include "Boot/Stage1/Print.asm"
%include "Boot/Stage1/Disk.asm"

times 510 - ($ - $$) db 0
dw 0xAA55 ; Boot signature
