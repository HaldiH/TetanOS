fn main() {
    nasm_rs::compile_library(
        "libboot.a",
        &[
            "src/arch/x86_64/boot.asm",
            "src/arch/x86_64/long_mode_init.asm",
            "src/arch/x86_64/multiboot_header.asm",
        ],
    )
    .unwrap();

    println!("cargo::rustc-link-arg=-T{}", "src/arch/x86_64/linker.ld");
    println!("cargo::rustc-link-arg=--whole-archive");
    println!("cargo::rustc-link-arg=-lboot");
    println!("cargo::rustc-link-arg=--no-whole-archive");
}
