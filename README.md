# RERI Buildroot integration

This repository is a Buildroot external tree for the RERI QEMU platform. It builds the guest root filesystem and installs two complementary applications:

- `reri-monitor` on port 8080 for laboratory MMIO inspection and test injection
- `reri-performance` on port 8082 for GHES/PAPI correlation

It also builds the RISC-V-enabled PAPI fork and the native per-hart sampler. Generated root filesystems, QEMU binaries, firmware, kernels, EDK2 images, and compiled libraries are intentionally not committed.

## Build

The tree was prepared against Buildroot commit `79fd6241`.

From the Buildroot source directory:

    make BR2_EXTERNAL="/path/to/reri-buildroot" reri_riscv64_defconfig
    make

The compressed initramfs is produced as `output/images/rootfs.cpio.gz`.

If Buildroot rejects the environment because `PATH` contains spaces, start a clean Debian shell or use a minimal PATH containing `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin` plus the required cross-toolchain directory.

## Boot profiles

The BusyBox init script reads `reri.profile=` from the kernel command line:

| Profile | Services |
| --- | --- |
| `lab` | MMIO laboratory monitor only |
| `performance` | kernel/GHES plus PAPI monitor only |
| `both` or omitted | lab and performance monitors |

Use `scripts/run-reri-qemu.sh` to boot with the locally built QEMU, OpenSBI, EDK2, kernel, and initramfs. Every artifact path and the hart/record counts can be overridden with the environment variables defined at the top of the script.

## Kernel configuration

`kernel/reri.config` records the required APEI, GHES, SSE, EINJ, and debugfs options. The kernel itself remains in the Ventana Linux tree because no additional source commit was required beyond that branch.

## Pinned components

| Component | Branch | Commit |
| --- | --- | --- |
| QEMU | `fix/reri-v1.0-compliance` | `f1177ae584e374af029ab20c01a5972c53c7d6cf` |
| OpenSBI | `fix/reri-v1.0-compliance` | `bc3e6b0a` |
| Ventana Linux | `dev-upstream` | `92a162a2a` |
| EDK2 | `dev-upstream` | `997829a` |
| reri-monitor | `main` | `c0133f765e73f5270b9462d316bae6811340ac39` |
| reri-performance | `main` | `766dcdc01bf7344a6c93ed3f245a7790408a82f3` |
| reri-papi | `main` | `53b70fc3b6a76deb1c9e6bd1bf42a179347c5b1b` |

The performance monitor uses the Linux `/dev/kmsg` GHES stream. Only the laboratory monitor accesses RERI MMIO directly.
