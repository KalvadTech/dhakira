#!/usr/bin/env bash

docker run --rm -it -v $(pwd):/workspace -w /workspace crystallang/crystal:latest-alpine \
    crystal build --static src/dhakira.cr
