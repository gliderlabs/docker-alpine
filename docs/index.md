# Alpine Linux Docker Image

[![CircleCI](https://img.shields.io/circleci/project/gliderlabs/docker-alpine/master.svg)](https://circleci.com/gh/gliderlabs/docker-alpine)

Welcome to the documentation for the Alpine Linux Docker Image. Here we explain a bit about the motivations behind this image, how you typically use it, the build process, and how to make great minimalist containers!

## About

The heart of this image is Alpine Linux. The image is only 5 MB and has access to a package repository that is much more complete than other minimal base images. Learn more [about this image][about], musl libc, BusyBox, and why the Docker Alpine Linux image makes a great base for your Docker projects.

## Motivations

Docker images today are big. Usually much larger than they need to be. There are a lot of ways to make them smaller. But you need to start with a small base. There are great size savings to be had when compared to base images such as `ubuntu`, `centos`, and `debian`.

## Usage

You use the `apk` command to manage packages. We don't ship the image with a package index (since that can go stale fairly quickly), so you need to add the `--update` flag to `apk` when installing. An example installing the `nginx` package would be `apk add --update nginx`. Check out [the usage page][usage] for more advanced usage and `Dockerfile` examples.

## Build

The image is built using a builder Docker container based on the `debian` image. This builder image lives in the `builder` sub-directory of the project and uses a `mkimage-alpine.sh` script to generate a Alpine Linux `rootfs.tar.gz` file. This file then gets copied to the root of the project so we can build the main Alpine Linux image by just using the `ADD` command to automatically untar the components to the resulting image.

A convenience `build` script is included that builds the image and runs basic tests against the resulting image tags. This script is used in the continuous integration process (click the CircleCI link badge above). But you can run this script locally to build your own images.

The build script takes a glob of files as an argument. Each of these files describes the version of Alpine Linux to build in the file name and each line of the file are the tags that will be applied to the resulting image. By default, we use the included files in the `versions` directory.

Be sure to check out the environment variables that can be tweaked at the top of the `build` script file.

## Test

The test for images is very simple at the moment. It just attempts to install the `openssl` package and verify we exit cleanly.

Use the `test` sub-command of the `build` utility to run tests on currently build images (`build test`).

## Contributing

We welcome contributions to the image build process, version bumps, and other optimizations. The image gets built and pushed from master automatically. Once a pull request is merged, a build will be kicked off, and resulting image pushed to Docker Hub in a matter of minutes!

[about]: /docker-alpine/about
[usage]: /docker-alpine/usage
