#!/usr/bin/env bash

# https://github.com/actualbudget/actual/blob/master/sync-server.Dockerfile

APP_VERSION=v25.8.0

VOLUMES=( data )

for vol in "${VOLUMES[@]}"; do
  docker volume create "$vol"
  docker run --rm -v "$vol":/data alpine:latest sh -c "chown -R 1000:1000 /data"
done

docker build --build-arg APP_VERSION=$APP_VERSION -t actualbudget:test-minimal --file Dockerfile-ubi9-minimal .
docker run -p 127.0.0.1:5006:5006 -v data:/data --rm actualbudget:test-minimal

docker build --build-arg APP_VERSION=$APP_VERSION -t actualbudget:test-micro --file Dockerfile-ubi9-micro .
docker run -p 127.0.0.1:5006:5006 -v data:/data --rm actualbudget:test-micro

docker build --build-arg APP_VERSION=$APP_VERSION -t actualbudget:test-scratch --file Dockerfile-scratch .
docker run -p 127.0.0.1:5006:5006 -v data:/data --rm actualbudget:test-scratch

docker build --build-arg APP_VERSION=$APP_VERSION -t actualbudget:test-alpine --file Dockerfile-alpine .
docker run -p 127.0.0.1:5006:5006 -v data:/data --rm actualbudget:test-alpine

for vol in "${VOLUMES[@]}"; do
  docker volume rm "$vol"
done
