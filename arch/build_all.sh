#!/bin/sh

VERSION=ubuntu-24.04-1
docker build -f Dockerfile-base \
             -t ghcr.io/arduino/crossbuild-base:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION --build-arg CROSS_COMPILE=aarch64-apple-darwin25.1 \
             -f Dockerfile-macos-all \
             -t ghcr.io/arduino/crossbuild-macos-arm64:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION --build-arg CROSS_COMPILE=x86_64-apple-darwin25.1 \
             -f Dockerfile-macos-all \
             -t ghcr.io/arduino/crossbuild-macos-amd64:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION \
             -f Dockerfile-linux-amd64 \
             -t ghcr.io/arduino/crossbuild-linux-amd64:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION --build-arg CROSS_COMPILE=x86_64-w64-mingw32 \
             -f Dockerfile-windows-all \
             -t ghcr.io/arduino/crossbuild-windows-amd64:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION --build-arg CROSS_COMPILE=aarch64-w64-mingw32 \
             -f Dockerfile-windows-all \
             -t ghcr.io/arduino/crossbuild-windows-arm64:$VERSION .
