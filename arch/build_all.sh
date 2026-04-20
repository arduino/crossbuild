#!/bin/sh

VERSION=ubuntu-22.04-1
docker build -f Dockerfile-base          -t ghcr.io/arduino/crossbuild-base:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION \
             -f Dockerfile-linux-amd64   -t ghcr.io/arduino/crossbuild-x86_64-linux-gnu:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION \
             -f Dockerfile-windows-amd64 -t ghcr.io/arduino/crossbuild-x86_64-w64-mingw32:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION \
             -f Dockerfile-windows-arm64 -t ghcr.io/arduino/crossbuild-aarch64-w64-mingw32:$VERSION .
