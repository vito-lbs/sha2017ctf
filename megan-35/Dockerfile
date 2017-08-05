FROM ubuntu:16.04
RUN dpkg --add-architecture i386 && apt-get update && apt-get install libc6:i386 libstdc++6:i386
RUN mkdir /megan-35
WORKDIR /megan-35
ADD . /megan-35
