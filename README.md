# Docker image for IBM OpenAPI Validator

A small Docker image that packages [IBM's OpenAPI
Validator](https://github.com/IBM/openapi-validator/) so it can be run without
installing Node.js or npm locally.

> This is a community-maintained fork of
> [jamescooke/openapi-validator-docker](https://github.com/jamescooke/openapi-validator-docker),
> which was archived in 2023. The image is published to Docker Hub as
> [`gblix/openapi-validator`](https://hub.docker.com/r/gblix/openapi-validator).

## Run

The image's entrypoint is `lint-openapi`, so any arguments you pass to
`docker run` are forwarded straight to the validator. The container's working
directory is `/data`, so mount the directory containing your spec there.

* To validate a specification file `openapi.yaml` in the current directory:

  ```sh
  docker run \
       --volume "$PWD":/data \
       gblix/openapi-validator openapi.yaml
  ```

* To use a configuration file (`*.json`, `*.yaml`, or `*.js`), pass it with the
  `-c` / `--config` flag:

  ```sh
  docker run \
       --volume "$PWD":/data \
       gblix/openapi-validator openapi.yaml --config config.yaml
  ```

* To see all available options:

  ```sh
  docker run gblix/openapi-validator --help
  ```

  See the [validator
  documentation](https://github.com/IBM/openapi-validator#configuration) for
  details on configuration and the default IBM Cloud Validation Ruleset.

## Container

* This is a "small-ish" container built on the official [Node
  Alpine](https://hub.docker.com/_/node/) base image.

* The OpenAPI validator is installed in the container using `npm`.

* Image tags are kept synchronised with the version of OpenAPI validator. For
  example, image `1.37.14` contains [OpenAPI validator version
  `1.37.14`](https://github.com/IBM/openapi-validator/releases/tag/ibm-openapi-validator%401.37.14):

  ```sh
  $ docker run gblix/openapi-validator:1.37.14 --version
  validator: 1.37.14; ruleset: 1.33.10 (default)
  ```

## Releasing

The validator version is pinned via the `version` build argument in the
[`Dockerfile`](Dockerfile). To publish a new image:

1. Bump the `version` argument to the desired
   [`ibm-openapi-validator` release](https://github.com/IBM/openapi-validator/releases),
   then commit and merge to `master`. The
   [release-check workflow](.github/workflows/create_pr_for_release.yml) does
   this automatically: it runs daily, checks npm for the latest
   `ibm-openapi-validator` release, and opens a bump PR when a newer version is
   available (it can also be triggered manually from the Actions tab).
2. Publish a [GitHub release](../../releases) tagged with the matching version
   (e.g. `1.37.14`).

The [Docker Image CI workflow](.github/workflows/docker-image.yml) builds and
pushes the image to Docker Hub on every published release.

## Links

* OpenAPI Validator:
    [repository](https://github.com/IBM/openapi-validator/),
    [releases](https://github.com/IBM/openapi-validator/releases)

* Docker image: [Docker
    Hub](https://hub.docker.com/r/gblix/openapi-validator)

## Thanks

* [Dustin](https://github.com/dpopp07) and the IBM team for their hard work on
    the OpenAPI Validator tool.

* [James Cooke](https://github.com/jamescooke) for creating and maintaining the
    original image this fork is based on.
