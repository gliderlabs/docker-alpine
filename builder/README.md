# Alpine Linux rootfs Builder

This builder image constructs a Alpine Linux `rootfs.tar.xz` for us to use when building the base Alpine Linux image. The `mkimage-alpine.sh` script does all the heavy lifting. During the configuration of the image we add our `apk-install` convenience script.

## Options

The builder takes several options:

* `-r <release>`: The release tag to use (such as `edge` or `v3.1`).
* `-m <mirror>`: The mirror URL base. Defaults to `http://nl.alpinelinux.org/alpine`.
* `-s`: Saves the rootfs to `/rootfs.tar.xz` so it can be later copied.
* `-c`: Adds the `apk-install` script to the resulting rootfs.
* `-e`: Adds extra `edge/main` and `edge/testing` pins to the repositories file.
