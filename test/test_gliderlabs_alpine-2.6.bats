setup() {
  docker history gliderlabs/alpine:2.6 >/dev/null 2>&1
}

@test "version is correct" {
  run docker run gliderlabs/alpine:2.6 cat /etc/alpine-release
  [ $status -eq 0 ]
  [ "${lines[0]}" = "2.6.6" ]
}

@test "package installs cleanly" {
  run docker run gliderlabs/alpine:2.6 apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run gliderlabs/alpine:2.6 date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be available" {
  run docker run gliderlabs/alpine:2.6 which apk-install
  [ $status -eq 0 ]
}

@test "repository list is correct" {
  run docker run gliderlabs/alpine:2.6 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-4.alpinelinux.org/alpine/v2.6/main" ]
}

@test "cache is empty" {
  run docker run gliderlabs/alpine:2.6 sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}
