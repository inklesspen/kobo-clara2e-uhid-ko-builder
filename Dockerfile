FROM --platform=amd64 debian:bookworm as build-stage
RUN apt update && apt install -y build-essential cpio bc flex libncurses5-dev bison lzop xz-utils
RUN mkdir /kobo

WORKDIR /kobo
ADD https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz .
ADD https://github.com/kobolabs/Kobo-Reader/raw/master/hw/imx6sll-clara2e/kernel.tar.bz2 .
RUN tar xf gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
RUN tar xf kernel.tar.bz2

COPY config.gz .
RUN gunzip config.gz && mv config kernel/.config

COPY dtc-lexer.patch focaltech_flash.patch kernel-config.patch .

WORKDIR /kobo/kernel
RUN patch -p1 < /kobo/kernel-config.patch && patch -p1 < /kobo/dtc-lexer.patch && patch -p1 < /kobo/focaltech_flash.patch

# This will error out, but it's fine.
RUN make ARCH=arm CROSS_COMPILE=/kobo/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- ; exit 0
RUN make ARCH=arm CROSS_COMPILE=/kobo/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- modules

FROM scratch AS export-stage
COPY --from=build-stage /kobo/kernel/drivers/hid/uhid.ko /
