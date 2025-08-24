#!/usr/bin/env bash

# https://github.com/searxng/searxng/blob/master/container/builder.dockerfile

APP_VERSION=11ea1a8

VOLUMES=( config data )

for vol in "${VOLUMES[@]}"; do
  docker volume create "$vol"
  docker run --rm -v "$vol":/data alpine:latest sh -c "chown -R 1000:1000 /data"
done

docker build --build-arg APP_VERSION=$APP_VERSION -t searxng:test-minimal --file Dockerfile-ubi9-minimal .
docker run -p 127.0.0.1:8080:8080 -v config:/etc/searxng -v data:/var/cache/searxng -e SEARXNG_SECRET="$(openssl rand -hex 32)" --rm searxng:test-minimal

docker build --build-arg APP_VERSION=$APP_VERSION -t searxng:test-micro --file Dockerfile-ubi9-micro .
docker run -p 127.0.0.1:8080:8080 -v config:/etc/searxng -v data:/var/cache/searxng -e SEARXNG_SECRET="$(openssl rand -hex 32)" --rm searxng:test-micro

docker build --build-arg APP_VERSION=$APP_VERSION -t searxng:test-scratch --file Dockerfile-scratch .
docker run -p 127.0.0.1:8080:8080 -v config:/etc/searxng -v data:/var/cache/searxng -e SEARXNG_SECRET="$(openssl rand -hex 32)" --rm searxng:test-scratch

docker build --build-arg APP_VERSION=$APP_VERSION -t searxng:test-alpine --file Dockerfile-alpine .
docker run -p 127.0.0.1:8080:8080 -v config:/etc/searxng -v data:/var/cache/searxng -e SEARXNG_SECRET="$(openssl rand -hex 32)" --rm searxng:test-alpine

for vol in "${VOLUMES[@]}"; do
  docker volume rm "$vol"
done
