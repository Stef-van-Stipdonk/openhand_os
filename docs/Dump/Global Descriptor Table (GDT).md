#GDT 

## What goes in a GDT table
- Entry 0 in a descriptor table, or the NULL Descriptor, is never referenced by the processor, and should always contain no data. Certain emulators, like Bochs, will complain about limited exceptions if you do not have on present. Some use this descriptor to store a pointer to the [[GDT]] itself (To use with the LGDT instruction). The null descriptor is 8 bytes wide and the pointer is 6 bytes wide so it might just be the perfect place for this.
- A [[DPL]] 0 Code Segment descriptor (for the kernel).
- A Data Segment descriptor (writing to code segments is not allowed).
- A Task State Segment segment descriptor (its very useful to have at least one).
- Room for more segments if you need them (e.g. user-level, LDTs, more TSS, whatever).