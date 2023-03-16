# Use pinned compiler dependencies.
FROM build-environment:latest

# SQLite specific set up.
WORKDIR /flatpak
RUN git clone https://github.com/flatpak/flatpak.git src && \
    cd src && \
    git checkout e72ae11b93705ac40ec9257819dea09ef5623a62

RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list && \
    apt update && \
    apt build-dep -y flatpak && \
    apt install -y libcurl4-openssl-dev libappstream-dev

#RUN apt-get install -y libreadline-dev zlib1g-dev bison flex

WORKDIR /flatpak/src
ENV NOCONFIGURE=1
RUN ./autogen.sh

WORKDIR /flatpak/build-gcc-O0
ENV CC=gcc-11 CFLAGS="-O0"
RUN ../src/configure && make

WORKDIR /flatpak/build-gcc-O1
ENV CC=gcc-11 CFLAGS="-O1"
RUN ../src/configure && make

WORKDIR /flatpak/build-gcc-O2
ENV CC=gcc-11 CFLAGS="-O2"
RUN ../src/configure && make

WORKDIR /flatpak/build-gcc-O3
ENV CC=gcc-11 CFLAGS="-O3"
RUN ../src/configure && make

WORKDIR /flatpak/build-clang-O0
ENV CC=clang-14 CFLAGS="-O0"
RUN ../src/configure && make

WORKDIR /flatpak/build-clang-O1
ENV CC=clang-14 CFLAGS="-O1"
RUN ../src/configure && make

WORKDIR /flatpak/build-clang-O2
ENV CC=clang-14 CFLAGS="-O2"
RUN ../src/configure && make

WORKDIR /flatpak/build-clang-O3
ENV CC=clang-14 CFLAGS="-O3"
RUN ../src/configure && make

WORKDIR /artifacts
RUN mv /flatpak/build-gcc-O0/flatpak ./flatpak.gcc-O0 && \
    mv /flatpak/build-gcc-O1/flatpak ./flatpak.gcc-O1 && \
    mv /flatpak/build-gcc-O2/flatpak ./flatpak.gcc-O2 && \
    mv /flatpak/build-gcc-O3/flatpak ./flatpak.gcc-O3 && \
    mv /flatpak/build-clang-O0/flatpak ./flatpak.clang-O0 && \
    mv /flatpak/build-clang-O1/flatpak ./flatpak.clang-O1 && \
    mv /flatpak/build-clang-O2/flatpak ./flatpak.clang-O2 && \
    mv /flatpak/build-clang-O3/flatpak ./flatpak.clang-O3

CMD ["/bin/bash"]
