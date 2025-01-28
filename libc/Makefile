DEFAULT_HOST != ../default-host.shmakefile
HOST         ?= DEFAULT_HOST
HOSTARCH     != ../target-triplet-to-arch.sh $(HOST)

CFLAGS   ?= -O0 -g
CPPFLAGS ?=
LDFLAGS  ?=
LIBS     ?=

DESTDIR   ?=
PREFIX    ?= /usr/local
EXEC_PREFIX ?= $(PREFIX)
INCLUDEDIR?= $(PREFIX)/include
LIBDIR    ?= $(EXEC_PREFIX)/lib

CFLAGS   := $(CFLAGS) -ffreestanding -Wall -Wextra -fstack-protector-all -v
CPPFLAGS := $(CPPFLAGS) -D__is_libc -Iinclude

LIBK_CFLAGS   := $(CFLAGS)
LIBK_CPPFLAGS := $(CPPFLAGS) -D__is_libk

ARCHDIR = arch/$(HOSTARCH)

include $(ARCHDIR)/make.config

CFLAGS        := $(CFLAGS) $(ARCH_CFLAGS)
CPPFLAGS      := $(CPPFLAGS) $(ARCH_CPPFLAGS)
LIBK_CFLAGS   := $(LIBK_CFLAGS) $(KERNEL_ARCH_CFLAGS)
LIBK_CPPFLAGS := $(LIBK_CPPFLAGS) $(KERNEL_ARCH_CPPFLAGS)

FREEOBJS = \
  $(ARCH_FREEOBJS) \
  stdio/printf.o \
  stdio/putchar.o \
  stdio/puts.o \
  stdlib/abort.o \
  string/memcmp.o \
  string/memcpy.o \
  string/memmove.o \
  string/memset.o \
  string/strlen.o \
  stack_protector/stack_protector.o

HOSTEDOBJS = \
  $(ARCH_HOSTEDOBJS)

OBJS = \
  $(FREEOBJS) \
  $(HOSTEDOBJS)

LIBK_OBJS = $(FREEOBJS:.o=.libk.o)

#BINARIES=libc.a libk.a # (If/when libc is ready)
BINARIES = libk.a

.PHONY: all clean install install-headers install-libs

# --------------------
# Use NASM for .S files
# --------------------
AS = nasm

# Choose 32-bit or 64-bit output; adapt to your architecture needs:
ifeq ($(HOSTARCH), x86_64)
ASFLAGS = -felf64
else
ASFLAGS = -felf32
endif

# In case you want to pass include paths or definitions to NASM, you can do:
# ASFLAGS += -I include/ -D SOMEDEFINE=1

.SUFFIXES: .o .libk.o .c .asm

all: $(BINARIES)

libc.a: $(OBJS)
	$(AR) rcs $@ $(OBJS)

libk.a: $(LIBK_OBJS)
	$(AR) rcs $@ $(LIBK_OBJS)

#
# Rules to compile C files
#
.c.o:
	$(CC) -MD -c $< -o $@ -std=gnu11 $(CFLAGS) $(CPPFLAGS)

.c.libk.o:
	$(CC) -MD -c $< -o $@ -std=gnu11 $(LIBK_CFLAGS) $(LIBK_CPPFLAGS)

#
# Rules to assemble .asm files with NASM
#
.asm.o:
	$(AS) $(ASFLAGS) $< -o $@

.asm.libk.o:
	$(AS) $(ASFLAGS) $< -o $@

#
# Optional rule (if you have .c.S files)
# This is uncommon, but if needed:
#
#.c.S:
#	$(CC) -MD -S $< -o $@ $(CFLAGS) $(CPPFLAGS)
#

clean:
	rm -f $(BINARIES) *.a
	rm -f $(OBJS) $(LIBK_OBJS) *.o */*.o */*/*.o
	rm -f $(OBJS:.o=.d) $(LIBK_OBJS:.o=.d) *.d */*.d */*/*.d

install: install-headers install-libs

install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -R --preserve=timestamps include/. $(DESTDIR)$(INCLUDEDIR)/.

install-libs: $(BINARIES)
	mkdir -p $(DESTDIR)$(LIBDIR)
	cp $(BINARIES) $(DESTDIR)$(LIBDIR)

-include $(OBJS:.o=.d)
-include $(LIBK_OBJS:.o=.d)

