# Use pinned compiler dependencies.
FROM build-environment:latest

# SQLite specific set up.
WORKDIR /sqlite
RUN git clone https://github.com/sqlite/sqlite.git src && \
    cd src && git checkout 3c12ebd4a303dcf6650f06a6aa5a9fa9046bd9c9

# SQLite dependency
RUN apt-get install tclsh -y

WORKDIR /sqlite/build-gcc-O0
ENV CC=gcc-11 CFLAGS="-O0"
RUN ../src/configure --enable-shared && make

WORKDIR /sqlite/build-gcc-O1
ENV CC=gcc-11 CFLAGS="-O1"
RUN ../src/configure --enable-shared && make

WORKDIR /sqlite/build-gcc-O2
ENV CC=gcc-11 CFLAGS="-O2"
RUN ../src/configure --enable-shared && make

WORKDIR /sqlite/build-gcc-O3
ENV CC=gcc-11 CFLAGS="-O3"
RUN ../src/configure --enable-shared && make

WORKDIR /sqlite/build-clang-O0
ENV CC=clang-14 CFLAGS="-O0"
RUN ../src/configure --enable-shared && make

WORKDIR /sqlite/build-clang-O1
ENV CC=clang-14 CFLAGS="-O1"
RUN ../src/configure --enable-shared && make

WORKDIR /sqlite/build-clang-O2
ENV CC=clang-14 CFLAGS="-O2"
RUN ../src/configure --enable-shared && make

WORKDIR /sqlite/build-clang-O3
ENV CC=clang-14 CFLAGS="-O3"
RUN ../src/configure --enable-shared && make

WORKDIR /artifacts
RUN mv /sqlite/build-gcc-00/.libs/libsqlite3.so.0.8.6 \
        ./libsqlite3.so.0.8.6.gcc-O0 && \
    mv /sqlite/build-gcc-O1/.libs/libsqlite3.so.0.8.6 \
        ./libsqlite3.so.0.8.6.gcc-O1 && \
    mv /sqlite/build-gcc-O2/.libs/libsqlite3.so.0.8.6 \
        ./libsqlite3.so.0.8.6.gcc-O2 && \
    mv /sqlite/build-gcc-O3/.libs/libsqlite3.so.0.8.6 \
        ./libsqlite3.so.0.8.6.gcc-O3 && \
    mv /sqlite/build-clang-O0/.libs/libsqlite3.so.0.8.6 \
        ./libsqlite3.so.0.8.6.clang-O0 && \
    mv /sqlite/build-clang-O1/.libs/libsqlite3.so.0.8.6 \
        ./libsqlite3.so.0.8.6.clang-O1 && \
    mv /sqlite/build-clang-O2/.libs/libsqlite3.so.0.8.6 \
        ./libsqlite3.so.0.8.6.clang-O2 && \
    mv /sqlite/build-clang-O3/.libs/libsqlite3.so.0.8.6 \
        ./libsqlite3.so.0.8.6.clang-O3 && \
    mv /sqlite/build-gcc-00/sqlite3 ./sqlite3.gcc-O0 && \
    mv /sqlite/build-gcc-01/sqlite3 ./sqlite3.gcc-O1 && \
    mv /sqlite/build-gcc-02/sqlite3 ./sqlite3.gcc-O2 && \
    mv /sqlite/build-gcc-03/sqlite3 ./sqlite3.gcc-O3 && \
    mv /sqlite/build-clang-00/sqlite3 ./sqlite3.clang-O0 && \
    mv /sqlite/build-clang-01/sqlite3 ./sqlite3.clang-O1 && \
    mv /sqlite/build-clang-02/sqlite3 ./sqlite3.clang-O2 && \
    mv /sqlite/build-clang-03/sqlite3 ./sqlite3.clang-O3

CMD ["/bin/bash"]
