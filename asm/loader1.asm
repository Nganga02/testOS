org 0x7c00
bits 16


CODE_SEG equ gdt_code - gdt_begin
DATA_SEG equ gdt_data - gdt_begin

boot_sector:
	jmp short _begin
	db 33

_begin:
	jmp 0x0000:bootloader

global disable_interrupts

global bootloader:
bootloader:
	call disable_interrupts
	cld	

	xor ax,ax
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov gs,ax
	mov ss,ax
	mov sp,0x7c00

	call set_video_mode
	call switch_to_pm



disable_interrupts:
	cli
	ret

set_video_mode:
	mov ah,0x00
	mov al,0x03
	int 0x10
	ret

setup_a20_gate:
	in al,0x92
	or al,0x02
	out 0x92,al
	ret

turn_on_prot_bit:
	mov eax,cr0
	or eax,0x01
	mov cr0,eax
	ret

load_gdt:
	lgdt [ds:gdt_desc]	
	ret

switch_to_pm:
	call set_video_mode
	call setup_a20_gate
	call turn_on_prot_bit
	call load_gdt
	jmp CODE_SEG:pm_begin

	jmp $

print:
.print:
	lodsb
	cmp al,0
	je .print_done
	call print_char
	jmp .print
.print_done:
	ret

print_char:
	mov ah,0x0e
	mov bx,0x00
	int 0x10
	ret


gdt_begin:
	dq 0x0000000000000000
gdt_code:
	dw 0xffff ;  // limit
	dw 0x0000  ;// base
	dw 0x9a00  ;// P DPL S    E DC RW A
	dw 0x00cf  ;// G DB(SZ) L 0 1101
gdt_data:
	dw 0xffff
	dw 0x0000
	dw 0x9200
	dw 0x00cf
gdt_desc:
	dw (gdt_desc - gdt_begin -1)
	dd gdt_begin



bits 32
pm_begin:
	mov eax,1  
	mov ecx,100 ; 100 sectors
	mov edi,0x0100000 ; buffer
	call ata_lba_read
	jmp CODE_SEG:0x0100000

ata_lba_read:
	mov ebx,eax

	shr eax,24
	or eax,0xE0
	mov dx,0x1F6
	out dx,al

	mov eax,ecx
	mov dx,0x1F2
	out dx,al

	mov eax,ebx
	mov dx,0x1F3
	out dx,al

	mov dx,0x1F4
	mov eax,ebx
	shr eax,8
	out dx,al

	mov dx,0x1F5
	mov eax,ebx
	shr eax,16
	out dx,al

	mov dx,0x1F7
	mov al,0x20
	out dx,al

.next_sector:
	push ecx

.try_again:
	mov dx,0x1F7
	in al,dx
	test al,8
	jz .try_again

	mov ecx,256
	mov dx,0x1F0
	rep insw

	pop ecx
	loop .next_sector
	ret

txt: db "hello world",0

boot_signature:
	times 510 - ($ - $$) db 0
	dw 0xaa55

