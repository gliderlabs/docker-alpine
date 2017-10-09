# docker-alpine

[![CircleCI](https://img.shields.io/circleci/project/gliderlabs/docker-alpine/release.svg)](https://circleci.com/gh/gliderlabs/docker-alpine)
[![Docker Stars](https://img.shields.io/docker/stars/gliderlabs/alpine.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/gliderlabs/alpine.svg)][hub]
[![Slack](http://glider-slackin.herokuapp.com/badge.svg)][slack]
[![ImageLayers](https://imagelayers.io/badge/gliderlabs/alpine:latest.svg)](https://imagelayers.io/?images=gliderlabs/alpine:latest 'Get your own badge on imagelayers.io')


A super small Docker image based on [Alpine Linux][alpine]. The image is only 5 MB and has access to a package repository that is much more complete than other BusyBox based images.

## Why?

Docker images today are big. Usually much larger than they need to be. There are a lot of ways to make them smaller, but the Docker populace still jumps to the `ubuntu` base image for most projects. The size savings over `ubuntu` and other bases are huge:

```
REPOSITORY          TAG           IMAGE ID          VIRTUAL SIZE
gliderlabs/alpine   3.6           9cfff538e583      3.962 MB
debian              latest        19134a8202e7      100.1 MB
ubuntu              latest        104bec311bcd      121.6 MB
centos              latest        67591570dd29      196.6 MB
```

There are images such as `progrium/busybox` which get us very close to a minimal container and package system. But these particular BusyBox builds piggyback on the OpenWRT package index which is often lacking and not tailored towards generic everyday applications. Alpine Linux has a much more complete and up to date [package index][alpine-packages]:

```console
$ docker run progrium/busybox opkg-install nodejs
Unknown package 'nodejs'.
Collected errors:
* opkg_install_cmd: Cannot install package nodejs.

$ docker run gliderlabs/alpine:3.6 apk add --no-cache nodejs
fetch http://alpine.gliderlabs.com/alpine/v3.6/main/x86_64/APKINDEX.tar.gz
fetch http://alpine.gliderlabs.com/alpine/v3.6/community/x86_64/APKINDEX.tar.gz
(1/8) Installing ca-certificates (20161130-r2)
(2/8) Installing libcrypto1.0 (1.0.2k-r0)
(3/8) Installing libgcc (6.3.0-r4)
(4/8) Installing http-parser (2.7.1-r1)
(5/8) Installing libssl1.0 (1.0.2k-r0)
(6/8) Installing libstdc++ (6.3.0-r4)
(7/8) Installing libuv (1.11.0-r1)
(8/8) Installing nodejs (6.10.3-r1)
Executing busybox-1.26.2-r5.trigger
Executing ca-certificates-20161130-r2.trigger
OK: 26 MiB in 19 packages
```

This makes Alpine Linux a great image base for utilities and even production applications. [Read more about Alpine Linux here][alpine-about] and you can see how their mantra fits in right at home with Docker images.

## Usage

Stop doing this:

```dockerfile
FROM ubuntu-debootstrap:14.04
RUN apt-get update -q \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy mysql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt
ENTRYPOINT ["mysql"]
```
This took 22 seconds to build and yields a 169 MB image. Eww. Start doing this:

```dockerfile
FROM gliderlabs/alpine:3.6
RUN apk add --no-cache mysql-client
ENTRYPOINT ["mysql"]
```

Only 5 seconds to build and results in a 36 MB image! Hooray!

## Documentation

This image is well documented. [Check out the documentation at Viewdocs][docs] and the `docs` directory in this repository.

## Contacts

We make reasonable efforts to support our work and are always happy to chat. Join us in [our Slack community][slack] or [submit a GitHub issue][issues] if you have a security or other general question about this Docker image. Please email [security](http://lists.alpinelinux.org/alpine-security/summary.html) or [user](http://lists.alpinelinux.org/alpine-user/summary.html) mailing lists if you have concerns specific to Alpine Linux.

## Inspiration

The motivation for this project and modifications to `mkimage.sh` are highly inspired by Eivind Uggedal (uggedal) and Luis Lavena (luislavena). They have made great strides in getting Alpine Linux running as a Docker container. Check out their [mini-container/base][mini-base] image as well.

## Sponsors

[![Fastly](https://github.com/gliderlabs/docker-alpine/raw/master/logo_fastly.png)][fastly]

[Fastly][fastly] provides the CDN for our Alpine Linux package repository. This is allows super speedy package downloads from all over the globe!

## License

The code in this repository, unless otherwise noted, is BSD licensed. See the `LICENSE` file in this repository.

[mini-base]: https://github.com/mini-containers/base
[alpine-packages]: http://pkgs.alpinelinux.org/
[alpine-about]: https://www.alpinelinux.org/about/
[docs]: http://gliderlabs.viewdocs.io/docker-alpine
[slack]: http://glider-slackin.herokuapp.com/
[issues]: https://github.com/gliderlabs/docker-alpine/issues
[alpine]: http://alpinelinux.org/
[fastly]: https://www.fastly.com/
[hub]: https://hub.docker.com/r/gliderlabs/alpine/
<img src="https://ga-beacon.appspot.com/UA-58928488-2/docker-alpine/readme?pixel" />
