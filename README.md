# Baking Pi - Operating Systems Development

> Warning: the course target Raspberry Pi 1 and is not compatible with the Raspberry Pi 2/3. The code here is modified to work in Raspberry Pi 3

I'll keep this repository with my code for the online course `Baking Pi - Operating Systems Development`.

The code here is a modified version because I don't have a Pi 1 to test the code, so I've made some modifications to be able to run this on Raspberry Pi 3 Model B. You can view more info about the course on the [Cambridge University website](https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/).

## Requirements

Since the assembly code in this repo is targeting Raspberry Pi 3, you will need a Pi 3 for testing the actual code, but you don't need a Pi 3 to compile, you can use the gcc arm eabi toolchain.

You can install the ARM gcc with:

```bash
yaourt -S gcc-arm-none-eabi-bin
# or
apt-get install gcc-arm-none-eabi
```

## Compiling and running on Raspberry Pi 3

```bash
# The lesson is a subfolder in src/
LESSON=ok01 make
```

Copy the generated `kernel8-32.img` to your SD card, along with the [Raspberry Pi boot files](https://github.com/raspberrypi/firmware/tree/master/boot) (bootloader.bin and start.elf).
