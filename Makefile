TARGET := x86_64-unknown-none
ARCH := x86_64
PROFILE := dev

ifeq ($(PROFILE), dev)
	target_dir := target/$(TARGET)/debug
else ifeq ($(PROFILE), test)
	target_dir := target/$(TARGET)/debug
else ifeq ($(PROFILE), release)
	target_dir := target/$(TARGET)/release
else ifeq ($(PROFILE), bench)
	target_dir := target/$(TARGET)/release
else
	target_dir := target/$(TARGET)/$(PROFILE)
endif

kernel := $(target_dir)/tetanos
iso := $(target_dir)/tetanos.iso

linker_script := src/arch/$(ARCH)/linker.ld
grub_cfg := src/arch/$(ARCH)/grub.cfg

.PHONY: all clean run iso kernel

all: kernel iso

clean:
	cargo clean

run: $(iso)
	qemu-system-$(ARCH) -cdrom $(iso)

iso: $(iso)

$(iso): $(kernel) $(grub_cfg)
	@mkdir -p $(target_dir)/isofiles/boot/grub
	cp $(kernel) $(target_dir)/isofiles/boot/kernel.bin
	cp $(grub_cfg) $(target_dir)/isofiles/boot/grub
	grub-mkrescue -o $(iso) $(target_dir)/isofiles 2> /dev/null

kernel:
	cargo build --target $(TARGET) --profile $(PROFILE)

$(kernel): kernel