FROM scratch
ADD rootfs.tar.xz /
# ensure UTC instead of the default GMT
COPY UTC /etc/localtime
CMD ["/bin/sh"]
