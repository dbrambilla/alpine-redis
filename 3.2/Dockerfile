FROM alpine:latest

RUN addgroup -S redis && adduser -S -G redis redis \
  && mkdir -p /redis/data /redis/modules \
  && chown redis:redis /redis/data /redis/modules

VOLUME /redis/modules
VOLUME /redis/data
WORKDIR /redis/data

ARG REDIS_BRANCH=3.2.3

RUN set -x \
  && apk add --no-cache --virtual .build-deps \
    curl \
    gcc \
    linux-headers \
    make \
    musl-dev \
    tar \
  && curl -o redis.tar.gz https://codeload.github.com/antirez/redis/tar.gz/"$REDIS_BRANCH" \
  && mkdir -p /usr/src/redis \
  && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
  && rm redis.tar.gz \
  && make -C /usr/src/redis \
  && make -C /usr/src/redis install \
  && rm -r /usr/src/redis \
  && apk del .build-deps

USER redis
ENTRYPOINT ["redis-server"]
CMD ["--help"]
