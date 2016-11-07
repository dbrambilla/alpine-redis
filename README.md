# [Alpine Redis Docker Images](https://hub.docker.com/r/jamespedwards42/alpine-redis/) [![](https://images.microbadger.com/badges/image/jamespedwards42/alpine-redis.svg)](https://microbadger.com/images/jamespedwards42/alpine-redis "microbadger.com")

## Supported Tags

* [`3.2`](https://github.com/jamespedwards42/alpine-redis/blob/master/3.2/Dockerfile) FROM alpine:latest
* [`unstable`](https://github.com/jamespedwards42/alpine-redis/blob/master/unstable/Dockerfile) FROM alpine:edge

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
