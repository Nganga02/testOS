DATA_SEG equ 0x10
bits 32

global _start
extern main


_start:
pm_begin:
	;extern __bss_start
	;extern __bss_end
	;
	;mov edi, __bss_start
	;mov ecx, __bss_end
	;sub ecx, edi
	;xor eax, eax
	;rep stosb

	mov ax,DATA_SEG
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov gs,ax
	mov ss,ax
	mov esp,0x7c00
	mov ebp,esp


    	call main
	jmp $
	hlt
	jmp pm_begin ; should never reach here


times 512 - ($ - $$) db 0
