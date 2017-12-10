# Baking Pi - Operating Systems Development

I'll keep this repository with my code for the `Baking Pi - Operating Systems Development` online course. The code here is a modified version of the template written by Alex Chadwick. You can view more info at the [Cambridge University website](https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/).

## Requirements

Since the assembly code for this course is targeting ARM devices (Raspberry Pi), you will need a Pi for testing the actual code, but you can compile with the gcc arm toolchain.

In arch I managed to install the ARM gcc with:

```bash
yaourt -S gcc-arm-none-eabi-bin
```

More info can be found in the course website.

## Compiling and running on Raspberry Pi

```bash
make
```

To run you need a Raspberry PI SD card which has an operating system already installed. If you browse the files in the SD card, you should see one called `kernel.img`. Rename the file to something else to preserve the original SO kernel. Then, copy the file `kernel.img` that `make` generated onto the SD Card.

When you are done simply rename the original kernel image back to `kernel.img`.