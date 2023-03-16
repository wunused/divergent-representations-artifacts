# Use pinned compiler dependencies.
FROM build-environment:latest

WORKDIR /radare2
RUN git clone https://github.com/radareorg/radare2 src && \
    cd src && git checkout c98d89d72

ENV CC=gcc-11 CFLAGS="-O0"
WORKDIR /radare2/src
RUN ./configure && make
WORKDIR /radare2/build-gcc-O0
RUN cp -r /radare2/src/libr/**/*.so . \
    && cp /radare2/src/binr/r2agent/r2agent . \
    && cp /radare2/src/binr/r2pm/r2pm . \
    && cp /radare2/src/binr/r2r/r2r . \
    && cp /radare2/src/binr/rabin2/rabin2 . \
    && cp /radare2/src/binr/radare2/radare2 . \
    && cp /radare2/src/binr/radiff2/radiff2 . \
    && cp /radare2/src/binr/rafind2/rafind2 . \
    && cp /radare2/src/binr/ragg2/ragg2 . \
    && cp /radare2/src/binr/rahash2/rahash2 . \
    && cp /radare2/src/binr/rarun2/rarun2 . \
    && cp /radare2/src/binr/rasign2/rasign2 . \
    && cp /radare2/src/binr/rasm2/rasm2 . \
    && cp /radare2/src/binr/ravc2/ravc2 . \
    && cp /radare2/src/binr/rax2/rax2 .

ENV CC=gcc-11 CFLAGS="-O1"
WORKDIR /radare2/src
RUN make clean && ./configure && make
WORKDIR /radare2/build-gcc-O1
RUN cp -r /radare2/src/libr/**/*.so . \
    && cp /radare2/src/binr/r2agent/r2agent . \
    && cp /radare2/src/binr/r2pm/r2pm . \
    && cp /radare2/src/binr/r2r/r2r . \
    && cp /radare2/src/binr/rabin2/rabin2 . \
    && cp /radare2/src/binr/radare2/radare2 . \
    && cp /radare2/src/binr/radiff2/radiff2 . \
    && cp /radare2/src/binr/rafind2/rafind2 . \
    && cp /radare2/src/binr/ragg2/ragg2 . \
    && cp /radare2/src/binr/rahash2/rahash2 . \
    && cp /radare2/src/binr/rarun2/rarun2 . \
    && cp /radare2/src/binr/rasign2/rasign2 . \
    && cp /radare2/src/binr/rasm2/rasm2 . \
    && cp /radare2/src/binr/ravc2/ravc2 . \
    && cp /radare2/src/binr/rax2/rax2 .


ENV CC=gcc-11 CFLAGS="-O2"
WORKDIR /radare2/src
RUN make clean && ./configure && make
WORKDIR /radare2/build-gcc-O2
RUN cp -r /radare2/src/libr/**/*.so . \
    && cp /radare2/src/binr/r2agent/r2agent . \
    && cp /radare2/src/binr/r2pm/r2pm . \
    && cp /radare2/src/binr/r2r/r2r . \
    && cp /radare2/src/binr/rabin2/rabin2 . \
    && cp /radare2/src/binr/radare2/radare2 . \
    && cp /radare2/src/binr/radiff2/radiff2 . \
    && cp /radare2/src/binr/rafind2/rafind2 . \
    && cp /radare2/src/binr/ragg2/ragg2 . \
    && cp /radare2/src/binr/rahash2/rahash2 . \
    && cp /radare2/src/binr/rarun2/rarun2 . \
    && cp /radare2/src/binr/rasign2/rasign2 . \
    && cp /radare2/src/binr/rasm2/rasm2 . \
    && cp /radare2/src/binr/ravc2/ravc2 . \
    && cp /radare2/src/binr/rax2/rax2 .


ENV CC=gcc-11 CFLAGS="-O3"
WORKDIR /radare2/src
RUN make clean && ./configure && make
WORKDIR /radare2/build-gcc-O3
RUN cp -r /radare2/src/libr/**/*.so . \
    && cp /radare2/src/binr/r2agent/r2agent . \
    && cp /radare2/src/binr/r2pm/r2pm . \
    && cp /radare2/src/binr/r2r/r2r . \
    && cp /radare2/src/binr/rabin2/rabin2 . \
    && cp /radare2/src/binr/radare2/radare2 . \
    && cp /radare2/src/binr/radiff2/radiff2 . \
    && cp /radare2/src/binr/rafind2/rafind2 . \
    && cp /radare2/src/binr/ragg2/ragg2 . \
    && cp /radare2/src/binr/rahash2/rahash2 . \
    && cp /radare2/src/binr/rarun2/rarun2 . \
    && cp /radare2/src/binr/rasign2/rasign2 . \
    && cp /radare2/src/binr/rasm2/rasm2 . \
    && cp /radare2/src/binr/ravc2/ravc2 . \
    && cp /radare2/src/binr/rax2/rax2 .


