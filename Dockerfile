ARG DOCKER_BASE_IMAGE
FROM $DOCKER_BASE_IMAGE
ARG VCS_REF
ARG BUILD_DATE
LABEL \
    maintainer="https://ocr-d.de/kontakt" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/OCR-D/ocrd_fileformat" \
    org.label-schema.build-date=$BUILD_DATE

ENV DEBIAN_FRONTEND noninteractive
ENV PREFIX=/usr/local

RUN apt-get update && apt-get install -y openjdk-11-jdk-headless wget git gcc unzip

WORKDIR /build/ocrd_fileformat

COPY .git .git/
COPY repo/ocr-fileformat repo/ocr-fileformat/
COPY ocrd-fileformat-transform .
COPY ocrd-tool.json .
COPY Makefile .

RUN make install-fileformat install PREFIX=$PREFIX SHELL="bash -x" && \
    rm -fr /build/ocrd_fileformat
# smoke test
RUN ocrd-fileformat-transform --version

WORKDIR /data
ENV DEBIAN_FRONTEND teletype

