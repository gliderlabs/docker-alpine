FROM alpine:base
COPY scripts/mkimage-alpine.bash scripts/apk-install /
RUN apk update
RUN /apk-install bash tzdata
ENTRYPOINT ["/mkimage-alpine.bash"]
