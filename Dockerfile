FROM aflplusplus/aflplusplus:latest as builder

RUN apt update && apt install gcc libconfig9 libconfig-dev libarchive-dev automake autoconf libtool -fy

# Instead run in the root dir of the already-cloned repo
# RUN git clone -q https://github.com/rieck/malheur.git /malheur

COPY . /malheur

WORKDIR /malheur

RUN ./bootstrap && ./configure CC=afl-gcc && make && make install

RUN mkdir /inputs

# Get official sample dataset and take one sample for input seed
RUN mkdir /dataset

WORKDIR /dataset

RUN wget https://www.sec.cs.tu-bs.de/data/malheur/reference/reference_mist.tar.gz --no-check-certificate

RUN tar -zxvf /dataset/reference_mist.tar.gz && mkdir /dataset/trimmed

RUN cp /dataset/refset/005* /dataset/trimmed && tar -zcvf /inputs/trimmed_dataset.tar.gz /dataset/trimmed

RUN rm -rf /dataset

WORKDIR /malheur

CMD ["afl-fuzz", "-i", "/inputs", "-o", "/output", "-V", "300", "--", "/usr/local/bin/malheur", "-o", "/tmp/malheur.out", "distance", "@@"]

LABEL org.opencontainers.image.source=https://github.com/anastasist/malheur
