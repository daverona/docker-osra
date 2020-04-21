# daverona/osra

[![pipeline status](https://gitlab.com/daverona/docker/osra/badges/master/pipeline.svg)](https://gitlab.com/daverona/docker/osra/commits/master)

This is a repository for Docker images of OSRA (Optical Structure Recognition Application).

* GitLab source respository: [https://gitlab.com/daverona/docker/osra](https://gitlab.com/daverona/docker/osra)
* Docker Hub repository: [https://hub.docker.com/r/daverona/osra](https://hub.docker.com/r/daverona/osra)

Available versions are:

* [2.1.0-1](https://gitlab.com/daverona/docker/osra/-/blob/2.1.0-1/Dockerfile), [latest](https://gitlab.com/daverona/docker/osra/-/blob/latest/Dockerfile)

## Installation

Pull the image from Docker Hub repository:

```bash
docker image pull daverona/osra
```

## Quick Start

To see the help:

```bash
docker container run --rm \
  daverona/osra
```

## Usage

Assume you want to read `/path/to/input/sample.png`
to produce an SMI file `/path/to/output/sample.smi`.

To achieve this:

```bash
docker container run \
  --rm \
  --volume /path/to/input:/input \
  --volume /path/to/output:/output \
  daverona/osra \
  osra \
    --write /output/sample.smi \
    /input/sample.png 
```

## References

* OSRA: [https://sourceforge.net/projects/osra/](https://sourceforge.net/projects/osra/)
* OSRA Online: [https://cactus.nci.nih.gov/cgi-bin/osra/index.cgi](https://cactus.nci.nih.gov/cgi-bin/osra/index.cgi)
