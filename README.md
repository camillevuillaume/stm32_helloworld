# stm32_helloworld
Cmake project to cross-compile STM32 Cortex M4 applications and run them on QEMU, with printf support.

You can develop your library (in the project directory "library") and test it with QEMU emulating an STM32 Cortex M4 MCU. The software includes support for printf redirected to the target UART, which can be visualized on the host computer. In theory, the code should work on a real STM32 board (but some clock setting tuning might be necessary, see below).

The main.c file is located under "testprogram/Core/Src/". It continuously sends "Hello world" to UART1.

## Depedencies and prerequisites

I assume a Linux system (I am using Ubuntu 23.10).
You will need
- the ARM cross compiler arm-none-eabi-gcc, working with gcc-arm-none-eabi-10.2.0-r2.
- newlib for arm-none-eabi, working with newlib-arm-none-eabi-4.1.0-r0
- qemu-system-arm to run the program. working wiht qemu-system-arm-6.0.0-r5
- optionally gdb-multiarch to debug, working with gdb-multiarch-10.2-r0
- optionally doxygen, workging with doxygen-1.9.1-r1
- make, working with make-4.3-r0
- and of course cmake, working cmake-3.20.6-r0.

To make things easier, a Dockerfile is provided in order to generate a working toolchain. To generate the image with docker, run the following in the root directory of the project.
```
sudo docker build --tag 'armtools' .
```
And then to run:
```
sudo docker container run --mount type=bind,source=.,target=/mnt -it armtools
```
This will mount the project within the container and execute a shell with access to a working toolchain.

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
Optionally, to generate documentation for the library, run the command below. The html documentation will be generated in build/mylibrary/html.
```
make doc
```

## How to run the program

Now, you can run the program using QEMU. I am using the machine netduinoplus2, which is one of the Cortex M4 boards supported by QEMU. Under "build", just type:
```
qemu-system-arm -M netduinoplus2 -serial mon:stdio -kernel testprogram/test.elf
```
This should print "Hello world" continuously in the terminal.

## What to do from now

Edit you application as a static library in the folder "library".
Then test is (using printf if you need) by editing main.c in "testprogram/Core/Src/".

To debug, run the program with:
```
qemu-system-arm -M netduinoplus2 -S -gdb tcp::12345 -serial mon:stdio -kernel testprogram/test.elf
```
And then connect with GDB via:
```
gdb-multiarch -q -ex "file build/stm32firmware.elf" -ex "target remote :12345"
```


