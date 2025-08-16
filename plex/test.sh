#!/usr/bin/env bash

# https://github.com/plexinc/pms-docker/blob/master/Dockerfile

APP_VERSION=1.42.1.10060-4e8b05daf

VOLUMES=( config )

for vol in "${VOLUMES[@]}"; do
  docker volume create "$vol"
  docker run --rm -v "$vol":/data alpine:latest sh -c "chown -R 1000:1000 /data"
done

docker build --build-arg APP_VERSION=$APP_VERSION -t plex:test-minimal --file Dockerfile-ubi9-minimal .
docker run -p 127.0.0.1:32400:32400 -v config:/config --rm plex:test-minimal

docker build --build-arg APP_VERSION=$APP_VERSION -t plex:test-micro --file Dockerfile-ubi9-micro .
docker run -p 127.0.0.1:32400:32400 -v config:/config --rm plex:test-micro

docker build --build-arg APP_VERSION=$APP_VERSION -t plex:test-scratch --file Dockerfile-scratch .
docker run -p 127.0.0.1:32400:32400 -v config:/config --rm plex:test-scratch

for vol in "${VOLUMES[@]}"; do
  docker volume rm "$vol"
done
