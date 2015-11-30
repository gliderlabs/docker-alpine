# Usage

## Packages

Replacing your current base image with the Docker Alpine Linux image usually requires updating the package names to the corresponding ones in the [Alpine Linux package index][packageindex]. We use the `apk` command to manage packages. It works similar to `apt` or `yum`.

An example installing the `nginx` package would be `apk add --update nginx`. The `--update` flag fetches the current package index before adding the package. We don't ship the image with a package index (since that can go stale fairly quickly).

## Example

Here is a full example `Dockerfile` that installs the Python runtime and some build dependencies:

```
FROM gliderlabs/alpine:3.1

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
  && pip install virtualenv \
  && rm -rf /var/cache/apk/*

WORKDIR /app

ONBUILD COPY . /app
ONBUILD RUN virtualenv /env && /env/bin/pip install -r /app/requirements.txt

EXPOSE 8080
CMD ["/env/bin/python", "main.py"]
```

Notice `rm -rf /var/cache/apk/*` at the end of the `apk add` command. This is good practice to cleanup when you're done using `apk add` to use as little disk space as possible. After all, that's why you're using Alpine here, right?

## Virtual Packages

A great `apk add` feature for cleanup is the concept of virtual packages using the `--virtual` or `-t` switch. Packages added under this virtual name can then be removed as one group. An example use of this would be removing a group of build dependencies all at once:

```
FROM gliderlabs/alpine:3.1

WORKDIR /myapp
COPY . /myapp

RUN apk --update add python py-pip openssl ca-certificates
RUN apk --update add --virtual build-dependencies python-dev build-base wget \
  && pip install -r requirements.txt \
  && python setup.py install \
  && apk del build-dependencies

CMD ["myapp", "start"]
```

## Additional Information

Check out the [Alpine Linux package management documentation][apk] for more information and usage of `apk`.

[apk]: http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Update_the_Package_list
[packageindex]: http://pkgs.alpinelinux.org/packages
