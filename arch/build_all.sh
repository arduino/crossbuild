#!/bin/sh

docker build --build-arg BASE_IMAGE=ubuntu:16.04 -f Dockerfile-base -t ghcr.io/arduino/crossbuild-base:ubuntu-16.04-1 .
docker build --build-arg BASE_IMAGE=ubuntu:18.04 -f Dockerfile-base -t ghcr.io/arduino/crossbuild-base:ubuntu-18.04-1 .
docker build --build-arg BASE_IMAGE=ubuntu:20.04 -f Dockerfile-base -t ghcr.io/arduino/crossbuild-base:ubuntu-20.04-1 .
docker build --build-arg BASE_IMAGE=ubuntu:24.04 -f Dockerfile-base -t ghcr.io/arduino/crossbuild-base:ubuntu-24.04-1 .

VERSION=ubuntu-16.04-1
docker build -f Dockerfile-linux-all \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=x86_64-linux-gnu \
             -t ghcr.io/arduino/crossbuild-linux-amd64:$VERSION .

docker build -f Dockerfile-linux-all \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=aarch64-linux-gnu \
             --build-arg DEB_PACKAGES="gcc-aarch64-linux-gnu g++-aarch64-linux-gnu" \
             -t ghcr.io/arduino/crossbuild-linux-arm64:$VERSION .

docker build -f Dockerfile-linux-all \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=arm-linux-gnueabihf \
             --build-arg DEB_PACKAGES="gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf" \
             -t ghcr.io/arduino/crossbuild-linux-armhf:$VERSION .

VERSION=ubuntu-24.04-1
docker build -f Dockerfile-macos-all \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=aarch64-apple-darwin25.1 \
             -t ghcr.io/arduino/crossbuild-macos-arm64:$VERSION .

docker build -f Dockerfile-macos-all \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=x86_64-apple-darwin25.1 \
             -t ghcr.io/arduino/crossbuild-macos-amd64:$VERSION .

docker build -f Dockerfile-linux-amd64 \
             --build-arg BASE_VERSION=$VERSION \
             -t ghcr.io/arduino/crossbuild-linux-amd64:$VERSION .

docker build -f Dockerfile-windows-all \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=x86_64-w64-mingw32 \
             -t ghcr.io/arduino/crossbuild-windows-amd64:$VERSION .

docker build -f Dockerfile-windows-all \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=aarch64-w64-mingw32 \
             -t ghcr.io/arduino/crossbuild-windows-arm64:$VERSION .
