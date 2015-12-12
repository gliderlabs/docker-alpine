# Alpine Linux Docker Image

[![CircleCI](https://img.shields.io/circleci/project/gliderlabs/docker-alpine/release.svg)](https://circleci.com/gh/gliderlabs/docker-alpine)
[![Docker Stars](https://img.shields.io/docker/stars/gliderlabs/alpine.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/gliderlabs/alpine.svg)][hub]
[![Slack](http://glider-slackin.herokuapp.com/badge.svg)][slack]
[![Image Size](https://img.shields.io/imagelayers/image-size/gliderlabs/alpine/latest.svg)](https://imagelayers.io/?images=gliderlabs/alpine:latest)
[![Image Layers](https://img.shields.io/imagelayers/layers/gliderlabs/alpine/latest.svg)](https://imagelayers.io/?images=gliderlabs/alpine:latest)


Welcome to the documentation for the Alpine Linux Docker Image. Here we explain a bit about the motivations behind this image, how you typically use it, the build process, and how to make great minimalist containers!

## About

The heart of this image is [Alpine Linux][alpine]. The image is only 5 MB and has access to a package repository that is much more complete than other minimal base images. Learn more [about this image][about], musl libc, BusyBox, and why the Docker Alpine Linux image makes a great base for your Docker projects.

## Official

This image serves as the source for the [official Alpine Linux image in the Docker Library][library]. The build process for both official `alpine` and `gliderlabs/alpine` are the same. However, different build options are used for the official library images. Check out [the build page][build] for more information on differences.

## Motivations

Docker images today are big. Usually much larger than they need to be. There are a lot of ways to make them smaller. But you need to start with a small base. There are great size savings to be had when compared to base images such as `ubuntu`, `centos`, and `debian`.

## Usage

You use the `apk` command to manage packages. We don't ship the image with a package index (since that can go stale fairly quickly), so you need to add the `--update` flag to `apk` when installing. An example installing the `nginx` package would be `apk add --update nginx`. Check out [the usage page][usage] for more advanced usage and `Dockerfile` examples.

## Caveats

The musl libc implementation may work a little different than you are used to. One example of this is with DNS. musl libc does not use `domain` or `search` in the `/etc/resolv.conf` file. It also queries name servers in parallel which can be problematic if your first name server has a different DNS view (such as service discovery through DNS). We have [a page dedicated to the caveats][caveats] you should be aware of.

## Build

This image is built and tested in a continuous integration environment using the `build` script. We then push the resulting images directly to Docker Hub. Check out [the page on building and testing][build] the images for more information.

## Contacts

We make reasonable efforts to support our work and are always happy to chat. Join us in [our Slack community][slack] or [submit a GitHub issue][issues] if you have a security or other general question about this Docker image. Please email [security](http://lists.alpinelinux.org/alpine-security/summary.html) or [user](http://lists.alpinelinux.org/alpine-user/summary.html) mailing lists if you have concerns specific to Alpine Linux.

## Contributing

We welcome contributions to the image build process, version bumps, and other optimizations. The image gets built and pushed from the `release` branch automatically. Once a pull request is merged, a build will be kicked off, and resulting image pushed to Docker Hub in a matter of minutes!

## Sponsors

[![Fastly](https://github.com/gliderlabs/docker-alpine/raw/master/logo_fastly.png)][fastly]

[Fastly][fastly] provides the CDN for our Alpine Linux package repository. This is allows super speedy package downloads from all over the globe! Check out

[about]: /docker-alpine/about
[usage]: /docker-alpine/usage
[build]: /docker-alpine/build
[caveats]: /docker-alpine/caveats
[slack]: http://glider-slackin.herokuapp.com/
[issues]: https://github.com/gliderlabs/docker-alpine/issues
[alpine]: http://alpinelinux.org/
[library]: https://github.com/docker-library/official-images/blob/master/library/alpine
[fastly]: https://www.fastly.com/
[hub]: https://hub.docker.com/r/gliderlabs/alpine/
