# OK01 - How to enable the 'OK' or 'ACT' LED on the Raspberry Pi 3

Previously, the LEDs were wired directly to GPIO pins and you were able to prod a specific pin to make the LED turn on. Due to space constraints relating to Bluetooth and Wifi, the LEDs were moved off the main GPIO and onto an expanded—or virtual—GPIO.

The virtual GPIO is controlled by the VideoCore GPU.

## References

https://adamransom.github.io/posts/raspberry-pi-bare-metal-part-1.html