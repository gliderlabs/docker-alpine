# Build

[![CircleCI](https://img.shields.io/circleci/project/gliderlabs/docker-alpine/release.svg)](https://circleci.com/gh/gliderlabs/docker-alpine)

A convenience `build` script is included that builds the image and runs basic tests against the resulting image tags. The script is used in the continuous integration process (check out the CircleCI badge badge link above). But you can run this script locally to build your own images. Be sure to check out the environment variables that can be tweaked at the top of the `build` script file.

## Image

### Builder

The image is built using a builder Docker container based on the `debian` image. This builder image lives in the `builder` sub-directory of the project and uses a `mkimage-alpine.sh` script to generate a Alpine Linux `rootfs.tar.gz` file. This file then gets copied to the root of the project so we can build the main Alpine Linux image by just using the `ADD` command to automatically untar the components to the resulting image.

### Options

The build script takes a glob of `options` files as an argument. Each of these files lives in a folder that describes the version of Alpine Linux to build. Each line of the `options` file are the options that will be applied to the resulting image. By default, we use the included glob of `versions/**/options`.

### Official

As we maintain the [official Alpine Linux image in the Docker Library][library], we have specific `options` files for library versions. These contain options that may differ slightly from the `gliderlabs/alpine` image. Compare the `BUILD_OPTIONS` variable to see differences between versions.

In the future, Glider Labs may add features that are not available in upstream Alpine Linux (such as a package repository or scripts to install packages from GitHub). These options would not make it to the official Docker library since they are not available upstream.

This should help with your image decision. If features of the `gliderlabs/alpine` image are not of importance to you and you value closest to upstream, then stick with `alpine`. If you want to use additional features we add to the image, then you would use `gliderlabs/alpine`.

## Test

The test for images is very simple at the moment. It just attempts to install the `openssl` package and verify we exit cleanly.

Use the `test` sub-command of the `build` utility to run tests on currently build images (`build test`).

[library]: https://github.com/docker-library/official-images/blob/master/library/alpine
