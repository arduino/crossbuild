#!/bin/sh
# This scripts builds all dependencies in ./deps for macOS and places them in ./build/macos/dist.
# It is intended to be used in a native macOS environment or github macos runner.
# It requires the necessary build tools including pkg-config, autoconf, automake, libtool.

set -ex

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)"
BASE_PATH=$(cd "${SCRIPT_PATH}/.." && pwd)
cd "${BASE_PATH}"

mkdir -p "${BASE_PATH}/build/macos"
rm -rf "${BASE_PATH}/build/macos/*"
cp -r "${BASE_PATH}/deps" "${BASE_PATH}/build/macos/deps"
mkdir -p "${BASE_PATH}/build/macos/dist"

LIB_PATH=${BASE_PATH}/build/macos/deps \
  PREFIX=${BASE_PATH}/build/macos/dist \
  CROSS_COMPILER=cc \
  CROSS_COMPILE=aarch64-apple-darwin \
  NPROC=8 \
  ./deps/build_libs.sh
