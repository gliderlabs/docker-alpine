# Alpine Linux Docker Image

[![CircleCI](https://img.shields.io/circleci/project/gliderlabs/docker-alpine/release.svg)](https://circleci.com/gh/gliderlabs/docker-alpine) [![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://registry.hub.docker.com/u/gliderlabs/alpine/) [![IRC Channel](https://img.shields.io/badge/irc-%23gliderlabs-blue.svg)](irc)

Welcome to the documentation for the Alpine Linux Docker Image. Here we explain a bit about the motivations behind this image, how you typically use it, the build process, and how to make great minimalist containers!

## About

The heart of this image is [Alpine Linux][alpine]. The image is only 5 MB and has access to a package repository that is much more complete than other minimal base images. Learn more [about this image][about], musl libc, BusyBox, and why the Docker Alpine Linux image makes a great base for your Docker projects.

## Motivations

Docker images today are big. Usually much larger than they need to be. There are a lot of ways to make them smaller. But you need to start with a small base. There are great size savings to be had when compared to base images such as `ubuntu`, `centos`, and `debian`.

## Usage

You use the `apk` command to manage packages. We don't ship the image with a package index (since that can go stale fairly quickly), so you need to add the `--update` flag to `apk` when installing. An example installing the `nginx` package would be `apk add --update nginx`. Check out [the usage page][usage] for more advanced usage and `Dockerfile` examples.

## Build

This image is built and tested in a continuous integration environment using the `build` script. We then push the resulting images directly to Docker Hub. Check out [the page on building and testing][build] the images for more information.

## Support

We make reasonable efforts to support our work and are always happy to chat. Feel free to join us in [#gliderlabs on Freenode][irc] or [submit an issue][issues] to the GitHub repository.

## Contributing

We welcome contributions to the image build process, version bumps, and other optimizations. The image gets built and pushed from the `release` branch automatically. Once a pull request is merged, a build will be kicked off, and resulting image pushed to Docker Hub in a matter of minutes!

[about]: /docker-alpine/about
[usage]: /docker-alpine/usage
[build]: /docker-alpine/build
[irc]: irc://irc.freenode.net/#gliderlabs
[issues]: https://github.com/gliderlabs/docker-alpine/issues
[alpine]: http://alpinelinux.org/
