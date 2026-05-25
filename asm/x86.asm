section .asm

global test_case
test_case:
	mov eax,0
	div eax
	ret


global load_gdt
global load_idt
global disable_interrupts
global enable_interrupts
global halt_cpu


global outportb
global outportw
global outportd

global inportb
global inportw
global inportd

global enable_paging
global load_page_directory

load_gdt:
	push ebp
	mov ebp,esp
	xor eax,eax
	mov eax,dword[ebp + 8]
	lgdt [eax]
	mov esp,ebp
	pop ebp
	ret

load_idt:
	push ebp
	mov ebp,esp
	xor eax,eax
	mov eax,dword[ebp + 8]
	lidt [eax]
	mov esp,ebp
	pop ebp
	ret

disable_interrupts:
	cli
	ret

enable_interrupts:
	sti
	ret

halt_cpu:
	hlt
	ret


outportb:
	push ebp
	mov ebp,esp
	mov dx,word[ebp + 8]
	mov al,byte[ebp + 12]
	out dx,al
	mov esp,ebp
	pop ebp
	ret


outportw:
	push ebp
	mov ebp,esp
	mov dx,word[ebp + 8]
	mov ax,word[ebp + 12]
	out dx,ax
	mov esp,ebp
	pop ebp
	ret

outportd:
	push ebp
	mov ebp,esp
	mov dx,word[ebp + 8]
	mov eax,dword[ebp + 12]
	out dx,eax
	mov esp,ebp
	pop ebp
	ret

inportb:
	push ebp
	mov ebp,esp
	mov dx,word[ebp + 8]
	xor eax,eax
	in al,dx
	mov esp,ebp
	pop ebp
	ret




inportw:
	push ebp
	mov ebp,esp
	mov dx,word[ebp + 8]
	xor eax,eax
	in ax,dx
	mov esp,ebp
	pop ebp
	ret


inportd:
	push ebp
	mov ebp,esp
	mov dx,word[ebp + 8]
	xor eax,eax
	in eax,dx
	mov esp,ebp
	pop ebp
	ret


enable_paging:
    push ebp
    mov ebp,esp
    mov eax,cr0
    or eax,0x80000000
    mov cr0,eax
    mov esp,ebp
    pop ebp
    ret

load_page_directory:
    push ebp
    mov ebp,esp
    mov eax,[ebp + 8]
    mov cr3,eax
    mov esp,ebp
    pop ebp
    ret

















