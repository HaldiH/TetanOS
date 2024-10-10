---
title: "Bootloader"
weight: 3
---

# Bootloader

The bootloader is a small program that is responsible for loading the operating system into memory and starting its execution. The bootloader is the first piece of software that runs when the computer is powered on, and it plays a critical role in the boot process. The bootloader is typically stored in the [Master Boot Record (MBR)](https://en.wikipedia.org/wiki/Master_boot_record) of the disk and is loaded into memory by the computer's [Basic Input/Output System (BIOS)](https://en.wikipedia.org/wiki/BIOS) or [Unified Extensible Firmware Interface (UEFI)](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface).

## Boot Process

The boot process begins when the computer is powered on and the BIOS or UEFI firmware runs a series of tests to check the hardware components. The firmware then loads the bootloader from the disk into memory and transfers control to it. The bootloader is responsible for loading the operating system kernel into memory and starting its execution.

The bootloader typically performs the following steps:

1. **Initialization**: The bootloader initializes the hardware components, such as the CPU, memory, and disk controller, to prepare the system for booting the operating system.
2. **Loading the Kernel**: The bootloader reads the operating system kernel from the disk into memory and sets up the necessary data structures to pass control to the kernel.
3. **Starting the Kernel**: The bootloader transfers control to the kernel by jumping to its entry point, which begins the execution of the operating system.

## Multiboot Specification

Writing a bootloader that is compatible with multiple operating systems can be challenging due to the differences in how operating systems are loaded and executed. To address this issue, the [GNU GRUB](https://www.gnu.org/software/grub/) bootloader introduced the [Multiboot Specification](https://www.gnu.org/software/grub/manual/multiboot/multiboot.html), which defines a standard format for bootloaders to pass information to the operating system kernel.

The [Multiboot Specification](https://www.gnu.org/software/grub/manual/multiboot/multiboot.html) is a standard that defines how bootloaders and operating systems interact. The Multiboot Specification specifies a format for the bootloader to pass information to the operating system kernel, such as the memory map, command line arguments, and boot modules. By adhering to the Multiboot Specification, bootloaders and operating systems can interoperate seamlessly.

To indicate that an operating system kernel supports the Multiboot 2 Specification, the bootloader sets the [Magic Number](https://www.gnu.org/software/grub/manual/multiboot/multiboot.html#Boot-information-format) in the [Multiboot 2 Header](https://www.gnu.org/software/grub/manual/multiboot/multiboot.html#Boot-information-format) of the kernel image. The kernel can then access the boot information passed by the bootloader to initialize the system:

| Field        | Type            | Value                            |
| ------------ | --------------- | -------------------------------- |
| Magic        | u32             | 0xE85250D6                       |
| Architecture | u32             | `0` for i386, `4` for MIPS       |
| Length       | u32             | Length of the header             |
| Checksum     | u32             | -(Magic + Architecture + Length) |
| Tags         | variable        | Multiboot tags                   |
| End Tag      | (u16, u16, u32) | (0, 0, 8)                        |

Converted to x86 assembly, the Multiboot 2 Header looks like this:

```asm
section .multiboot_header
header_start:
    dd 0xe85250d6                ; magic number (multiboot 2)
    dd 0                         ; architecture 0 (protected mode i386)
    dd header_end - header_start ; header length
    ; checksum
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    ; insert optional multiboot tags here

    ; required end tag
    dw 0    ; type
    dw 0    ; flags
    dd 8    ; size
header_end:
```

## Loading boot code

Once the bootloader detected the Multiboot header, it can load the kernel image into memory and pass control to it. The kernel image is typically an [ELF](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format) file that contains the code and data of the operating system kernel. The bootloader loads the kernel image into memory and sets up the necessary data structures to pass control to the kernel.

Let's take a look at a simple boot code written in x86 assembly that just prints `OK` to the screen:

```asm
global _start

section .text
bits 32
_start:
    mov dword [0xb8000], 0x2f4b2f4f ; print 'OK' to the screen
    hlt                             ; halt the CPU
```

This code writes the characters `OK` to the screen using the [text mode video buffer](https://en.wikipedia.org/wiki/Text_mode). The bootloader loads this code into memory and transfers control to it, which prints `OK` to the screen and halts the CPU.

However, the bootloader still needs an ELF kernel image to load and execute. Thus, we need to create a custom [linker script](https://en.wikipedia.org/wiki/Linker_script) to generate an ELF kernel image from the boot code. The linker script specifies the layout of the kernel image, such as the entry point and the memory regions:

```ld
ENTRY(_start)

SECTIONS {
    . = 1M; /* start at 1MB */

    .boot :
    {
        *(.multiboot_header) /* multiboot header */
    }

    .text :
    {
        *(.text) /* code */
    }
}
```

The linker script specifies that the entry point of the kernel image is `_start` and that the code section contains the boot code. The bootloader loads the kernel image into memory and transfers control to the entry point, which starts the execution of the operating system kernel.

Once the bootloader loads the kernel image into memory and passes control to it, the kernel initializes the system and starts the execution of the operating system. The bootloader plays a critical role in the boot process by loading the operating system kernel into memory and starting its execution.

## References

- [Master Boot Record (Wikipedia)](https://en.wikipedia.org/wiki/Master_boot_record)
- [Basic Input/Output System (Wikipedia)](https://en.wikipedia.org/wiki/BIOS)
- [Unified Extensible Firmware Interface (Wikipedia)](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface)
- [Multiboot Specification (GNU GRUB)](https://www.gnu.org/software/grub/manual/multiboot/multiboot.html)
- [Multiboot 2 Header (GNU GRUB)](https://www.gnu.org/software/grub/manual/multiboot/multiboot.html#Boot-information-format)
- [Executable and Linkable Format (Wikipedia)](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
- [Text Mode Video Buffer (Wikipedia)](https://en.wikipedia.org/wiki/Text_mode)
- [Linker Script (Wikipedia)](https://en.wikipedia.org/wiki/Linker_script)
