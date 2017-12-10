# Baking Pi - Operating Systems Development

I'll keep this repository with my code for the `Baking Pi - Operating Systems Development` online course.

The code here is a modified version because I don't have a Pi 1 to test the code, so I've made some modifications to be able to run this on Raspberry Pi 3 Model B. You can view more info about the course on the [Cambridge University website](https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/).

## Requirements

Since the assembly code in this repo is targeting Raspberry Pi 3 ARMv7, you will need a Pi 3 for testing the actual code, but you can compile with the gcc arm toolchain.

You can install the ARM gcc with:

```bash
yaourt -S gcc-arm-none-eabi-bin
# or
apt-get install gcc-arm-none-eabi-bin
```

## Compiling and running on Raspberry Pi

```bash
make
```

Copy the generated `kernel.img` to your SD card, along with the [Raspberry Pi boot files](https://github.com/raspberrypi/firmware/tree/master/boot) (bootloader.bin and start.elf).