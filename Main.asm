Mya_Stage1_start:
    times 90 db 0
    %include "Boot/Stage1/Boot.asm"
Mya_Stage1_end:

Mya_Stage2_start:
    %include "Boot/Stage2/Boot2.asm"
    align 512, db 0
Mya_Stage2_end:

Mya_Kernel_start:
    %include "Kernel/Kernel.asm"
    align 512, db 0
Mya_Kernel_end:
