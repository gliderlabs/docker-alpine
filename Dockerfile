FROM scratch
ADD rootfs.tar.xz /
COPY scripts/apk-install /usr/sbin/apk-install
