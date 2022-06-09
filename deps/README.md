# Dependencies
The `deps/` folder contains the library dependencies used to build and link statically tools, like `picotool` and `elf2uf2` (the libraries `libusb` and `libudev`...).
The `deps/` folder contains also a bash script used by the [Dockerfile](../Dockerfile) to successfully build them with different toolchains and with different targets.
This way they are ready when used by the CI during the building/linking phase!

They come from:
- https://github.com/gentoo/eudev
- https://github.com/libusb/hidapi
- https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz/
- https://www.intra2net.com/en/developer/libftdi/index.php
- https://github.com/libusb/libusb
- https://github.com/libusb/libusb-compat-0.1
- https://ftp.gnu.org/gnu/ncurses/
- https://ftp.gnu.org/gnu/readline/

## `build_libs.sh`
`build_libs.sh` is used by the [Dockerfile](../Dockerfile#L53-L59):
Basically during the docker build phase the libraries are compiled with every toolchain available in the Docker container. Other libraries can be added, the [`build_libs.sh`](build_libs.sh) script needs to be adapted, but the Dockerfile should be ok.
