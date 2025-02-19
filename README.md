# ⚠️
Currently working on a rewrite on branch `release/v2` after realising my abstractions were badly planned out.

# Openhand_os 🤙
A x86 aka IA-32/i386 operating system.\
This is a personal project, and as such is in a continues state of disrepair...\
It is decently tested and documented, but for personal use, so your mileage may vary.

See local docs for sporadic documentation for later reference.

## List of supported stuff (Not ordered in any sense of the word...)
 - Stack smashing protection using canaries (currently using 0xDEADBEEF, should add support for runtime canary generation).
 - Now using NASM, instead of GAS.
 - Paging, allowing each process to see the full virtual address space, without being required to actually have it.

### Naming
The name of the OS is in reference to a handposition in climbing... the openhand crimp.
