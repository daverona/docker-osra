# osra

This repository provides Docker image converting a chemical compound in PDF/PNG/TIFF format to SMI (SMILES) file.

To be exact this repository gives Docker image wrapping *Optical Structure Recognition Application* (or *OSRA* for short).

## Docker image

To build Docker image out of this repository:

```bash
docker image build \
  --tag arontier/osra:2.1.0-1 \
  .
```

## Quickstart

To get help:

```bash
docker container run \
  --rm \
  arontier/osra:2.1.0-1
```

Assume you want to read `/path/to/input/sample.png`
to produce an SMI file, say `/path/to/output/sample.smi`.

To achieve this:

```bash
docker container run \
  --rm \
  --volume /path/to/input:/input \
  --volume /path/to/output:/output \
  arontier/osra:2.1.0-1 \
  osra \
    --write /output/sample.smi \
    /input/sample.png 
```

## References

* OSRA: [https://sourceforge.net/projects/osra/](https://sourceforge.net/projects/osra/)
* OSRA Online: [https://cactus.nci.nih.gov/cgi-bin/osra/index.cgi](https://cactus.nci.nih.gov/cgi-bin/osra/index.cgi)
* Docker image by `berlinguyinca/osra`: [https://hub.docker.com/r/berlinguyinca/osra/](https://hub.docker.com/r/berlinguyinca/osra/)
