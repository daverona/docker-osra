FROM alpine:3.10

ARG OSRA_VERSION=2.1.0-1
ARG GOCR_VERSION=0.50pre-patched
ARG OCRAD_VERSION=0.23
ARG OPENBABEL_VERSION=2.3.2-patched

ENV LANG=C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

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

# Install osra and its dependencies
RUN apk add --no-cache --virtual=build_deps \
# Install build and fetch dependencies
    bash \
#    boost-dev \
    build-base \
    cairo-dev \
    cmake \
    eigen-dev \
    graphicsmagick-dev \
    libxml2-dev \
    lzip \
    perl \
    poppler-dev \
    potrace-dev \
    tclap-dev \
    tesseract-ocr-dev \
    zlib-dev \
# Install openbabel
  && wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/openbabel-patched/openbabel-$OPENBABEL_VERSION.tgz | tar -zxvf - -C /tmp \
  && mkdir -p /tmp/openbabel-$OPENBABEL_VERSION/build \
  && cd /tmp/openbabel-$OPENBABEL_VERSION/build \
  && sed -i -e "27s/tr1::shared_ptr/shared_ptr/" ../include/openbabel/shared_ptr.h \
  && sed -i -e "117s/make_pair/pair/" -e "147s/make_pair/pair/" ../src/ops/sort.cpp \
  && sed -i -e "83s/iss >> value/(bool)(iss >> value)/" ../src/ops/conformer.cpp \
  && sed -i -e "642s/ifs!=NULL/ifs ? true : false/" ../src/formats/chemkinformat.cpp \
  && sed -i -e "82s/*ofs/*ofs ? true : false/" ../src/formats/textformat.cpp \
  && cmake .. \
  && make -j $(nproc) && make test && make install \
# Install ocrad
  && wget --quiet --output-document=- http://ftp.gnu.org/gnu/ocrad/ocrad-$OCRAD_VERSION.tar.lz | lzip -dc -o - | tar -xvf - -C /tmp \
  && cd /tmp/ocrad-$OCRAD_VERSION \
  && ./configure CXXFLAGS="-Wall -W -O2 -pthread" \
  && make -j $(nproc) && make install \
# Install gocr
  && wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/gocr-patched/gocr-$GOCR_VERSION.tgz | tar -zxvf - -C /tmp \
  && cd /tmp/gocr-$GOCR_VERSION \
  && ./configure CFLAGS="-g -O2 -pthread" \
  && make  libs && make -j $(nproc) all install \
# Install osra
  && wget --quiet --output-document=- http://downloads.sourceforge.net/project/osra/osra/${OSRA_VERSION%-*}/osra-$OSRA_VERSION.tgz | tar -zxvf - -C /tmp \
  && cd /tmp/osra-$OSRA_VERSION \
  && ./configure --with-tesseract CXXFLAGS="-g -O2 -pthread" \
  && make -j $(nproc) all install \
  && cd / && rm -rf /tmp/* \
# Uninstall build and fetch dependencies
  && apk del --no-cache build_deps

WORKDIR /var/local

CMD ["osra", "--help"]
