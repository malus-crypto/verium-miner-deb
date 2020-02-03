FROM ubuntu:18.04

ADD pkg /pkg/
ADD patch /patch/

# Setup build env
RUN set -ex \
    && sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
               git \
               automake \
               autoconf \
               pkg-config \
               libcurl4-openssl-dev \
               libjansson-dev \
               libssl-dev \
               libgmp-dev \
               zlib1g-dev \
               build-essential \
               cdbs \
               devscripts \
               equivs \
               fakeroot \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*


# Build miner w/ native optimisation 
RUN set -ex \
    && git clone https://github.com/fireworm71/veriumMiner \
    && cd veriumMiner \
    && ./build.sh > /dev/null 2>&1 \
    && mv cpuminer /pkg/usr/share/verium/cpuminer-opt


# Build miner w/o native optimisation
RUN set -ex \
    && cp /patch/* veriumMiner/ \
    && cd veriumMiner \
    && ./build.sh > /dev/null 2>&1 \
    && mv cpuminer /pkg/usr/share/verium/

RUN dpkg-deb --build pkg
