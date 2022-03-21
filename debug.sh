#!/usr/bin/env bash
set -e
set -x
docker pull crystal:latest-alpine
docker run --rm -it -v $(pwd):/workspace -w /workspace crystallang/crystal:latest-alpine \
    crystal build --debug src/dhakira.cr
