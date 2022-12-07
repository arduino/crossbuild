#!/bin/bash -ex

true  # Dummy command required to prevent first ShellCheck directive from having global scope.

# shellcheck disable=SC2153 # Fix false positive of ShellCheck rule SC2153.
export PREFIX=/opt/lib/${CROSS_COMPILE}

if [ "$CROSS_COMPILER" == "" ]; then
CROSS_COMPILER=${CROSS_COMPILE}-gcc
CROSS_COMPILER_CXX=${CROSS_COMPILE}-g++
# AR=${CROSS_COMPILE}-ar
else
export CC=$CROSS_COMPILER
export CXX=$CROSS_COMPILER++
CROSS_COMPILER=$CC
CROSS_COMPILER_CXX=$CXX
fi
cd /opt/lib/libusb-1.0.26
LIBUSB_DIR=$(pwd)
export LIBUSB_DIR
./configure --prefix="${PREFIX}" --with-pic --disable-udev --enable-static --disable-shared --host="${CROSS_COMPILE}"
make distclean
./configure --prefix="${PREFIX}" --with-pic --disable-udev --enable-static --disable-shared --host="${CROSS_COMPILE}"
make -j"$(nproc)"
make install

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

if [[ $CROSS_COMPILE == "x86_64-apple-darwin13" ]]; then
  export LIBUSB_1_0_CFLAGS=-I${PREFIX}/include/libusb-1.0
  export LIBUSB_1_0_LIBS="-L${PREFIX}/lib -lusb-1.0"
fi
cd /opt/lib/libusb-compat-0.1.7
LIBUSB0_DIR=$(pwd)
export LIBUSB0_DIR
PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig" ./configure --prefix="${PREFIX}" --enable-static --disable-shared --host="${CROSS_COMPILE}"
make distclean
PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig" ./configure --prefix="${PREFIX}" --enable-static --disable-shared --host="${CROSS_COMPILE}"
make -j"$(nproc)"
make install

cd /opt/lib/libftdi1-1.4
rm -rf build && mkdir build && cd build

CMAKE_EXTRA_FLAG="-DSHAREDLIBS=OFF -DBUILD_TESTS=OFF -DPYTHON_BINDINGS=OFF -DEXAMPLES=OFF -DFTDI_EEPROM=OFF"

if [[ $CROSS_COMPILE == "i686-w64-mingw32" ]] ; then
  CMAKE_EXTRA_FLAG="$CMAKE_EXTRA_FLAG -DCMAKE_TOOLCHAIN_FILE=./cmake/Toolchain-i686-w64-mingw32.cmake"
fi

if [[ $CROSS_COMPILE == "x86_64-apple-darwin13" ]]; then
  CMAKE_EXTRA_FLAG="$CMAKE_EXTRA_FLAG -DCMAKE_AR=$AR -DCMAKE_RANLIB=$RANLIB"
fi

cmake -DCMAKE_C_COMPILER="$CROSS_COMPILER" -DCMAKE_CXX_COMPILER="$CROSS_COMPILER_CXX" -DCMAKE_INSTALL_PREFIX="$PREFIX" "$CMAKE_EXTRA_FLAG" -DLIBUSB_INCLUDE_DIR="$PREFIX/include/libusb-1.0" -DLIBFTDI_LIBRARY_DIRS="$PREFIX/lib" -DLIBUSB_LIBRARIES="usb-1.0" ../
make -j"$(nproc)"
make install

cd /opt/lib/libelf-0.8.13
LIBELF_DIR=$(pwd)
export LIBELF_DIR
./configure --disable-shared --host="$CROSS_COMPILE" --prefix="${PREFIX}"
make distclean
./configure --disable-shared --host="$CROSS_COMPILE" --prefix="${PREFIX}"
make -j"$(nproc)"
make install

echo "*****************"
file "${PREFIX}"/lib/*
echo "*****************"

export CPPFLAGS="-P"

cd /opt/lib/ncurses-6.3
NCURSES_DIR=$(pwd)
export NCURSES_DIR

./configure "$EXTRAFLAGS" --target="$CROSS_COMPILE" --without-pthread --enable-database --enable-sp-funcs --enable-term-driver --without-shared --without-debug --without-ada --enable-termcap --without-manpages --without-progs --without-tests --host="$CROSS_COMPILE" --prefix="${PREFIX}"
make distclean
./configure "$EXTRAFLAGS" --target="$CROSS_COMPILE" --without-pthread --enable-database --enable-sp-funcs --enable-term-driver --without-shared --without-debug --without-ada --enable-termcap --without-manpages --without-progs --without-tests --host="$CROSS_COMPILE" --prefix="${PREFIX}"
make -j"$(nproc)"
make install.libs

cd /opt/lib/readline-8.0
READLINE_DIR=$(pwd)
export READLINE_DIR
./configure --prefix="$PREFIX" --disable-shared --host="$CROSS_COMPILE"
make distclean
./configure --prefix="$PREFIX" --disable-shared --host="$CROSS_COMPILE"
make -j"$(nproc)"
make install-static

if [[ $CROSS_COMPILE != "i686-w64-mingw32" && $CROSS_COMPILE != "x86_64-apple-darwin13" ]] ; then
cd /opt/lib/eudev-3.2.10
./autogen.sh
./configure --enable-static --disable-gudev --disable-introspection --disable-shared --disable-blkid --disable-kmod --disable-manpages --prefix="$PREFIX" --host="${CROSS_COMPILE}"
make distclean
./autogen.sh
./configure --enable-static --disable-gudev --disable-introspection --disable-shared --disable-blkid --disable-kmod --disable-manpages --prefix="$PREFIX" --host="${CROSS_COMPILE}"
make -j"$(nproc)"
make install
fi

cd /opt/lib/hidapi-0.12.0
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
./bootstrap
./configure --prefix="$PREFIX" --enable-static --disable-shared --host="$CROSS_COMPILE"
make distclean
./bootstrap
./configure --prefix="$PREFIX" --enable-static --disable-shared --host="$CROSS_COMPILE"
make -j"$(nproc)"
make install