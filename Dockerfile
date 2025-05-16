FROM ubuntu:22.04 AS build

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y \
        build-essential \
        # Intall clang compiler used by macos
        clang-13 \
        cmake \
        curl \
        dh-autoreconf \
        git \
        gperf \
        # various libs requied to compile osxcross
        libxml2-dev \
        libssl-dev \
        libz-dev \
        # Install Windows cross-tools
        mingw-w64 \
        xsltproc \
        p7zip-full \
        pkg-config \
        tar \
        unzip \
        llvm \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/clang-13 /usr/bin/clang \
    && ln -s /usr/bin/clang++-13 /usr/bin/clang++ \
    # pretend to have 1.17 instead of 1.16
    && ln -s /usr/bin/aclocal /usr/bin/aclocal-1.17 \
    && ln -s /usr/bin/automake /usr/bin/automake-1.17

# Install toolchains in /opt
RUN curl -L downloads.arduino.cc/tools/internal/toolchains.tar.gz | tar -xz "opt"
    # install proper arm toolchains (already present in the toolchains.tar.gz archive)
    # curl -L 'https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf.tar.xz' | tar -xJC /opt && \
    # curl -L 'https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz' | tar -xJC /opt

WORKDIR /opt/osxcross
RUN git pull && \
    # use a specific version of osxcross (it does not have tags), this commit has the automatic install of compiler_rt libraries
    git checkout b875d7c1360c8ff2077463d7a5a12e1cff1cc683 && \
    UNATTENDED=1 SDK_VERSION=10.15 ./build.sh && \
    ENABLE_COMPILER_RT_INSTALL=1 SDK_VERSION=10.15 ./build_compiler_rt.sh

# Set toolchains paths
# arm-linux-gnueabihf-gcc -> linux_arm
# aarch64-linux-gnu-gcc -> linux_arm64
# x86_64-ubuntu16.04-linux-gnu-gcc -> linux_amd64
# i686-ubuntu16.04-linux-gnu-gcc -> linux_386
# o64-clang -> darwin_amd64
ENV PATH=/opt/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/:/opt/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu/bin/:/opt/x86_64-ubuntu16.04-linux-gnu-gcc/bin/:/opt/i686-ubuntu16.04-linux-gnu/bin/:/opt/osxcross/target/bin/:$PATH

# Handle libusb and libudev compilation and merging
COPY deps/ /opt/lib/
# compiler name is arm-linux-gnueabihf-gcc '-gcc' is added by ./configure
RUN CROSS_COMPILE=x86_64-ubuntu16.04-linux-gnu /opt/lib/build_libs.sh && \
    CROSS_COMPILE=arm-linux-gnueabihf /opt/lib/build_libs.sh && \
    CROSS_COMPILE=aarch64-linux-gnu /opt/lib/build_libs.sh && \
    CROSS_COMPILE=i686-ubuntu16.04-linux-gnu /opt/lib/build_libs.sh && \
    CROSS_COMPILE=i686-w64-mingw32 /opt/lib/build_libs.sh && \
    # CROSS_COMPILER is used to override the compiler
    CROSS_COMPILER=o64-clang CROSS_COMPILE=x86_64-apple-darwin13 AR=/opt/osxcross/target/bin/x86_64-apple-darwin13-ar RANLIB=/opt/osxcross/target/bin/x86_64-apple-darwin13-ranlib /opt/lib/build_libs.sh

FROM ubuntu:22.04
# Copy all the installed toolchains and compiled libs
COPY --from=build /opt /opt
COPY --from=build /usr/lib/llvm-13/lib/clang/13.0.1 /usr/lib/llvm-13/lib/clang/13.0.1
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y \
        build-essential \
        # Intall clang compiler used by macos
        clang-13 \
        cmake \
        dh-autoreconf \
        git \
        gperf \
        # Install Windows cross-tools
        mingw-w64 \
        pkg-config \
        tar \
        bison \
        flex \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/clang-13 /usr/bin/clang \
    && ln -s /usr/bin/clang++-13 /usr/bin/clang++

# Set toolchains paths
# arm-linux-gnueabihf-gcc -> linux_arm
# aarch64-linux-gnu-gcc -> linux_arm64
# x86_64-ubuntu16.04-linux-gnu-gcc -> linux_amd64
# i686-ubuntu16.04-linux-gnu-gcc -> linux_386
# o64-clang -> darwin_amd64
ENV PATH=/opt/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/:/opt/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu/bin/:/opt/x86_64-ubuntu16.04-linux-gnu-gcc/bin/:/opt/i686-ubuntu16.04-linux-gnu/bin/:/opt/osxcross/target/bin/:$PATH

WORKDIR /workdir

ENTRYPOINT ["/bin/bash"]
