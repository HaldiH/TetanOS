global start

section .text
bits 32
start:
    extern rust_main
    call rust_main
    
    mov dword [0xb8000], 0xa04ba04f
    mov dword [0xb8004], 0xa059a041
    hlt