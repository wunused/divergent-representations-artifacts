# Use pinned compiler dependencies.
FROM build-environment:latest

# SQLite specific set up.
WORKDIR /libgit2
RUN git clone https://github.com/libgit2/libgit2.git src && \
    cd src && git checkout 0384a4024

RUN apt install -y cmake pkg-config libssl-dev

WORKDIR /libgit2/build-gcc-O0
ENV CC=gcc-11 CFLAGS="-O0" CXX=g++-11
RUN cmake -DCMAKE_C_FLAGS=$CFLAGS -DCMAKE_CXX_FLAGS=$CFLAGS -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX /libgit2/src && make

WORKDIR /libgit2/build-gcc-O1
ENV CC=gcc-11 CFLAGS="-O1" CXX=g++-11
RUN cmake -DCMAKE_C_FLAGS=$CFLAGS -DCMAKE_CXX_FLAGS=$CFLAGS -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX /libgit2/src && make

WORKDIR /libgit2/build-gcc-O2
ENV CC=gcc-11 CFLAGS="-O2" CXX=g++-11
RUN cmake -DCMAKE_C_FLAGS=$CFLAGS -DCMAKE_CXX_FLAGS=$CFLAGS -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX /libgit2/src && make

WORKDIR /libgit2/build-gcc-O3
ENV CC=gcc-11 CFLAGS="-O3" CXX=g++-11
RUN cmake -DCMAKE_C_FLAGS=$CFLAGS -DCMAKE_CXX_FLAGS=$CFLAGS -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX /libgit2/src && make

WORKDIR /libgit2/build-clang-O0
ENV CC=clang-14 CFLAGS="-O0" CXX=clang++-14
RUN cmake /libgit2/src && make
RUN cmake -DCMAKE_C_FLAGS=$CFLAGS -DCMAKE_CXX_FLAGS=$CFLAGS -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX /libgit2/src && make

WORKDIR /libgit2/build-clang-O1
ENV CC=clang-14 CFLAGS="-O1" CXX=clang++-14
RUN cmake -DCMAKE_C_FLAGS=$CFLAGS -DCMAKE_CXX_FLAGS=$CFLAGS -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX /libgit2/src && make

WORKDIR /libgit2/build-clang-O2
ENV CC=clang-14 CFLAGS="-O2" CXX=clang++-14
RUN cmake -DCMAKE_C_FLAGS=$CFLAGS -DCMAKE_CXX_FLAGS=$CFLAGS -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX /libgit2/src && make

WORKDIR /libgit2/build-clang-O3
ENV CC=clang-14 CFLAGS="-O3" CXX=clang++-14
RUN cmake -DCMAKE_C_FLAGS=$CFLAGS -DCMAKE_CXX_FLAGS=$CFLAGS -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX /libgit2/src && make

WORKDIR /artifacts
RUN mv /libgit2/build-gcc-O0/libgit2.so.1.5.0 ./libgit2.so.1.5.0.gcc-O0 && \
    mv /libgit2/build-gcc-O1/libgit2.so.1.5.0 ./libgit2.so.1.5.0.gcc-O1 && \
    mv /libgit2/build-gcc-O2/libgit2.so.1.5.0 ./libgit2.so.1.5.0.gcc-O2 && \
    mv /libgit2/build-gcc-O3/libgit2.so.1.5.0 ./libgit2.so.1.5.0.gcc-O3 && \
    mv /libgit2/build-clang-O0/libgit2.so.1.5.0 ./libgit2.so.1.5.0.clang-O0 && \
    mv /libgit2/build-clang-O1/libgit2.so.1.5.0 ./libgit2.so.1.5.0.clang-O1 && \
    mv /libgit2/build-clang-O2/libgit2.so.1.5.0 ./libgit2.so.1.5.0.clang-O2 && \
    mv /libgit2/build-clang-O3/libgit2.so.1.5.0 ./libgit2.so.1.5.0.clang-O3

CMD ["/bin/bash"]
