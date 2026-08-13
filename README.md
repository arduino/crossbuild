# Docker C/C++ crossbuild toolchains

[![Sync Labels status](https://github.com/arduino/crossbuild/actions/workflows/sync-labels.yml/badge.svg)](https://github.com/arduino/crossbuild/actions/workflows/sync-labels.yml)
[![Check Markdown status](https://github.com/arduino/crossbuild/actions/workflows/check-markdown-task.yml/badge.svg)](https://github.com/arduino/crossbuild/actions/workflows/check-markdown-task.yml)
[![Check License status](https://github.com/arduino/crossbuild/actions/workflows/check-license.yml/badge.svg)](https://github.com/arduino/crossbuild/actions/workflows/check-license.yml)
[![Check Taskfiles status](https://github.com/arduino/crossbuild/actions/workflows/check-taskfiles.yml/badge.svg)](https://github.com/arduino/crossbuild/actions/workflows/check-taskfiles.yml)
[![Check Shell Scripts status](https://github.com/arduino/crossbuild/actions/workflows/check-shell-task.yml/badge.svg)](https://github.com/arduino/crossbuild/actions/workflows/check-shell-task.yml)

The goal is to provide a docker container to simplify the creation of static builds of C/C++ tools.
We try to accomplish this by

* Installing the cross-compilers needed to build a specific target from a Linux x86_64 host.
* Precompiling the most used libraries statically (like libusb, hidapi, ncurses, libxml, etc...).
* Setting up an ENV with [sensible defaults](#environment-setup) for the most common build systems.

## Starting base image

For Windows and MacOS the starting base image is [ubuntu:24.04](https://hub.docker.com/_/ubuntu), in this case the starting image is only marginally important, since internally we use manually installed toolchains.

For Linux we want to use the oldest Ubuntu LTS version possible to maximize compatibility with older libc, at the time of writing, there are ubuntu:16.04 and ubuntu:18.04.

## Toolchain used

All of this won't be possible without the amazing work made from the following people:

- Linux: We install the standard gcc cross-compilers provided by Ubuntu.
- MacOS: We layer on top of [@crazy-max's container ghcr.io/crazy-max/osxcross](https://ghcr.io/crazy-max/osxcross), which is a ready-to-use distribution of [@tpoechtrager's osxcross](https://github.com/tpoechtrager/osxcross).
- Windows: We install the mingw build made by [@mstorsjo](https://github.com/mstorsjo/llvm-mingw), that supports targeting Win/ARM64.

Once the toolchains are installed we add the binaries to the `PATH` env variable, to easily use them in the CI.

## Environment setup

The containers are provided with some enviroment variables defaults that should help compiling with the most common build systems (Makefile, autoconf, cmake...):

- `CROSS_COMPILE`: Contains the "triple" of the target system to be used in `--host` for configure (for example: `x86_64-linux-gnu` or `aarch64-apple-darwin25.1`).
- `PREFIX`: Contains the installation folder of the pre-build libraries (usually `/opt/lib/${CROSS_COMPILE}`).
- `PKG_CONFIG_PATH`: Containts the installations folder of the pkg-config data files (usually `${PREFIX}/lib/pkgconfig`).
- `PATH`: Is updated with the path to the cross-compilers.
- `CC` and `CXX`: Contains the basename of the GCC and G++ compilers, respectively.
- `TARGET_OS`: Contains the target OS, it may be `windows`, `linux`, or `macos`.

On MacOS containers we also provide:
- `AR`: Contains the basename of the cross-compiler `ar` tool.
- `RANLIB`: Contains the basename of the cross-compiler `ranlib` tool.
- `LD_LIBRARY_PATH`: Is updated with the osxcross lib folder.

## Pre-built libraries avaiable in the docker images

Here a list of the pre-built libraries, avaiable in the `${PREFIX}` folder:

| Library       | Version | Notes                      |
| ------------- | ------- | -------------------------- |
| libconfuse    | 3.2.2   |                            |
| libelf        | 0.8.13  |                            |
| libeudev      | 3.2.14  | Only for Linux             |
| libftdi1      | 1.5     |                            |
| libhidapi     | 0.15.0  |                            |
| libncurses    | 6.6     |                            |
| libreadline   | 8.3     | Did not compile on Windows |
| libusb        | 1.0.29  |                            |
| libusb-compat | 0.1.8   |                            |
| libxml2       | 2.15.3  |                            |

## How to build and use the containers

The host machine is supposed to be a Linux amd64.

To build the containers just run the `./build_all_containers.sh` script. It may take 10/20 minutes to complete the build of all the containters, depending on internet connection speed and machine capabilities.

To use a container:
- Create a `build.sh` script in the root directory of the project source. This script will be automatically run by the container.
- Choose the [correct toolchain](#available-toolchain-images) to build for the desired target.
- Run `docker run -it --rm -w /build -v .:/build $TOOLCHAINIMAGE`, where
  * `-it` makes an interactive session
  * `--rm` will remove the container after the run is completed
  * `-w /build` sets the working directory to `/build` inside the container
  * `-v .:/build` binds the current directory (that should be the project root) to the `/build` directory inside the container
  * `$TOOLCHAINIMAGE` is the toolchain image chosen

## Available toolchain images

- ghcr.io/arduino/crossbuild-linux-amd64:ubuntu-16.04-1
- ghcr.io/arduino/crossbuild-linux-arm64:ubuntu-16.04-1
- ghcr.io/arduino/crossbuild-linux-armhf:ubuntu-16.04-1
- ghcr.io/arduino/crossbuild-linux-armhf:ubuntu-18.04-1
- ghcr.io/arduino/crossbuild-linux-i686:ubuntu-18.04-1
- ghcr.io/arduino/crossbuild-macos-amd64:ubuntu-24.04-1
- ghcr.io/arduino/crossbuild-macos-arm64:ubuntu-24.04-1
- ghcr.io/arduino/crossbuild-windows-amd64:ubuntu-24.04-1
- ghcr.io/arduino/crossbuild-windows-arm64:ubuntu-24.04-1
