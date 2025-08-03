#!/usr/bin/env bash

# https://github.com/photoprism/photoprism/blob/250707-d28b3101e/docker/develop/plucky/Dockerfile

APP_VERSION=250707-d28b3101e

docker build --build-arg APP_VERSION=$APP_VERSION --build-arg PLATFORM=linux/amd64 -t photoprism:test-minimal --file Dockerfile-ubi9-minimal .
docker run --rm photoprism:test-minimal

docker build --build-arg APP_VERSION=$APP_VERSION --build-arg PLATFORM=linux/amd64 -t photoprism:test-micro --file Dockerfile-ubi9-micro .
docker run --rm photoprism:test-micro

docker build --build-arg APP_VERSION=$APP_VERSION --build-arg PLATFORM=linux/amd64 -t photoprism:test-scratch --file Dockerfile-scratch .
docker run --rm photoprism:test-scratch
