DEFAULT_HOST	!= ../default-host.sh
HOST		?= DEFAULT_HOST
HOSTARCH	!= ../target-triplet-to-arch.sh $(HOST)

CFLAGS		?= -O0 -g
CPPFLAGS	?=
LDFLAGS		?=
LIBS		?=
ASFLAGS		?= -felf32

DESTDIR		?=
PREFIX		?= /usr/local
EXEC_PREFIX	?= $(PREFIX)
BOOTDIR		?= $(EXEC_PREFIX)/boot
INCLUDEDIR	?= $(PREFIX)/include

CFLAGS		:= $(CFLAGS) -ffreestanding -Wall -Wextra -fstack-protector-all
CPPFLAGS	:= $(CPPFLAGS) -D__is_kernel -Iinclude
LDFLAGS		:= $(LDFLAGS)
LIBS		:= $(LIBS) -nostdlib -lk -lgcc

ARCHDIR		= arch/$(HOSTARCH)

include $(ARCHDIR)/make.config

CFLAGS		:= $(CFLAGS) $(KERNEL_ARCH_CFLAGS)
CPPFLAGS	:= $(CPPFLAGS) $(KERNEL_ARCH_CPPFLAGS)
LDFLAGS		:= $(LFLAGS) $(KERNEL_ARCH_LDFLAGS)
LIBS		:= $(LIBS) $(KERNEL_ARCH_LIBS)

KERNEL_OBJS	= \
		$(KERNEL_ARCH_OBJS) \
		kernel/kernel.o \

OBJS		= \
		$(ARCHDIR)/crti.o \
		$(ARCHDIR)/crtbegin.o \
		$(KERNEL_OBJS) \
		$(ARCHDIR)/crtend.o \
		$(ARCHDIR)/crtn.o \

LINK_LIST	= \
		$(LDFLAGS) \
		$(ARCHDIR)/crti.o \
		$(ARCHDIR)/crtbegin.o \
		$(KERNEL_OBJS) \
		$(LIBS) \
		$(ARCHDIR)/crtend.o \
		$(ARCHDIR)/crtn.o \

.PHONY: all clean install install-headers install-kernel
.SUFFIXES: .o .c .nasm

all: openhand.kernel

openhand.kernel: $(OBJS) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(LINK_LIST)
	grub-file --is-x86-multiboot openhand.kernel

# Provide CRT objects by copying the toolchain's built-in ones
$(ARCHDIR)/crtbegin.o $(ARCHDIR)/crtend.o:
	OBJ=`$(CC) $(CFLAGS) $(LDFLAGS) -print-file-name=$(@F)` && cp "$$OBJ" $@

# Compile C files
.c.o:
	$(CC) -MD -c $< -o $@ -std=gnu11 $(CFLAGS) $(CPPFLAGS)

# Assemble .nasm files with NASM
.nasm.o:
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f openhand.kernel
	rm -f $(OBJS) *.o */*.o */*/*.o
	rm -f $(OBJS:.o=.d) *.d */*.d */*/*.d

install: install-headers install-kernel

install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -R --preserve=timestamps include/. $(DESTDIR)$(INCLUDEDIR)/.

install-kernel: openhand.kernel
	mkdir -p $(DESTDIR)$(BOOTDIR)
	cp openhand.kernel $(DESTDIR)$(BOOTDIR)

-include $(OBJS:.o=.d)
