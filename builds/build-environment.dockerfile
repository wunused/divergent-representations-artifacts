FROM ubuntu:22.04

# Configure timezone so that tzdata dependency does not require user input to
# configure.
# Reference: https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install common dependencies and pin compiler major versions.
RUN apt-get update && apt-get install build-essential gcc-11 clang-14 make git -y
