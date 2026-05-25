DATA_SEG equ 0x10
bits 32

global _start
extern main

BOOT_INFO      equ 0x8000
RANGE_BUFFER   equ 0x7000


_start:
pm_begin:
	push BOOT_INFO
	call main
	add esp, 4
	jmp $
	hlt
	jmp pm_begin ; should never reach here


times 512 - ($ - $$) db 0
