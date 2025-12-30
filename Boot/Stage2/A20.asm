BITS 16

MyaR_A20_Enabled_MSG: db "Mya: A20 is ENABLED", 0
MyaR_A20_Disabled_MSG: db "Mya: A20 is DISABLED", 0

MyaR_A20_BIOS_MSG: db "Mya: Enabling A10 via BIOS...", 0
MyaR_A20_Keyboard_MSG: db "Mya: Enabling A10 via Keyboard Controller...", 0
MyaR_A20_IO_MSG: db "Mya: Enabling A10 via IO Port 92...", 0

MyaR_Enable_A20:
    call MyaR_Check_A20
    test ax, ax
    jnz .LEnd

    mov si, MyaR_A20_BIOS_MSG
    call MyaR_PrintLine
    call MyaR_Enable_A20_BIOS

    call Mya_Check_A20
    test ax, ax
    jnz .LEnd

    mov si, MyaR_A20_Keyboard_MSG
    call MyaR_PrintLine
    call MyaR_Enable_A20_Keyboard 

    call Mya_Check_A20
    test ax, ax
    jnz .LEnd

    mov si, MyaR_A20_IO_MSG
    call MyaR_PrintLine
    call MyaR_Enable_A20_IO

    call Mya_Check_A20
    test ax, ax
    jnz .LEnd

.MyaR_Hang: hlt
    jmp .MyaR_Hang

.LEnd:
    ret

Mya_Check_A20:
    call MyaR_Check_A20
    test ax, ax

    jnz .MyaR_A20_Enabled
        mov si, MyaR_A20_Disabled_MSG
        call MyaR_PrintLine

        ret

   .MyaR_A20_Enabled:
        mov si, MyaR_A20_Enabled_MSG
        call MyaR_PrintLine

        ret

MyaR_Check_A20:
    pushf
    push ds
    push es
    push di
    push si

    cli
    
    xor ax, ax
    mov es, ax

    not ax
    
    mov ds, ax
    mov di, 0x0500
    mov si, 0x0510

    mov dl, byte [es:di]  
    push dx

    mov dl, byte [ds:si]

    push dx
    
    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF 
    cmp byte [es:di], 0xFF

    mov ax, 0

    je .MyaR_A20_Disabled

    mov ax, 1

.MyaR_A20_Disabled:
    pop dx  

    mov byte [ds:si], dl
    pop dx

    mov byte [es:di], dl
   
    pop si
    pop di
    pop es
    pop ds
    popf

    sti

    ret

MyaR_Enable_A20_BIOS:
    mov ax,2403h
    int 15h

    jb .MyaR_A20_Failure
    cmp ah, 0

    jnz .MyaR_A20_Failure
    mov ax, 2402h
    int 15h

    jb .MyaR_A20_Failure
    cmp ah, 0

    jnz .MyaR_A20_Failure
    cmp al, 1

    jz .MyaR_A20_Success
    mov ax, 2401h
    int 15h

    jb .MyaR_A20_Failure
    cmp ah, 0

    jnz .MyaR_A20_Failure

   .MyaR_A20_Success:
        mov ax, 1
        ret
   .MyaR_A20_Failure:
        mov ax, 0
        ret

MyaR_Disable_A20_BIOS:
    mov ax, 2400h
    int 15h

    ret

MyaR_Enable_A20_Keyboard:
    cli

    call MyaR_A20_Wait
    mov al, 0xAD

    out 0x64, al
    call MyaR_A20_Wait
    mov al, 0xD0

    out 0x64, al
    call MyaR_A20_Wait2 

    in al,0x60
    push eax

    call MyaR_A20_Wait
    mov al, 0xD1

    out 0x64, al
    call MyaR_A20_Wait

    pop eax

    or al, 2

    out 0x60, al
    call MyaR_A20_Wait

    mov al, 0xAE

    out 0x64, al
    call MyaR_A20_Wait

    sti

    ret

MyaR_A20_Wait:
    in al, 0x64
    test al, 2
    jnz MyaR_A20_Wait

    ret

MyaR_A20_Wait2:
    in al, 0x64
    test al, 1
    jz MyaR_A20_Wait2

    ret

MyaR_Enable_A20_IO:
    in al, 0x92
    test al, 2

    jnz .LEnd

    or al, 2
    and al, 0xFE

    out 0x92, al

.LEnd:
    ret
