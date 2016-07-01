FROM alpine:latest

RUN addgroup -S redis && adduser -S -G redis redis \
  && mkdir -p /redis/data /redis/modules \
  && chown redis:redis /redis/data /redis/modules

VOLUME /redis/modules
VOLUME /redis/data
WORKDIR /redis/data

EXPOSE 6379

ENV REDIS_BRANCH 3.2.1
ENV REDIS_DOWNLOAD_URL https://codeload.github.com/antirez/redis/tar.gz/"$REDIS_BRANCH"

RUN set -x \
  && apk add --no-cache --virtual .build-deps \
    curl \
    gcc \
    linux-headers \
    make \
    musl-dev \
    tar \
  && curl -o redis.tar.gz "$REDIS_DOWNLOAD_URL" \
  && mkdir -p /usr/src/redis \
  && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
  && rm redis.tar.gz \
  && make -C /usr/src/redis \
  && make -C /usr/src/redis install \
  && rm -r /usr/src/redis \
  && apk del .build-deps

ENTRYPOINT ["redis-server"]
CMD ["--help"]
