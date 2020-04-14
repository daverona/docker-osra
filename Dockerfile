FROM ubuntu:14.04

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

# Install build and fetch dependencies

# We have quiet an unfortunate situation: according to Dockerfile philosophy,
# each layer needs to be independent, which translates into install and uninstall
# build and fetch dependencies for each of the following ocrad, gocr, and osra.
# This however causes nontrivial network traffics and takes a lot of time.
# So we break the philosophy of Dockerfile (this is the unfortunate bit 
# I am talking about): install dependencies here and remove them later.

ARG __build_deps="build-essential lzip wget"
RUN apt-get update \
  && apt-get install --yes --quiet $__build_deps \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install ocrad
ARG OCRAD_VERSION=0.25
RUN cd /tmp \
  && wget --quiet --output-document=- http://ftp.gnu.org/gnu/ocrad/ocrad-$OCRAD_VERSION.tar.lz | tar --lzip -xvf - \
  && cd /tmp/ocrad-$OCRAD_VERSION \
  && ./configure CXXFLAGS="-Wall -W -O2 -pthread" \
  && make && make install \
  && cd / && rm -rf /tmp/*

# Install gocr
ARG GOCR_VERSION=0.50pre-patched
RUN cd /tmp \
  && wget --quiet --output-document=- http://cactus.nci.nih.gov/osra/gocr-$GOCR_VERSION.tgz | tar -zxvf - \
  && cd /tmp/gocr-$GOCR_VERSION \
  && ./configure CFLAGS="-g -O2 -pthread" \
  && make libs && make all install \
  && cd / && rm -rf /tmp/*

# Install osra
ARG OSRA_VERSION=2.0.1
RUN cd /tmp \
  && wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/osra/$OSRA_VERSION/osra-$OSRA_VERSION.tgz | tar -zxvf - \
  && cd /tmp/osra-$OSRA_VERSION \
  && ./configure CXXFLAGS="-g -O2 -pthread" \
  && make all && make install \
  && cd / && rm -rf /tmp/*

RUN apt-get purge --yes --auto-remove $__build_deps

CMD ["/usr/local/bin/osra", "--help"]
