BITS 16

Mya_Boot2_Start_MSG: db "Entering Mya Stage: 2", 0
Mya_Boot2_Success_MSG: db "Mya S2: OK", 0

MyaL_Success_MSG: db "Mya: Long mode SUPPORTED", 0
MyaL_Fail_MSG: db "Mya: Long mode NOT SUPPORTED", 0

MyaS2_start:
    xor ax, ax
    mov ds, ax

    mov si, Mya_Boot2_Start_MSG
    call MyaR_PrintLine

    ; Similarly to R in Mya standing for "Real mode", L in MyaL stands for "Long mode"
    call MyaL_Is_Supported ; Check for long mode support
    test eax, eax

    jz .MyaL_Fail_MSG

    mov si, MyaL_Success_MSG
    call MyaR_PrintLine

    mov si, Mya_Boot2_Success_MSG
    call MyaR_PrintLine

    call MyaR_Enable_A20
    call MyaP_Paging
    call MyaL_Remap_PIC
    call MyaL_Enter

.MyaL_Fail_MSG:
    mov si, MyaL_Fail_MSG
    call MyaR_PrintLine

.MyaL_Hang: hlt
    jmp .MyaL_Hang

%include "Boot/Stage2/A20.asm"
%include "Boot/Stage2/Paging.asm"
%include "Boot/Stage2/Longmode.asm"
%include "Boot/Stage2/PIC.asm"
