FROM alpine:3.14
RUN apk add --no-cache gcc-arm-none-eabi newlib-arm-none-eabi make cmake gdb-multiarch qemu-system-arm doxygen
ENTRYPOINT ["/bin/sh"]