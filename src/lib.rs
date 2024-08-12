#![no_std]
#![no_main]

use core::panic::PanicInfo;

mod vga_buffer;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern fn rust_main() {
    println!("Welcome to {} !", "TetanOS");
    println!("Version pre{}.{}.{}", 0, 0, 1);

    for _ in 1..23 {
        println!();
    }

    loop {}
}
