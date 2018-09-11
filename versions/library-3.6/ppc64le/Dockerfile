FROM scratch
ADD rootfs.tar.gz /
# ensure UTC instead of the default GMT
COPY UTC /etc/localtime
CMD ["/bin/sh"]
