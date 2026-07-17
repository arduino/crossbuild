#!/bin/sh

VERSION=ubuntu-24.04-1
docker build -f Dockerfile-base \
             -t ghcr.io/arduino/crossbuild-base:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION \
             -f Dockerfile-linux-amd64 \
             -t ghcr.io/arduino/crossbuild-linux-amd64:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION \
             -f Dockerfile-windows-amd64 \
             -t ghcr.io/arduino/crossbuild-windows-amd64:$VERSION .
docker build --build-arg BASE_VERSION=$VERSION \
             -f Dockerfile-windows-arm64 \
             -t ghcr.io/arduino/crossbuild-windows-arm64:$VERSION .
