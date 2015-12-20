# Build

[![CircleCI](https://img.shields.io/circleci/project/gliderlabs/docker-alpine/release.svg)](https://circleci.com/gh/gliderlabs/docker-alpine)

A convenience `build` script is included that builds the image and runs basic tests against the resulting image tags. The script is used in the continuous integration process (check out the CircleCI badge badge link above). But you can run this script locally to build your own images. Be sure to check out the environment variables that can be tweaked at the top of the `build` script file.

## Image

### Builder

The image is built using a builder Docker container based on the `debian` image. This builder image lives in the `builder` sub-directory of the project and uses a `mkimage-alpine.sh` script to generate a Alpine Linux `rootfs.tar.gz` file. This file then gets copied to the root of the project so we can build the main Alpine Linux image by just using the `ADD` command to automatically untar the components to the resulting image.

### Options

The build script takes a glob of `options` files as an argument. Each of these files lives in a folder that describes the version of Alpine Linux to build. Each line of the `options` file are the options that will be applied to the resulting image. By default, we use the included glob of `versions/**/options`.

### Example

To build all the images simply run:

```console
$ ./build
```

Pass version files to the `build` script to build specific versions:

```console
$ ./build version/library-3.2/options versions/gliderlabs-3.2/options
```

With `parallel` available you can speed up building a bit:

```console
$ parallel -m ./build ::: versions/**/options
```

## Differences

As we maintain the [official Alpine Linux image in the Docker Library][library], we have specific `options` files for library versions. These contain options that may differ slightly from the `gliderlabs/alpine` image. Compare the `BUILD_OPTIONS` variable to see differences between versions.

The `gliderlabs/alpine` has these additional features:

* Alpine package mirror CDN sponsored by [Fastly][fastly] for speedy package installation all over the globe.
* An `apk-install` convenience script to update the index, add packages, and then remove the cache.

This should help with your image decision. If features of the `gliderlabs/alpine` image are not of importance to you and you value closest to upstream, then stick with `alpine`. If you want to use additional features we add to the image, then you would use `gliderlabs/alpine`.

## Test

The test for images is very simple at the moment. It just attempts to install the `openssl` package and verify we exit cleanly.

Use the `test` sub-command of the `build` utility to run tests on currently build images (`build test`).

[library]: https://github.com/docker-library/official-images/blob/master/library/alpine
[fastly]: https://www.fastly.com/
