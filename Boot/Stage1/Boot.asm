BITS 16
ORG 0x7c00 ; Boot sector load address

jmp short MyaS1_start

Mya_Boot_Drive: db 0
Mya_Boot_Start_MSG: db "Entering Mya Stage 1...", 0
Mya_Boot_Success_MSG: db "Mya S1: OK", 0

MYA_VERSION_MSG: db "Mya Bootloader Version 1.2", 0
MYA_VERSION_DIVIDER_MSG: db "--------------------------", 0
MYA_BLANK_LINE_MSG: db "", 0

MyaS2_SECTORS equ 4
MyaS2_LBA equ 1

MyaS2_SEGMENT equ 0x1000
MyaS2_OFFSET equ 0x0000

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

    xor ax, ax ; Zero all segment registers
    mov ss, ax
    mov ds, ax
    mov es, ax

    mov sp, 0x7c00 ; Equiv to MyaS1_start   
    cld
    
    mov [Mya_Boot_Drive], dl
    ;call MyaR_Read_Disk
    
    mov si, Mya_Boot_Success_MSG
    call MyaR_PrintLine

    call MyaS2_start

Mya_Hang: hlt
    jmp Mya_Hang

%include "Boot/Stage1/Print.asm"
%include "Boot/Stage1/Disk.asm"

times 510 - ($ - $$) db 0
dw 0xAA55 ; Boot signature
