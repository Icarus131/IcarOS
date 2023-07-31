# IcarOS

- IcarOS is my documented journey while exploring OSDev
- A simple, minimal and small skeletal 32-bit operating system written in Assembly and C++
- Currently working on a Rust port

### To run, just execute the make file.
  - You will need to install certain dependencies to cross-compile. Installation script for Arch Linux can be found in `src/utils`
  - You can also do `./Makefile`
  - You will need the full QEMU package on linux to run the bootloader

- As of now, it can boot and jump to the kernel and execute from there


#### Preview:

![Kernel Preview](https://user-images.githubusercontent.com/46900041/235489321-7b73ec8c-459f-48a5-a95b-f60329784e85.png)
