FROM ubuntu:16.04
RUN dpkg --add-architecture i386 && apt-get update && apt-get install libc6:i386 libstdc++6:i386
RUN mkdir /suspectfile1
WORKDIR /suspectfile1
ADD . /suspectfile1
