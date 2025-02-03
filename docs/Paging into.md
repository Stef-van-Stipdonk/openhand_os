Paging is a way by which an operating can provide each process a full virtual address space without actually requiring the full amount of physical memory to be available or present.

The x86 processors support 32-bit virtual addresses and 4-GiB virtual address spaces.

Paging can be extended to provide page-level protection.
Here a user process can only see and modify data which is paged in their own address space, this provides hardware based isolation.

----

In the context of x86, the Memory Management Unit (MMU) is used to map memory through a series of tables, two to be exact.
These two is the paging directory (PD), and the paging table (PT).
Both tables contain 1024 4-byte entries, making them 4-KiB each.
In the page directory, each entry points to a page table. In the page table, each entry points to a 4-KiB physical page frame.
Additionally, each entry has bits controlling access protection and caching features of the structure which it points to.
The entire system consisting of a page directory and page tables represents a linear 4-GiB virtual memory map.

"Translation of a virtual address into a physical address first involves dividing the virtual address into three parts: the most significant 10 bits (bits 22-31) specify the index of the page directory entry, the next 10 bits (bits 12-21) specify the index of the page table entry, and the least significant 12 bits (bits 0-11) specify the page offset. The then MMU walks through the paging structures, starting with the page directory, and uses the page directory entry to locate the page table. The page table entry is used to locate the base address of the physical page frame, and the page offset is added to the physical base address to produce the physical address. If translation fails for some reason (entry is marked as not present, for example), then the processor issues a page fault." <sup>[1]</sup>

References to stuff that helped create an understanding:
- [stackoverflow - how-does-x86-paging-work](https://stackoverflow.com/questions/18431261/how-does-x86-paging-work)



### References:
[1] https://wiki.osdev.org/Paging#MMU