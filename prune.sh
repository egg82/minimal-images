#!/usr/bin/env bash

docker container prune -f
docker image prune -a -f
docker volume prune -a -f
