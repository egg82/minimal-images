#!/usr/bin/env bash

# https://github.com/linuxserver/docker-qbittorrent/blob/master/Dockerfile

APP_VERSION=5.1.2_v2.0.11

VOLUMES=( config )

for vol in "${VOLUMES[@]}"; do
  docker volume create "$vol"
  docker run --rm -v "$vol":/data alpine:latest sh -c "chown -R 1000:1000 /data"
done

docker build --build-arg APP_VERSION=$APP_VERSION -t qbittorrent:test-minimal --file Dockerfile-ubi9-minimal .
docker run -p 127.0.0.1:8080:8080 -v config:/config --rm qbittorrent:test-minimal

docker build --build-arg APP_VERSION=$APP_VERSION -t qbittorrent:test-micro --file Dockerfile-ubi9-micro .
docker run -p 127.0.0.1:8080:8080 -v config:/config --rm qbittorrent:test-micro

docker build --build-arg APP_VERSION=$APP_VERSION -t qbittorrent:test-scratch --file Dockerfile-scratch .
docker run -p 127.0.0.1:8080:8080 -v config:/config --rm qbittorrent:test-scratch

docker build --build-arg APP_VERSION=$APP_VERSION -t qbittorrent:test-alpine --file Dockerfile-alpine .
docker run -p 127.0.0.1:8080:8080 -v config:/config --rm qbittorrent:test-alpine

for vol in "${VOLUMES[@]}"; do
  docker volume rm "$vol"
done
