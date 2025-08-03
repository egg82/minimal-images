#!/usr/bin/env bash

# https://github.com/plexguide/Huntarr.io/blob/main/Dockerfile

APP_VERSION=8.1.15

VOLUMES=( config )

for vol in "${VOLUMES[@]}"; do
  docker volume create "$vol"
  docker run --rm -v "$vol":/data alpine:latest sh -c "chown -R 1000:1000 /data"
done

docker build --build-arg APP_VERSION=$APP_VERSION -t huntarr:test-minimal --file Dockerfile-ubi9-minimal .
docker run -p 127.0.0.1:9705:9705 -v config:/config --rm huntarr:test-minimal

docker build --build-arg APP_VERSION=$APP_VERSION -t huntarr:test-micro --file Dockerfile-ubi9-micro .
docker run -p 127.0.0.1:9705:9705 -v config:/config --rm huntarr:test-micro

docker build --build-arg APP_VERSION=$APP_VERSION -t huntarr:test-scratch --file Dockerfile-scratch .
docker run -p 127.0.0.1:9705:9705 -v config:/config --rm huntarr:test-scratch

docker build --build-arg APP_VERSION=$APP_VERSION -t huntarr:test-alpine --file Dockerfile-alpine .
docker run -p 127.0.0.1:9705:9705 -v config:/config --rm huntarr:test-alpine

for vol in "${VOLUMES[@]}"; do
  docker volume rm "$vol"
done
