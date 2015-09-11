FROM alpine:latest
COPY scripts/mkimage-alpine.bash scripts/apk-install /
RUN /apk-install bash tzdata
ENTRYPOINT ["/mkimage-alpine.bash"]
