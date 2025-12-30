BITS 16

MyaL_Is_Supported:
    mov eax, 0x80000000

    cpuid

    cmp eax, 0x80000001
    jb .MyaL_Not_Supported

    mov eax, 0x80000001

    cpuid

    test edx, 1 << 29
    jz .MyaL_Not_Supported

    ret

.MyaL_Not_Supported:
    xor eax, eax

    ret

MyaL_Enter:
    mov eax, PML4
    mov eax, 10100000b
    mov cr4, eax
    mov edx, edi
    mov cr3, edx
    mov ecx, 0xC0000080

    rdmsr
    
    or eax, 0x00000100
    wrmsr

    mov ebx, cr0

    or ebx, 0x80000001
    mov cr0, ebx

    lgdt [rel GDTR]
    jmp CODE_SEL:LONGMODE

LONGMODE:
    BITS 64

    mov ax, DATA_SEL
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov rax, KVB + KERNEL
    
    jmp rax

KERNEL:
    lea rax, [rel GDT]

    mov [rel GDTR.Base], rax
    lgdt [rel GDTR]          

    add rsp, KVB

    mov qword [abs KVB + PML4], 0
    mov rax, cr3
    mov cr3, rax
    
    jmp Mya_Kernel_start
