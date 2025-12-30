BITS 16

Mya_Disk_Packet:
    db 0x10
    db 0x00

    .Sector_Amount: dw 0x0000
    .Buffer_Offset: dw 0x0000
    .Buffer_Segment: dw 0x0000
    .LBA: dq 0x00000000

MyaR_Read_Disk:
    cmp cx, 127

    jbe .Mya_Read_Chunk

    push ax
    push cx
    push dx

    mov cx, 127

    call .Mya_Read_Chunk
    jc .MyaR_Error_Restore

    pop dx
    pop cx
    pop ax

    add ax, 127
    add dx, 127 * 512 / 16
    sub cx, 127

    jmp MyaR_Read_Disk

.Mya_Read_Chunk:
    xor eax, eax
    mov ax, ax

    mov word [Mya_Disk_Packet.Sector_Amount], cx
    mov word [Mya_Disk_Packet.Buffer_Offset], bx
    mov word [Mya_Disk_Packet.Buffer_Segment], dx
    mov dword [Mya_Disk_Packet.LBA], eax
    mov dword [Mya_Disk_Packet.LBA + 4], 0

    mov dl, [Mya_Boot_Drive]
    mov si, Mya_Disk_Packet
    mov ah, 0x42

    int 0x13

    jc .MyaR_Error

    ret

.MyaR_Error:
    mov si, Mya_Disk_Error_MSG
    call MyaR_PrintLine

.MyaR_Error_Restore:
    pop dx
    pop cx
    pop ax
    
.MyaR_Hang: hlt
    jmp .MyaR_Hang

Mya_Disk_Error_MSG: db "Mya: Disk Error", 0
