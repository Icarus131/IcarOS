export PATH=$PATH:/usr/local/i386elfgcc/bin 

all: bin/boot.bin bin/kernext.o bin/kernel.o bin/null.bin bin/kernfull.bin bin/icaros.bin

bin/boot.bin: boot.asm
	nasm "boot.asm" -f bin -o "bin/boot.bin"

bin/kernext.o: src/functions/extern.asm
	nasm "src/functions/extern.asm" -f elf -o "bin/kernext.o"

bin/kernel.o: src/kern/kernel.cpp
	i386-elf-gcc -ffreestanding -m32 -g -c "src/kern/kernel.c" -o "bin/kernel.o"

bin/null.bin: src/utils/null.asm
	nasm "src/utils/null.asm" -f bin -o "bin/null.bin"

bin/kernfull.bin: bin/kernext.o bin/kernel.o 
	i386-elf-ld -o "bin/kernfull.bin" -Ttext 0x1000 "bin/kernext.o" "bin/kernel.o" --oformat binary

bin/icaros.bin: bin/boot.bin bin/kernfull.bin bin/null.bin 
	cat "bin/boot.bin" "bin/kernfull.bin" "bin/null.bin"  > "bin/icaros.bin"
	qemu-system-x86_64 -drive format=raw,file="bin/icaros.bin",index=0,if=floppy,  -m 128M

