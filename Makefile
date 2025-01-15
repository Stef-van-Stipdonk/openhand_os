

NAME := openhand_os

export PATH := $(HOME)/opt/cross/bin:$(PATH)
export BUILD_NAME := $(NAME).bin

TARGET := $(HOME)/opt/cross/bin/i686-elf

SCRIPTS := $(wildcard scripts/*.sh)

.PHONY: all
all: build/$(NAME).bin run-scripts

build:
	mkdir -p build

build/boot.o: boot.s | build
	$(TARGET)-as boot.s -o build/boot.o

build/kernel.o: kernel.c | build
	$(TARGET)-gcc -c kernel.c -o build/kernel.o \
		-std=gnu99 -ffreestanding -O2 -Wall -Wextra

build/$(NAME).bin: build/boot.o build/kernel.o linker.ld
	$(TARGET)-gcc -T linker.ld -o bin/$(NAME).bin \
		-ffreestanding -O2 -nostdlib \
		build/boot.o build/kernel.o -lgcc

.PHONY: run-scripts
run-scripts:
	@echo "Running test scripts in ./scripts/test ..."
	@for script in $(SCRIPTS); do \
		echo "  -> Running $$script"; \
		if ! bash $$script; then \
			echo "  => [ERROR]: $$script returned non-zero exit code"; \
			exit 1; \
		fi; \
	done
	@echo "All scripts returned exit code 0 (success)."

.PHONY: clean
clean:
	rm -rf build
