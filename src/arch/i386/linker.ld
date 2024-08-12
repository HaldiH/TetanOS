ENTRY(start)

SECTIONS {
    . = 0x100000; /* Tells GRUB to load the kernel starting at the 1MB */

    .boot :
    {
        /* Ensure that the multiboot header is at the beginning */
        *(.multiboot_header)
    }

    .text :
    {
        *(.text)
    }

}
