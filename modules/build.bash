
BUILD_IMAGE="${BUILD_IMAGE:-alpine-builder}"
BUILD_PREFIX="${BUILD_PREFIX:-alpine-build-}"
PREFIXES="${PREFIXES:-alpine}"
MIRROR="${MIRROR:-http://dl-4.alpinelinux.org/alpine}"
VERSIONS="${VERSIONS:-versions/*}"

check-docker() {
  if [[ -z $(which docker) ]]; then
    echo "Missing docker client which is required for building"
    exit 2
  fi
}

build() {
  declare desc="Build Alpine Linux Docker images"
  declare version_files="${@:-$VERSIONS}"
  : ${version_files:?}

  status-header "Building Alpine Linux Docker images"
  check-docker

  status-start "Building image for the rootfs mkimage script"
  docker build -t "$BUILD_IMAGE" builder >/dev/null 2>&1
  status-finish "done"

  for file in $version_files; do
    local tags="$(cat $file)"
    local release="$(basename $file)"
    local build="${BUILD_PREFIX}${release}"
    local master="$(echo $PREFIXES | cut -d' ' -f1)"

    : ${build:?} ${tags:?} ${release:?}

    docker rm "$build" >/dev/null 2>&1 || true

    status-start "Building release $release"
    docker run --name "$build" "$BUILD_IMAGE" \
    -s \
    -r "$release" \
    -m "$MIRROR" >/dev/null 2>&1
    docker cp "$build":/rootfs.tar.xz . >/dev/null 2>&1
    docker build -t "$master" . >/dev/null 2>&1
    status-finish "done"

    for tag in $tags; do
      for prefix in $PREFIXES; do
        status "Tagging release $release as $prefix:$tag"
        docker tag -f "$master" "$prefix":"$tag" >/dev/null 2>&1
      done
    done

    docker rm "$build" >/dev/null 2>&1 || true
    rm -f rootfs.tar.xz

    info-header "Finished building release $release"
  done
}

test() {
  declare desc="Run tests against images"
  declare version_files="${@:-$VERSIONS}"
  local master="$(echo $PREFIXES | cut -d' ' -f1)"
  status-header "Testing images"
  for file in $version_files; do
    local tag="$(head -1 $file)"
    if $(docker inspect "$master":"$tag" >/dev/null 2>&1); then
      status-start "Testing image $master:$tag"
      if $(docker run "$master":"$tag" apk add --update openssl >/dev/null); then
        status-finish "passed"
      else
        status-finish "failed"
        exit 1
      fi
    fi
  done
}

cmd-export test
cmd-export build
