FROM debian:wheezy

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    wget \
    tar \
    xz-utils \
  && apt-get clean \
  && rm -rf /var/lib/{dpkg,apt,cache,log}

COPY scripts/mkimage-alpine.sh /mkimage.sh
COPY scripts/apk-install /apk-install

ENTRYPOINT ["/mkimage.sh"]
