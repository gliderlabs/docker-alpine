FROM debian:wheezy
RUN apt-get update && apt-get install -y curl wget tar
COPY scripts/mkimage-alpine.bash scripts/apk-install /
ENTRYPOINT ["/mkimage-alpine.bash"]
