BITS 16

MyaR_PIC_EOI equ 0x20

MyaR_PIC1_CMD equ 0x20
MyaR_PIC1_DATA equ 0x21

MyaR_PIC2_CMD equ 0xA0
MyaR_PIC2_DATA equ 0xA1

MyaR_ICW1_ICW4 equ 0x01
MyaR_ICW1_SINGLE equ 0x02
MyaR_ICW1_INTERVAL4 equ 0x04
MyaR_ICW1_LEVEL equ 0x08
MyaR_ICW1_INITIALIZE equ 0x10

MyaR_ICW4_8086 equ 0x01
MyaR_ICW4_AUTO_EOI equ 0x02
MyaR_ICW4_BUF_SLAVE equ 0x08
MyaR_ICW4_BUF_MASTER equ 0x0C
MyaR_ICW4_SFNM equ 0x10

MyaL_Remap_PIC:
    push ax

    mov al, 0xFF

    out MyaR_PIC1_DATA, al
    out MyaR_PIC2_DATA, al

    nop
    nop

    mov al, MyaR_ICW1_INITIALIZE | MyaR_ICW1_ICW4
    out MyaR_PIC1_CMD, al
    out MyaR_PIC2_CMD, al

    mov al, 0x20
    out MyaR_PIC1_DATA, al

    mov al, 0x28
    out MyaR_PIC2_DATA, al

    mov al, 4
    out MyaR_PIC1_DATA, al

    mov al, 2
    out MyaR_PIC2_DATA, al

    mov al, MyaR_ICW4_8086
    out MyaR_PIC1_DATA, al
    out MyaR_PIC2_DATA, al

    mov al, 0xFF
    out MyaR_PIC1_DATA, al
    out MyaR_PIC2_DATA, al

    pop ax

    ret
    
