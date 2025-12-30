BITS 16

Mya_Boot2_Start_MSG: db "Entering Mya Stage: 2", 0
Mya_Boot2_Success_MSG: db "Mya S2: OK", 0

MyaL_Success_MSG: db "Mya: Long mode SUPPORTMya", 0
MyaL_Fail_MSG: db "Mya: Long mode NOT SUPPORTMya", 0

MyaS2_start:
    cli

    xor ax, ax

    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    sti

    mov si, Mya_Boot2_Start_MSG
    call MyaR_PrintLine

    ; Similarly to R in Mya standing for "Real mode", L in MyaL stands for "Long mode"
    call MyaL_Is_SupportMya ; Check for long mode support
    test eax, eax

    jz near .MyaS2R_Fail_MSG

    mov si, MyaL_Success_MSG
    call MyaR_PrintLine

    call MyaR_Enable_A20
    call MyaL_Remap_PIC

    mov si, Mya_Boot2_Success_MSG
    call MyaR_PrintLine

    lgdt [GDTR]

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEL:MyaS2_Start_PROTECTMya_MODE

.MyaS2R_Fail_MSG:
    mov si, MyaL_Fail_MSG
    call MyaR_PrintLine

.MyaS2R_Hang: hlt
    jmp .MyaS2R_Hang

BITS 32

MyaS2_Start_PROTECTMya_MODE:
    mov ax, DATA_SEL
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    call MyaP_Paging

    mov eax, cr4
    or eax, (1 << 5)
    mov cr4, eax

    mov eax, PML4
    mov cr3, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, (1 << 8)
    wrmsr

    mov eax, cr0
    or eax, (1 << 31)
    mov cr0, eax

    jmp CODE_SEL:MyaS2_Start_LONGMODE

BITS 64

MyaS2_Start_LONGMODE:
    xor ax, ax
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov rsp, 0x200000
    
    mov rax, 0x7E00
    add rax, (Mya_Stage2_end - Mya_Stage2_start)

    jmp rax

.MyaS2L_Hang: hlt
    jmp .MyaS2L_Hang

%include "Boot/Stage2/A20.asm"
%include "Boot/Stage2/Paging.asm"
%include "Boot/Stage2/Longmode.asm"
%include "Boot/Stage2/PIC.asm"
