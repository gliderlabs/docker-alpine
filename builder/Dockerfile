FROM alpine:latest
COPY scripts/mkimage-alpine.bash scripts/apk-install /
RUN apk add --no-cache bash tzdata xz
ENTRYPOINT ["/mkimage-alpine.bash"]
