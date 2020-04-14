FROM ubuntu:14.04

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Install dependencies 
RUN apt-get update \
  && apt-get install --yes --quiet --no-install-recommends \
    libgraphicsmagick++-dev \
    libnetpbm10-dev \
    libocrad-dev \
    libopenbabel-dev  \
    libpotrace0  \
    libpotrace-dev  \
    libtclap-dev \
    openbabel \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install osra
ARG OCRAD_VERSION=0.27
ARG GOCR_VERSION=0.50pre-patched
ARG OSRA_VERSION=2.0.1
RUN build_deps="\
    build-essential \
    lzip \
    wget" \
  && apt-get update \
  && apt-get install --yes --quiet $build_deps \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  # Install ocrad
  && cd /tmp \
  && wget --quiet --output-document=- http://ftp.gnu.org/gnu/ocrad/ocrad-$OCRAD_VERSION.tar.lz | tar --lzip -xvf - \
  && cd /tmp/ocrad-$OCRAD_VERSION \
  && ./configure CXXFLAGS="-Wall -W -O2 -pthread" \
  && make && make install \
  && cd /tmp && rm -rf /tmp/* \
  # Install gocr
  && wget --quiet --output-document=- http://cactus.nci.nih.gov/osra/gocr-$GOCR_VERSION.tgz | tar -zxvf - \
  && cd /tmp/gocr-$GOCR_VERSION \
  && ./configure CFLAGS="-g -O2 -pthread" \
  && make libs && make all install \
  && cd /tmp && rm -rf /tmp/* \
  # Install osra
  && wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/osra/$OSRA_VERSION/osra-$OSRA_VERSION.tgz | tar -zxvf - \
  && cd /tmp/osra-$OSRA_VERSION \
  && ./configure CXXFLAGS="-g -O2 -pthread" \
  && make all && make install \
  && cd / && rm -rf /tmp/* \
  && apt-get purge --yes --auto-remove $build_deps

WORKDIR /var/local

CMD ["/usr/local/bin/osra", "--help"]
