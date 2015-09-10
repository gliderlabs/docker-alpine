FROM alpine:latest
COPY scripts/mkimage-alpine.bash scripts/apk-install /
RUN /apk-install bash
ENTRYPOINT ["/mkimage-alpine.bash"]
