use std::fs;

fn main() {
    let arch = std::env::var("CARGO_CFG_TARGET_ARCH").unwrap();

    let asm_files = fs::read_dir(format!("src/arch/{}", arch))
        .unwrap()
        .map(|entry| entry.as_ref().unwrap().path())
        .filter(|path| {
            let ext = path.extension().unwrap();
            ext == "asm" || ext == "s" || ext == "S"
        })
        .map(|path| path.to_str().unwrap().to_string())
        .collect::<Vec<_>>();

    nasm_rs::compile_library(
        "libboot.a",
        &asm_files.iter().map(|s| s.as_str()).collect::<Vec<_>>(),
    )
    .unwrap();

    println!("cargo::rustc-link-arg=-T{}", format!("src/arch/{}/linker.ld", arch));
    println!("cargo::rustc-link-arg=--whole-archive");
    println!("cargo::rustc-link-arg=-lboot");
    println!("cargo::rustc-link-arg=--no-whole-archive");
}