ENV CC=clang-14 CFLAGS="-O0"
WORKDIR /radare2/src
RUN make clean && ./configure && make
WORKDIR /radare2/build-clang-O0
RUN cp -r /radare2/src/libr/**/*.so . \
    && cp /radare2/src/binr/r2agent/r2agent . \
    && cp /radare2/src/binr/r2pm/r2pm . \
    && cp /radare2/src/binr/r2r/r2r . \
    && cp /radare2/src/binr/rabin2/rabin2 . \
    && cp /radare2/src/binr/radare2/radare2 . \
    && cp /radare2/src/binr/radiff2/radiff2 . \
    && cp /radare2/src/binr/rafind2/rafind2 . \
    && cp /radare2/src/binr/ragg2/ragg2 . \
    && cp /radare2/src/binr/rahash2/rahash2 . \
    && cp /radare2/src/binr/rarun2/rarun2 . \
    && cp /radare2/src/binr/rasign2/rasign2 . \
    && cp /radare2/src/binr/rasm2/rasm2 . \
    && cp /radare2/src/binr/ravc2/ravc2 . \
    && cp /radare2/src/binr/rax2/rax2 .


ENV CC=clang-14 CFLAGS="-O1"
WORKDIR /radare2/src
RUN make clean && ./configure && make
WORKDIR /radare2/build-clang-01
RUN cp -r /radare2/src/libr/**/*.so . \
    && cp /radare2/src/binr/r2agent/r2agent . \
    && cp /radare2/src/binr/r2pm/r2pm . \
    && cp /radare2/src/binr/r2r/r2r . \
    && cp /radare2/src/binr/rabin2/rabin2 . \
    && cp /radare2/src/binr/radare2/radare2 . \
    && cp /radare2/src/binr/radiff2/radiff2 . \
    && cp /radare2/src/binr/rafind2/rafind2 . \
    && cp /radare2/src/binr/ragg2/ragg2 . \
    && cp /radare2/src/binr/rahash2/rahash2 . \
    && cp /radare2/src/binr/rarun2/rarun2 . \
    && cp /radare2/src/binr/rasign2/rasign2 . \
    && cp /radare2/src/binr/rasm2/rasm2 . \
    && cp /radare2/src/binr/ravc2/ravc2 . \
    && cp /radare2/src/binr/rax2/rax2 .


ENV CC=clang-14 CFLAGS="-O2"
WORKDIR /radare2/src
RUN make clean && ./configure && make
WORKDIR /radare2/build-clang-02
RUN cp -r /radare2/src/libr/**/*.so . \
    && cp /radare2/src/binr/r2agent/r2agent . \
    && cp /radare2/src/binr/r2pm/r2pm . \
    && cp /radare2/src/binr/r2r/r2r . \
    && cp /radare2/src/binr/rabin2/rabin2 . \
    && cp /radare2/src/binr/radare2/radare2 . \
    && cp /radare2/src/binr/radiff2/radiff2 . \
    && cp /radare2/src/binr/rafind2/rafind2 . \
    && cp /radare2/src/binr/ragg2/ragg2 . \
    && cp /radare2/src/binr/rahash2/rahash2 . \
    && cp /radare2/src/binr/rarun2/rarun2 . \
    && cp /radare2/src/binr/rasign2/rasign2 . \
    && cp /radare2/src/binr/rasm2/rasm2 . \
    && cp /radare2/src/binr/ravc2/ravc2 . \
    && cp /radare2/src/binr/rax2/rax2 .


ENV CC=clang-14 CFLAGS="-O3"
WORKDIR /radare2/src
RUN make clean && ./configure && make
WORKDIR /radare2/build-clang-03
RUN cp -r /radare2/src/libr/**/*.so . \
    && cp /radare2/src/binr/r2agent/r2agent . \
    && cp /radare2/src/binr/r2pm/r2pm . \
    && cp /radare2/src/binr/r2r/r2r . \
    && cp /radare2/src/binr/rabin2/rabin2 . \
    && cp /radare2/src/binr/radare2/radare2 . \
    && cp /radare2/src/binr/radiff2/radiff2 . \
    && cp /radare2/src/binr/rafind2/rafind2 . \
    && cp /radare2/src/binr/ragg2/ragg2 . \
    && cp /radare2/src/binr/rahash2/rahash2 . \
    && cp /radare2/src/binr/rarun2/rarun2 . \
    && cp /radare2/src/binr/rasign2/rasign2 . \
    && cp /radare2/src/binr/rasm2/rasm2 . \
    && cp /radare2/src/binr/ravc2/ravc2 . \
    && cp /radare2/src/binr/rax2/rax2 .

CMD ["/bin/bash"]
