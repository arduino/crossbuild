#!/bin/bash -e

# Check if the CROSS_COMPILE variable is set
if [ -z "$CROSS_COMPILE" ]; then
    echo "Error: CROSS_COMPILE is not set. Please specify the toolchain prefix (e.g., arm-linux-gnueabihf-)."
    exit 1
fi

# Detect if the toolchain is osxcross
if [[ "$CROSS_COMPILE" == *"apple-darwin"* ]]; then
    # Set osxcross-specific tools
    export CC="o64-clang"
    export CXX="o64-clang++"
else
    export CC="${CROSS_COMPILE}-gcc"
    export CXX="${CROSS_COMPILE}-g++"
fi

# Set default compilation flags
export AR="${CROSS_COMPILE}-ar"
export RANLIB="${CROSS_COMPILE}-ranlib"
export LD="${CROSS_COMPILE}-ld"
export STRIP="${CROSS_COMPILE}-strip"
export CFLAGS="-O2"
export CXXFLAGS="$CFLAGS"

# Add toolchain's lib directory to library paths
TOOLCHAIN_LIB_DIR="/opt/lib/${CROSS_COMPILE%/}/lib"
TOOLCHAIN_INCLUDE_DIR="/opt/lib/${CROSS_COMPILE%/}/include"
export LIBRARY_PATH="$TOOLCHAIN_LIB_DIR:$LIBRARY_PATH"
export PKG_CONFIG_PATH="$TOOLCHAIN_LIB_DIR/pkgconfig:$PKG_CONFIG_PATH"
export CPATH="$TOOLCHAIN_INCLUDE_DIR:$CPATH"
export C_INCLUDE_PATH="$TOOLCHAIN_INCLUDE_DIR:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="$TOOLCHAIN_INCLUDE_DIR:$CPLUS_INCLUDE_PATH"

echo "Configured toolchain: $CROSS_COMPILE"
echo "  CC=$CC, CXX=$CXX, AR=$AR, RANLIB=$RANLIB, LD=$LD, STRIP=$STRIP"
echo "  CFLAGS=$CFLAGS, CXXFLAGS=$CXXFLAGS, LDFLAGS=$LDFLAGS"
echo "  LIBRARY_PATH=$LIBRARY_PATH"
echo "  LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo "  PKG_CONFIG_PATH=$PKG_CONFIG_PATH"
echo "  CPATH=$CPATH"
echo "  C_INCLUDE_PATH=$C_INCLUDE_PATH"
echo "  CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH"

# Execute the provided command
exec "$@"
