# Build

[![CircleCI](https://img.shields.io/circleci/project/gliderlabs/docker-alpine/release.svg)](https://circleci.com/gh/gliderlabs/docker-alpine)

A convenience `build` script is included that builds the image and runs basic tests against the resulting image tags. The script is used in the continuous integration process (check out the CircleCI badge badge link above). But you can run this script locally to build your own images. Be sure to check out the environment variables that can be tweaked at the top of the `build` script file.

## Image

The image is built using a builder Docker container based on the `debian` image. This builder image lives in the `builder` sub-directory of the project and uses a `mkimage-alpine.sh` script to generate a Alpine Linux `rootfs.tar.gz` file. This file then gets copied to the root of the project so we can build the main Alpine Linux image by just using the `ADD` command to automatically untar the components to the resulting image.

The build script takes a glob of `tags` files as an argument. Each of these files lives in a folder that describes the version of Alpine Linux to build in the parent directory name and each line of the file are the tags that will be applied to the resulting image. By default, we use the included glob of `versions/**/tags`.

## Test

The test for images is very simple at the moment. It just attempts to install the `openssl` package and verify we exit cleanly.

Use the `test` sub-command of the `build` utility to run tests on currently build images (`build test`).
