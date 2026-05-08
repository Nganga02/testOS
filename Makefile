PREFIX = $(HOME)/opt/cross/bin/i686-elf-

CFLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Wno-cpp  -nostdlib -nostartfiles -nodefaultlibs -O0 -fno-pic -fno-pie -ffixed-r14  -I $(HOME)/opt/cross/include -I CFiles

CC = $(HOME)/opt/cross/bin/i686-elf-gcc 
OBJ = \
	build/loader2.o \
	build/src/vga/vga.o \
	build/src/std/io.o \
	build/src/main.o

all: loader1.bin os.bin

	rm -rf kernel.bin
	dd if=loader1.bin >> kernel.bin
	dd if=os.bin >> kernel.bin
	chmod u+x kernel.bin
	dd if=/dev/zero bs=512 count=100 >> kernel.bin


os.bin: $(OBJ)
	$(PREFIX)ld -g -relocatable $(OBJ) -o build/kernelfull.o
	$(PREFIX)gcc -T linker.ld -o $@ -ffreestanding -O0 -nostdlib build/kernelfull.o


loader1.bin: asm/loader1.asm
	nasm -f bin $< -o $@


build/loader2.o: asm/loader2.asm
	nasm -f elf -g $< -o $@


build/%.o: CFiles/%.c
	@mkdir -p $(dir $@)
	$(PREFIX)gcc $(CFLAGS) -c $< -o $@

clean:
	rm -rf loader1.bin os.bin CFiles
cleanall:
	rm -rf build app Makefile CFiles
