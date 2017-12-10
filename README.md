# Baking Pi - Operating Systems Development

I'll keep this repository with my code for the `Baking Pi - Operating Systems Development` online course.

The code here is a modified version because I don't have a Pi 1 to test the code, so I've made some modifications to be able to run this on Raspberry Pi 3 Model B. You can view more info about the course on the [Cambridge University website](https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/).

## Requirements

Since the assembly code in this repo is targeting Raspberry Pi 3 ARMv7, you will need a Pi 3 for testing the actual code, but you can compile with the gcc arm toolchain.

In arch I managed to install the ARM gcc with:

```bash
yaourt -S gcc-arm-none-eabi-bin # arch
apt-get install gcc-arm-none-eabi-bin # ubuntu/debian
```

More info can be found in the course website.

## Compiling and running on Raspberry Pi

```bash
make
```

To run you need a Raspberry PI SD card which has an operating system already installed. If you browse the files in the SD card, you should see one called `kernel.img`. Rename the file to something else to preserve the original SO kernel. Then, copy the file `kernel.img` that `make` generated onto the SD Card.

When you are done simply rename the original kernel image back to `kernel.img`.