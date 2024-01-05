# stm32_helloworld
Cmake project to cross-compile STM32 Cortex M4 applications and run them on QEMU, with printf support.

You can develop your library (in the project directory "library") and test it with QEMU emulating an STM32 Cortex M4 MCU. The software includes support for printf redirected to the target UART, which can be visualized on the host computer. In theory, the code should work on a real STM32 board (but some clock setting tuning might be necessary, see below).

The main.c file is located under "testprogram/Core/Src/". It continuously sends "Hello world" to UART1.

## Depedencies and prerequisites

I assume a Linux system (I am using Ubuntu 23.10).
You will need
- the ARM cross compiler arm-none-eabi-gcc. I have version (15:12.2.rel1-1) 12.2.1 20221205.
- qemu-system-arm to run the program. I have version 8.0.4 (Debian 1:8.0.4+dfsg-1ubuntu3.23.10.1).
- optionally gdb-multiarch to debug. I have version (Ubuntu 14.0.50.20230907-0ubuntu1) 14.0.50.20230907-git.
- and of course cmake. I have version 3.27.4.

To create the test program, I used ST's [HAL](https://www.st.com/en/embedded-software/stm32cubef4.html), which I got with the ST tool [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html). Necessary files are already included in the repository.
However, I tried to keep the repository as lean as possible, and therefore did not add all of the files that the ST tool generated. In case you need more features from the ST HAL or other libraries, you can simply use STM32CubeMX with the provided project file "stm32firmware.ioc". Just open the file with STM32CubeMX and select what you need.
Note that STM32CubeMX only generates a Makefile. I wrote the cmake CMakeLists.txt based on the Makefile, but it should not be very difficult to modify it.

Disclaimer: I have not tested the program on a real board. On QEMU:
- I had to comment out the clock initialization. It is probably needed with a real board.
- The UART interrupt method was not working with QEMU.

## How to compile

Create the sub directory "build". Under build, execute the following command, passing the correct toolchain settings for ARM:
```
cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake ..
```
Then, simply type:
```
make
```
If everything worked fine, you should have test.elf in the directory "build/testprogram".

## How to run the program

Now, you can run the program using QEMU. I am using the machine olimex-stm32-h405, which is one of the Cortex M4 boards supported by QEMU. Under "build", just type:
```
qemu-system-arm -M olimex-stm32-h405 -serial mon:stdio -kernel testprogram/test.elf
```
This should print "Hello world" continuously in the terminal.

## What to do from now

Edit you application as a static library in the folder "library".
Then test is (using printf if you need) by editing main.c in "testprogram/Core/Src/".

To debug, run the program with:
```
qemu-system-arm -M olimex-stm32-h405 -S -gdb tcp::12345 -serial mon:stdio -kernel testprogram/test.elf
```
And then connect with GDB via:
```
gdb-multiarch -q -ex "file build/stm32firmware.elf" -ex "target remote :12345"
```


