# [Alpine Redis Docker Images](https://hub.docker.com/r/jamespedwards42/alpine-redis/)

## Supported Tags
All images are FROM alpine:latest
* [`3.2`](3.2/Dockerfile)
* [`unstable`](unstable/Dockerfile)

## Docker Run
```shell
docker run -d \
  --name redis-6379 \
  -v /host/dir:/redis/data \
  -p 6379:6379/tcp \
    jamespedwards42/alpine-redis:unstable \
      --port 6379 \
      --protected-mode no \
      --logfile redis-6379.log \
```

## Docker Compose
```yaml
version: '2'

services:
  redis-6379:
    ports:
      - "6379:6379"
    volumes:
      - /host/dir/redis/modules:/redis/modules
      - /host/dir/redis/data:/redis/data
    image: jamespedwards42/alpine-redis:unstable
    command: ['--port', '6379', '--protected-mode', 'no', 'logfile', 'redis-6379.log']
```
