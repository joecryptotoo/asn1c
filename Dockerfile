FROM debian:bullseye AS base

ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
    libpcap0.8 \
    libldns3 \
    libssl1.1 \
    zlib1g \
    libyaml-perl \
    gnupg \
    lsb-release \
    psmisc \
    procps \
    build-essential \
    autoconf \
    libtool \
    git \
    libpcap-dev \
    libldns-dev \
    zlib1g-dev \
    libssl-dev \
    wget \
    bsdextrautils

WORKDIR /usr/local/src
RUN git clone https://github.com/vlm/asn1c.git
WORKDIR /usr/local/src/asn1c
RUN test -f configure || autoreconf -iv && \
	./configure && \
	make install

WORKDIR /usr/local/src/asn1c/examples
RUN wget https://raw.githubusercontent.com/proj3rd/3gpp-specs/master/36-series/36331/36331-f22.asn1 \
    -O lte-rrc-14.2.1.asn1

WORKDIR /usr/local/src/asn1c/examples/sample.source.LTE-RRC
RUN make || exit 0
# ./lte-rrc-dump -p BCCH-DL-SCH-Message
