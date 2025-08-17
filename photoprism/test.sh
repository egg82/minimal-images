#!/usr/bin/env bash

# https://github.com/photoprism/photoprism/blob/develop/docker/develop/plucky/Dockerfile

APP_VERSION=250707-d28b3101e

VOLUMES=( originals import storage )

for vol in "${VOLUMES[@]}"; do
  docker volume create "$vol"
  docker run --rm -v "$vol":/data alpine:latest sh -c "chown -R 1000:1000 /data"
done

docker build --build-arg APP_VERSION=$APP_VERSION -t photoprism:test-minimal --file Dockerfile-ubi9-minimal .
docker run -p 127.0.0.1:2342:2342 -v originals:/photoprism/originals -v import:/photoprism/import -v storage:/photoprism/storage --rm photoprism:test-minimal

docker build --build-arg APP_VERSION=$APP_VERSION -t photoprism:test-micro --file Dockerfile-ubi9-micro .
docker run -p 127.0.0.1:2342:2342 -v originals:/photoprism/originals -v import:/photoprism/import -v storage:/photoprism/storage --rm photoprism:test-micro

docker build --build-arg APP_VERSION=$APP_VERSION -t photoprism:test-scratch --file Dockerfile-scratch .
docker run -p 127.0.0.1:2342:2342 -v originals:/photoprism/originals -v import:/photoprism/import -v storage:/photoprism/storage --rm photoprism:test-scratch

for vol in "${VOLUMES[@]}"; do
  docker volume rm "$vol"
done
