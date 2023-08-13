# IcarOS

- IcarOS is my documented journey while exploring OSDev
- A simple, minimal and small skeletal 64-bit operating system written in Assembly and C
- Currently working on a Rust port

### To run, just execute the make file.
  - You will need to install certain dependencies to cross-compile. Installation script for Arch Linux can be found in `src/utils`
  - You can also do `./Makefile`
  - You will need the full QEMU package on linux to run the bootloader
  - Once you install qemu you can run the Makefile that contains rules to use the crosscompiler.
  - The provided script for the cross-compiler currently works only for linux, but can also be made for other platforms by installing the requirements given in the script

- As of now, it can boot and jump to the kernel and execute from there for 32 bit, and clears the screen and waits for jump to kernel for 64-bit

---
-  *ℹ️ The OS is still in it's development phase.*


#### Preview:

![Kernel Preview](https://user-images.githubusercontent.com/46900041/235489321-7b73ec8c-459f-48a5-a95b-f60329784e85.png)
