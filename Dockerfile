FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update \
  && apt-get install --yes --quiet --no-install-recommends \
    ghostscript \
    graphicsmagick \
    libcairo2 \
    libgraphicsmagick++3 \
    libgraphicsmagick-q16-3 \
    libnetpbm10 \
    libpoppler-cpp0v5 \
    libpotrace0 \
    libxml2 \
    tesseract-ocr \
    tesseract-ocr-eng \
    zlib1g \
    wget \
    lzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG OSRA_VERSION=2.1.3
ARG GOCR_VERSION=0.50pre-patched
ARG OCRAD_VERSION=0.23
ARG OPENBABEL_VERSION=3-0-0-patched

# Install osra and its dependencies
RUN build_deps="\
    build-essential \
    cmake \
    libcairo2-dev \
    libeigen3-dev \
    libgraphicsmagick++1-dev \
    libgraphicsmagick1-dev \
    libnetpbm10-dev \
    libpoppler-cpp-dev \
    libpoppler-dev \
    libpotrace-dev \
    libtclap-dev \
    libtesseract-dev \
    lzip \
    wget \
    zlib1g-dev" \
  && apt-get update \
  && apt-get install --yes --quiet $build_deps
  # Install build and fetch dependencies
  # Install openbabel
  RUN wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/openbabel-patched/openbabel-$OPENBABEL_VERSION.tgz | tar -zxvf - -C /tmp \
  && mkdir -p /tmp/openbabel-$OPENBABEL_VERSION/build \
  && cd /tmp/openbabel-$OPENBABEL_VERSION/build \
  && cmake .. \
  && make -j $(nproc) && make install 
  # Install ocrad
  RUN wget --quiet --output-document=- http://ftp.gnu.org/gnu/ocrad/ocrad-$OCRAD_VERSION.tar.lz | tar --lzip -xvf - -C /tmp \
  && cd /tmp/ocrad-$OCRAD_VERSION \
  && ./configure CXXFLAGS="-Wall -W -O2 -pthread" \
  && make -j $(nproc) && make install 
  # Install gocr
  RUN wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/gocr-patched/gocr-$GOCR_VERSION.tgz | tar -zxvf - -C /tmp \
  && cd /tmp/gocr-$GOCR_VERSION \
  && ./configure CFLAGS="-g -O2 -pthread" \
  && make -j $(nproc) libs && make all install 
  # Install osra
  RUN wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/osra/${OSRA_VERSION%-*}/osra-$OSRA_VERSION.tgz | tar -zxvf - -C /tmp \
  && cd /tmp/osra-$OSRA_VERSION \
  && ./configure --with-tesseract CXXFLAGS="-g -O2 -pthread" \
  && make -j $(nproc) all install \
  && cd / && rm -rf /tmp/*
  # Uninstall build and fetch dependencies
  RUN apt-get purge --yes --auto-remove $build_deps \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

WORKDIR /var/local

CMD ["osra", "--help"]
