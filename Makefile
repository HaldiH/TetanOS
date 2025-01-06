TARGET := x86_64-unknown-none
arch := x86_64
config := debug
out_dir := target/$(TARGET)/$(config)
kernel := $(out_dir)/tetanos
iso := $(out_dir)/tetanos.iso

linker_script := src/arch/$(arch)/linker.ld
grub_cfg := src/arch/$(arch)/grub.cfg

.PHONY: all clean run iso kernel

all: kernel iso

clean:
	cargo clean

run: $(iso)
	qemu-system-$(arch) -cdrom $(iso)

iso: $(iso)

$(iso): $(kernel) $(grub_cfg)
	@mkdir -p $(out_dir)/isofiles/boot/grub
	cp $(kernel) $(out_dir)/isofiles/boot/kernel.bin
	cp $(grub_cfg) $(out_dir)/isofiles/boot/grub
	grub-mkrescue -o $(iso) $(out_dir)/isofiles 2> /dev/null

kernel:
	cargo build --target $(TARGET)