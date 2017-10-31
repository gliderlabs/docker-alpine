FROM alpine:latest
COPY scripts/mkimage-alpine.bash /
RUN apk add --no-cache bash tzdata xz
ENTRYPOINT ["/mkimage-alpine.bash"]
