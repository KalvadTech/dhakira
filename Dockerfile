# Build image
FROM crystallang/crystal:1-alpine as builder
WORKDIR /app

# Cache dependencies
COPY ./shard.yml ./shard.lock /app/
RUN shards install --production -v

# Build a binary
COPY . /app/
RUN shards build --static --no-debug --release --production -v
