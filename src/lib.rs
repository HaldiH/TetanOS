#![no_std]
#![no_main]

use core::panic::PanicInfo;

mod vga_buffer;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn rust_main(multiboot_information_address: usize) {
    let boot_info = unsafe { multiboot2::load(multiboot_information_address) };
    // let memory_map_tag = boot_info.memory_map_tag().expect("Memory map tag required");

    // println!("memory areas:");
    // for area in memory_map_tag.memory_areas() {
    //     println!(
    //         "    start: 0x{:x}, length: 0x{:x}",
    //         area.base_addr, area.length
    //     );
    // }

    loop {}
}
