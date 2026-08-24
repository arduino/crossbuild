ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential dh-autoreconf git gperf \
                       pkg-config tar bison flex unzip curl wget
# Install clang and lld only for Ubuntu 24.04 (used for macOS/Windows cross-compilation)
RUN if [ "$BASE_IMAGE" == "ubuntu:24.04" ]; then apt-get install -y clang lld libc6-dev; fi

# Install cmake 4.4.2 from the official distribution channel.
RUN wget https://github.com/Kitware/CMake/releases/download/v4.4.2/cmake-4.4.2-linux-x86_64.tar.gz
RUN tar -xzf cmake-4.4.2-linux-x86_64.tar.gz --strip-components=1 -C /usr/
RUN rm cmake-4.4.2-linux-x86_64.tar.gz

CMD ["bash"]
