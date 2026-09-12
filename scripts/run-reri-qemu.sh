#!/bin/sh

set -eu

QEMU_BIN=${QEMU_BIN:-/home/mirco-deb/qemu/build-reri/qemu-system-riscv64}
OPENSBI_BIN=${OPENSBI_BIN:-/home/mirco-deb/patched/opensbi/build/platform/generic/firmware/fw_dynamic.bin}
EDK2_CODE=${EDK2_CODE:-/home/mirco-deb/patched/edk2/reri-qemu/RISCV_VIRT_CODE.fd}
EDK2_VARS=${EDK2_VARS:-/home/mirco-deb/patched/edk2/reri-qemu/RISCV_VIRT_VARS.fd}
KERNEL_IMAGE=${KERNEL_IMAGE:-/home/mirco-deb/patched/kernel/linux-ventana-reri/arch/riscv/boot/Image}
INITRD_IMAGE=${INITRD_IMAGE:-/home/mirco-deb/patched/buildroot-reri/output/images/rootfs.cpio.gz}
QEMU_LOG=${QEMU_LOG:-/tmp/qemu-reri.log}
RERI_PROFILE=${RERI_PROFILE:-both}
RERI_RECORDS=${RERI_RECORDS:-8}
RERI_HARTS=${RERI_HARTS:-2}
RERI_MEMORY_MB=${RERI_MEMORY_MB:-4096}

for required_file in "$QEMU_BIN" "$OPENSBI_BIN" "$EDK2_CODE" \
                     "$EDK2_VARS" "$KERNEL_IMAGE" "$INITRD_IMAGE"; do
	if [ ! -f "$required_file" ]; then
		echo "Missing required file: $required_file" >&2
		exit 1
	fi
done

exec "$QEMU_BIN" \
	-accel tcg \
	-machine "virt,pflash0=pflash0,pflash1=pflash1,rpmi=true,reri=true,reri-records=$RERI_RECORDS,aia=aplic-imsic" \
	-cpu "rv64,smepmp=false" \
	-m "$RERI_MEMORY_MB" \
	-smp "$RERI_HARTS" \
	-display none \
	-serial mon:stdio \
	-d guest_errors \
	-D "$QEMU_LOG" \
	-bios "$OPENSBI_BIN" \
	-blockdev "node-name=pflash0,driver=file,read-only=on,filename=$EDK2_CODE" \
	-blockdev "node-name=pflash1,driver=file,filename=$EDK2_VARS" \
	-netdev "user,id=net0,hostfwd=tcp::8080-:8080,hostfwd=tcp::8081-:8081,hostfwd=tcp::8082-:8082" \
	-device "virtio-net-device,netdev=net0" \
	-kernel "$KERNEL_IMAGE" \
	-initrd "$INITRD_IMAGE" \
	-append "root=/dev/ram rw console=ttyS0 earlycon=uart8250,mmio,0x10000000 reri.profile=$RERI_PROFILE" \
	"$@"
