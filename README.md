# stm32_helloworld
Cmake project to cross-compile STM32 Cortex M applications and run them on QEMU.

You can develop your library (in the project directory "library") and test it with a working STM32 environment, including support for printf directed to UART.
The main.c file is located under "testprogram/Core/Src/". It continuously sends "Hello world" to UART1.

## Depedencies and prerequisites

I assume a Linux system (I am using Ubuntu 23.10).
You will need
- the ARM cross compiler arm-none-eabi-gcc. I have version (15:12.2.rel1-1) 12.2.1 20221205.
- qemu-system-arm to run the program. I have version 8.0.4 (Debian 1:8.0.4+dfsg-1ubuntu3.23.10.1).
- optionally gdb-multiarch to debug. I have version (Ubuntu 14.0.50.20230907-0ubuntu1) 14.0.50.20230907-git.
- and of course cmake. I have version 3.27.4.

To create the test program, I am using ST's HAL, which I got with the ST tool STM32CubeMX. I tried to keep the repository as lean as possible, and therefore did not add all of the files that the ST tool generated. In case you need more features from the ST HAL or other libraries, you can simply use STM32CubeMX with the provided project file "stm32firmware.ioc".

## How to compile

Create the sub directory "build". Under build, execute the following command, passing the correct toolchain settings for ARM:
cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake ..
Then, simply type:
make
If everything worked fine, you should have test.elf in the directory "build/testprogram".

## How to run

Now, you can run the program using QEMU. Under "build", just type:
qemu-system-arm -M olimex-stm32-h405 -serial mon:stdio -kernel testprogram/test.elf
This should print "Hello world" continuously in the terminal.



