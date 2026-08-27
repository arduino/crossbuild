#!/bin/sh -ex

# Build all the crossbuild base images for Arduino
docker build --build-arg BASE_IMAGE=ubuntu:16.04 -f image-base.Dockerfile -t ghcr.io/arduino/crossbuild-base:ubuntu-16.04-1 .
docker build --build-arg BASE_IMAGE=ubuntu:18.04 -f image-base.Dockerfile -t ghcr.io/arduino/crossbuild-base:ubuntu-18.04-1 .
docker build --build-arg BASE_IMAGE=ubuntu:20.04 -f image-base.Dockerfile -t ghcr.io/arduino/crossbuild-base:ubuntu-20.04-1 .
docker build --build-arg BASE_IMAGE=ubuntu:24.04 -f image-base.Dockerfile -t ghcr.io/arduino/crossbuild-base:ubuntu-24.04-1 .
LATEST=ubuntu-24.04-1

# Linux crossbuild images
# -----------------------
VERSION=ubuntu-16.04-1
docker build -f image-linux-all.Dockerfile \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=x86_64-linux-gnu \
             -t ghcr.io/arduino/crossbuild-linux-amd64:$VERSION .

docker build -f image-linux-all.Dockerfile \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=aarch64-linux-gnu \
             --build-arg DEB_PACKAGES="gcc-aarch64-linux-gnu g++-aarch64-linux-gnu" \
             -t ghcr.io/arduino/crossbuild-linux-arm64:$VERSION .

docker build -f image-linux-all.Dockerfile \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=arm-linux-gnueabihf \
             --build-arg DEB_PACKAGES="gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf" \
             -t ghcr.io/arduino/crossbuild-linux-armhf:$VERSION .

# i686 compiler is available from 18.04 onwards
VERSION=ubuntu-18.04-1
docker build -f image-linux-all.Dockerfile \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=arm-linux-gnueabihf \
             --build-arg DEB_PACKAGES="gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf" \
             -t ghcr.io/arduino/crossbuild-linux-armhf:$VERSION .

docker build -f image-linux-all.Dockerfile \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=i686-linux-gnu \
             --build-arg DEB_PACKAGES="gcc-i686-linux-gnu g++-i686-linux-gnu" \
             -t ghcr.io/arduino/crossbuild-linux-i686:$VERSION .

# macOS crossbuild images
# -----------------------
VERSION=$LATEST
docker build -f image-macos-all.Dockerfile \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=aarch64-apple-darwin25.1 \
             -t ghcr.io/arduino/crossbuild-macos-arm64:$VERSION .

docker build -f image-macos-all.Dockerfile \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=x86_64-apple-darwin25.1 \
             -t ghcr.io/arduino/crossbuild-macos-amd64:$VERSION .

# Windows crossbuild images
# -------------------------
VERSION=$LATEST
docker build -f image-windows-all.Dockerfile \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=x86_64-w64-mingw32 \
             -t ghcr.io/arduino/crossbuild-windows-amd64:$VERSION .

docker build -f image-windows-all.Dockerfile \
             --build-arg BASE_VERSION=$VERSION \
             --build-arg CROSS_COMPILE=aarch64-w64-mingw32 \
             -t ghcr.io/arduino/crossbuild-windows-arm64:$VERSION .
