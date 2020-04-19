# daverona/osra

[![pipeline status](https://gitlab.com/daverona/docker/osra/badges/master/pipeline.svg)](https://gitlab.com/daverona/docker/osra/commits/master)

* GitLab source respository: [https://gitlab.com/daverona/docker/osra](https://gitlab.com/daverona/docker/osra)
* Docker Hub repository: [https://hub.docker.com/r/daverona/osra](https://hub.docker.com/r/daverona/osra)

This is a Docker image of OSRA (Optical Structure Recognition Application). This image provides:

* [OSRA](https://sourceforge.net/projects/osra/) 2.1.0_1

## Installation

Install [Docker](https://hub.docker.com/search/?type=edition&offering=community) if you don't have one. 
Then pull the image from Docker Hub repository:

```bash
docker image pull daverona/osra
```

or build the image:

```bash
docker image build \
  --tag daverona/osra \
  .
```

## Quickstart

Run the container:

```bash
docker container run --rm \
  daverona/osra
```

It will show the help of OSRA.

## Usage

Assume you want to read `/path/to/input/sample.png`
to produce an SMI file, say `/path/to/output/sample.smi`.

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
* Docker image by `berlinguyinca/osra`: [https://hub.docker.com/r/berlinguyinca/osra/](https://hub.docker.com/r/berlinguyinca/osra/)
