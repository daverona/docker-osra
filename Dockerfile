FROM alpine:3.10

ARG OSRA_VERSION=2.1.0-1
ARG GOCR_VERSION=0.50pre-patched
ARG OCRAD_VERSION=0.23
ARG OPENBABEL_VERSION=2.3.2-tr1-memory

ENV LANG=C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

# Install run-time dependencies 
RUN apk add --no-cache \
    cairo \
    eigen \
    ghostscript \
    graphicsmagick \
    libxml2 \
    poppler \
    potrace \
    tesseract-ocr \
    zlib 
#    libcairo2 \
#    libgraphicsmagick++3 \
#    libgraphicsmagick3 \
#    libnetpbm10 \
#    libpoppler-cpp0 \
#    libpoppler44 \
#    libpotrace0 \
#    libtesseract3 \
#    libxml2 \
#    tesseract-ocr \ 
#    tesseract-ocr-eng \
#    zlib1g \
#  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install osra and its dependencies
RUN apk add --no-cache --virtual=build_deps \
# Install build and fetch dependencies
    build-base \
    cairo-dev \
    cmake \
    eigen-dev \
    graphicsmagick-dev \
    libxml2-dev \
    lzip \
    poppler-dev \
    potrace-dev \
    tclap-dev \
    tesseract-ocr-dev \
    zlib-dev \
# Install openbabel
  && wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/openbabel-patched/openbabel-$OPENBABEL_VERSION.tgz | tar -zxvf - -C /tmp \
  && mkdir -p /tmp/openbabel-$OPENBABEL_VERSION/build && cd /tmp/openbabel-$OPENBABEL_VERSION/build \
  && cmake .. 
RUN wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/openbabel-patched/openbabel-2.3.2-patched.tgz | tar -zxvf - -C /tmp \
  && mkdir -p /tmp/openbabel-2.3.2-patched/build && cd /tmp/openbabel-2.3.2-patched/build \
  && cmake .. 
#  && make -j2 && make test && make install 
#    build-essential \
#    cmake \
#    libcairo2-dev \
#    libeigen3-dev \
#    libgraphicsmagick++1-dev \
#    libgraphicsmagick1-dev \
#    libnetpbm10-dev \
#    libpoppler-cpp-dev \
#    libpoppler-dev \
#    libpotrace-dev \
#    libtclap-dev \
#    libtesseract-dev \
#    lzip \
#    wget \
#    zlib1g-dev" \
#  && apt-get install --yes --quiet $build_deps \
#  && apt-get clean && rm -rf /var/lib/apt/lists/* \
# Install ocrad

RUN wget --quiet --output-document=- http://ftp.gnu.org/gnu/ocrad/ocrad-$OCRAD_VERSION.tar.lz | lzip -dc -o - | tar -xvf - -C /tmp \
  && cd /tmp/ocrad-$OCRAD_VERSION \
  && ./configure CXXFLAGS="-Wall -W -O2 -pthread" \
  && make && make install \
# Install gocr
  && wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/gocr-patched/gocr-$GOCR_VERSION.tgz | tar -zxvf - -C /tmp \
  && cd /tmp/gocr-$GOCR_VERSION \
  && ./configure CFLAGS="-g -O2 -pthread" \
  && make libs && make all install
# Install osra
#RUN wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/osra/${OSRA_VERSION%-*}/osra-$OSRA_VERSION.tgz | tar -zxvf - -C /tmp \
#  && cd /tmp/osra-$OSRA_VERSION \
#  && ./configure --with-tesseract CXXFLAGS="-g -O2 -pthread" 
#  && make all install \
#  && cd / && rm -rf /tmp/* \
# Uninstall build and fetch dependencies
#  && apt-get purge --yes --auto-remove $build_deps \
#  && apt-get autoremove --yes

WORKDIR /var/local

CMD ["osra", "--help"]
