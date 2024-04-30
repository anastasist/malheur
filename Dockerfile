FROM aflplusplus/aflplusplus:latest as builder

RUN apt update && apt install gcc libconfig9 libconfig-dev libarchive-dev automake autoconf libtool -fy

# Instead run in the root dir of the already-cloned repo
# RUN git clone -q https://github.com/rieck/malheur.git /malheur

COPY . /malheur

WORKDIR /malheur

RUN ./bootstrap && ./configure CC=afl-gcc && make && make install

RUN mkdir /inputs && echo foo > /inputs/foo

# CMD ["afl-fuzz", "-i", "/inputs", "-o", "/output", "--", "/usr/local/malheur", "@@"]

LABEL org.opencontainers.image.source=https://github.com/anastasist/malheur
