# Use pinned compiler dependencies.
FROM build-environment:latest

# SQLite specific set up.
WORKDIR /wolfssl
RUN git clone https://github.com/wolfSSL/wolfssl.git src && \
    cd src && \
    git checkout a4f55b01d62fddec602edaae6a2a1df54441b3da

RUN apt-get install -y autoconf libtool

WORKDIR /wolfssl/src
RUN ./autogen.sh

WORKDIR /wolfssl/build-gcc-O0
ENV CC=gcc-11 CFLAGS="-O0"
RUN ../src/configure && make

WORKDIR /wolfssl/build-gcc-O1
ENV CC=gcc-11 CFLAGS="-O1"
RUN ../src/configure && make

WORKDIR /wolfssl/build-gcc-O2
ENV CC=gcc-11 CFLAGS="-O2"
RUN ../src/configure && make

WORKDIR /wolfssl/build-gcc-O3
ENV CC=gcc-11 CFLAGS="-O3"
RUN ../src/configure && make

WORKDIR /wolfssl/build-clang-O0
ENV CC=clang-14 CFLAGS="-O0"
RUN ../src/configure && make

WORKDIR /wolfssl/build-clang-O1
ENV CC=clang-14 CFLAGS="-O1"
RUN ../src/configure && make

WORKDIR /wolfssl/build-clang-O2
ENV CC=clang-14 CFLAGS="-O2"
RUN ../src/configure && make

WORKDIR /wolfssl/build-clang-O3
ENV CC=clang-14 CFLAGS="-O3"
RUN ../src/configure && make

WORKDIR /artifacts
RUN mv /wolfssl/build-gcc-O0/src/.libs/libwolfssl.so.35.3.0 \
        ./libwolfssl.so.35.3.0.gcc-O0 && \
    mv /wolfssl/build-gcc-O1/src/.libs/libwolfssl.so.35.3.0 \
        ./libwolfssl.so.35.3.0.gcc-O1 && \
    mv /wolfssl/build-gcc-O2/src/.libs/libwolfssl.so.35.3.0 \
        ./libwolfssl.so.35.3.0.gcc-O2 && \
    mv /wolfssl/build-gcc-O3/src/.libs/libwolfssl.so.35.3.0 \
        ./libwolfssl.so.35.3.0.gcc-O3 && \
    mv /wolfssl/build-clang-O0/src/.libs/libwolfssl.so.35.3.0 \
        ./libwolfssl.so.35.3.0.clang-O0 && \
    mv /wolfssl/build-clang-O1/src/.libs/libwolfssl.so.35.3.0 \
        ./libwolfssl.so.35.3.0.clang-O1 && \
    mv /wolfssl/build-clang-O2/src/.libs/libwolfssl.so.35.3.0 \
        ./libwolfssl.so.35.3.0.clang-O2 && \
    mv /wolfssl/build-clang-O3/src/.libs/libwolfssl.so.35.3.0 \
        ./libwolfssl.so.35.3.0.clang-O3

CMD ["/bin/bash"]
