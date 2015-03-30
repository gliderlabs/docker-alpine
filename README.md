# docker-alpine

[![CircleCI](https://img.shields.io/circleci/project/gliderlabs/docker-alpine/release.svg)](https://circleci.com/gh/gliderlabs/docker-alpine) [![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/gliderlabs/alpine/) [![IRC Channel](https://img.shields.io/badge/irc-%23gliderlabs-blue.svg)][irc]

A super small Docker image based on [Alpine Linux][alpine]. The image is only 5 MB and has access to a package repository that is much more complete than other BusyBox based images.

## Why?

Docker images today are big. Usually much larger than they need to be. There are a lot of ways to make them smaller. But the Docker populous still jumps to the `ubuntu` base image for most projects. The size savings over `ubuntu` and other bases are huge:

```
REPOSITORY          TAG           IMAGE ID          VIRTUAL SIZE
gliderlabs/alpine   latest        157314031a17      5.03 MB
debian              latest        4d6ce913b130      84.98 MB
ubuntu              latest        b39b81afc8ca      188.3 MB
centos              latest        8efe422e6104      210 MB
```

There are images such as `progrium/busybox` which get us very close to a minimal container and package system. But these particular BusyBox builds piggyback on the OpenWRT package index which is often lacking and not tailored towards generic everyday applications. Alpine Linux has a much more complete and update to date [package index][alpine-packages]:

```console
$ docker run progrium/busybox opkg-install nodejs
Unknown package 'nodejs'.
Collected errors:
* opkg_install_cmd: Cannot install package nodejs.

$ docker run gliderlabs/alpine apk --update add nodejs
fetch http://dl-4.alpinelinux.org/alpine/v3.1/main/x86_64/APKINDEX.tar.gz
(1/5) Installing c-ares (1.10.0-r1)
(2/5) Installing libgcc (4.8.3-r0)
(3/5) Installing libstdc++ (4.8.3-r0)
(4/5) Installing libuv (0.10.29-r0)
(5/5) Installing nodejs (0.10.33-r0)
Executing busybox-1.22.1-r14.trigger
OK: 21 MiB in 20 packages
```

This makes Alpine Linux a great image base for utilities and even production applications. [Read more about Alpine Linux here][alpine-about] and you can see how their mantra fits in right at home with Docker images.

## Usage

Stop doing this:

```
FROM ubuntu-debootstrap:14.04
RUN apt-get update -q \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy mysql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt
ENTRYPOINT ["mysql"]
```
This took 19 seconds to build and yields a 164 MB image. Eww. Start doing this:

```
FROM gliderlabs/alpine:3.1
RUN apk --update add mysql-client
ENTRYPOINT ["mysql"]
```

Only 3 seconds to build and results in a 16 MB image! Hooray!

## Documentation

This image is well documented. [Check out the documentation at Viewdocs][docs] and the `docs` directory in this repository.

## Support

We make reasonable efforts to support our work and are always happy to chat. Feel free to join us in [#gliderlabs on Freenode][irc] or [submit an issue][issues] to this GitHub repository.

## Inspiration

The motivation for this project and modifications to `mkimage.sh` are highly inspired by Eivind Uggedal (uggedal) and Luis Lavena (luislavena). They have made great strides in getting Alpine Linux running as a Docker container. Check out their [mini-container/base][mini-base] image as well.

## License

The code in this repository, unless otherwise noted, is BSD licensed. See the `LICENSE` file in this repository.

[mini-base]: https://github.com/mini-containers/base
[alpine-packages]: http://pkgs.alpinelinux.org/packages
[alpine-about]: https://www.alpinelinux.org/about/
[docs]: http://gliderlabs.viewdocs.io/docker-alpine
[irc]: https://kiwiirc.com/client/irc.freenode.net/#gliderlabs
[issues]: https://github.com/gliderlabs/docker-alpine/issues
[alpine]: http://alpinelinux.org/
