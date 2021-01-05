FROM alpine:3.12.3

MAINTAINER Josef (kwart) Cacek <josef.cacek@gmail.com>

COPY bashrc /

RUN echo "Setting edge repositories" \
    && apk upgrade --update-cache --available \
    && echo "Installing APK packages" \
    && apk add bash openssh git \
    && echo "Cleaning APK cache" \
    && rm -rf /var/cache/apk/*

CMD ["/bin/bash"]
