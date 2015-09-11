FROM alpine:3.2
COPY scripts/mkimage-alpine.bash scripts/apk-install /
RUN /apk-install bash tzdata
ENTRYPOINT ["/mkimage-alpine.bash"]
