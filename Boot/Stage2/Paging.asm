BITS 16

Page_Present equ (1 << 0)
Write_Page equ (1 << 1)
Page_Size equ (1 << 7)

PML4 equ 0xB000

PDPT_Lower equ (PML4 + 0x1000)
PD_Lower equ (PML4 + 0x2000)

PDPT_Upper equ (PML4 + 0x3000)
PD_Upper equ (PML4 + 0x4000)

; KVB (Kernel Virtual Base)
KVB equ 0xFFFFFFFF80000000

PML4_Index equ ((KVB >> 39) & 0x1FF)
PDPT_Index equ ((KVB >> 30) & 0x1FF)

PD_Index equ ((KVB >> 21) & 0x1FF)
PT_Index equ ((KVB >> 12) & 0x1FF)
        
CODE_SEL equ 8
DATA_SEL equ 16

GDT:
    .NULL: dq 0x0000000000000000
    .Code: dq 0x00209A0000000000
    .Data: dq 0x0000920000000000
    
    ALIGN 4
    
GDTR:
    .Length dw $ - GDT - 1
    .Base dd GDT

MyaP_Paging:
    mov edi, PML4
    mov ecx, 5 * 0x1000 / 4
    xor eax, eax

    cld
    rep stosd
    
    lea eax, [PDPT_Lower]
    or eax, Page_Present | Write_Page

    mov [PML4], eax
    
    lea eax, [PD_Lower]
    or  eax, Page_Present | Write_Page

    mov [PDPT_Lower], eax
    
    mov eax, 0
    or eax, Page_Present | Write_Page | Page_Size

    mov [PD_Lower], eax

    lea eax, [PDPT_Upper]
    or eax, Page_Present | Write_Page

    mov [PML4 + PML4_Index * 8], eax
    
    lea eax, [PD_Upper]
    or eax, Page_Present | Write_Page

    mov [PDPT_Upper + PDPT_Index * 8], eax
    
    mov di, PD_Upper
    xor ebx, ebx
    mov ecx, 512

    .MyaP_MapLoop:
        mov eax, ebx
        or eax, Page_Present | Write_Page | Page_Size

        mov [di], eax
        mov [di + 4], dword 0

        add di, 8
        add eax, 0x200000

        loop .MyaP_MapLoop

    ret
