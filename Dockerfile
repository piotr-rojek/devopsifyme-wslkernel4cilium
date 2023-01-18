# build the kernel with additional flags
FROM ubuntu:latest AS compile
ENV KERNEL_ORIGIN='https://github.com/microsoft/WSL2-Linux-Kernel.git'
ENV KERNEL_BRANCH='linux-msft-wsl-5.15.y'

RUN apt-get update && apt-get -y install git python3 bc build-essential flex bison dwarves libssl-dev libelf-dev

COPY docker/build.sh /
CMD ["/bin/bash", "/build.sh"]