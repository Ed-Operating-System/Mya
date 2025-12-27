BITS 16

Newline dw 2

db 13
db 10

MyaR_Print:
    push ax
    push si

.Next:
    lodsb
    test al, al

    jz .Done

    mov ah, 0x0E
    mov bh, 0x00

    int 0x10

    jmp .Next

.Done:
    pop si
    pop ax

    ret

MyaR_PrintLine:
    call MyaR_Print

    mov al, 13
    mov ah, 0x0E

    int 0x10

    mov al, 10
    
    int 0x10
    
    ret
