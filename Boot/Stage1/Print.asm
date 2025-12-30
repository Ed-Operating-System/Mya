BITS 16

MyaR_Print:
    push ax
    push bx
    push si

    mov bh, 0x00

.Next:
    lodsb
    test al, al

    jz .Done

    mov ah, 0x0E
    int 0x10

    jmp .Next

.Done:
    pop si
    pop bx
    pop ax

    ret

MyaR_PrintLine:
    call MyaR_Print

    mov ah, 0x0E
    mov bh, 0x00

    mov al, 13
    int 0x10

    mov al, 10
    int 0x10
    
    ret
