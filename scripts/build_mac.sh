#!/bin/sh

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

