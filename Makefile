export PATH := $(HOME)/opt/cross/bin:$(PATH)

TARGET := $(HOME)/opt/cross/bin/i686-elf

.PHONY: all clean

all: bin/myos.bin

obj:
	mkdir -p obj

bin:
	mkdir -p bin

obj/boot.o: boot.s | obj
	$(TARGET)-as boot.s -o obj/boot.o

obj/kernel.o: kernel.c | obj
	$(TARGET)-gcc -c kernel.c -o obj/kernel.o \
		-std=gnu99 -ffreestanding -O2 -Wall -Wextra

bin/myos.bin: obj/boot.o obj/kernel.o linker.ld | bin
	$(TARGET)-gcc -T linker.ld -o bin/myos.bin \
		-ffreestanding -O2 -nostdlib \
		obj/boot.o obj/kernel.o -lgcc

clean:
	rm -rf obj bin

