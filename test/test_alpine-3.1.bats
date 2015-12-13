setup() {
  docker history "alpine:3.1" >/dev/null 2>&1
}

@test "version is correct" {
  run docker run "alpine:3.1" cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.1.4" ]
}

@test "package installs cleanly" {
  run docker run "alpine:3.1" apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run "alpine:3.1" date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be missing" {
  run docker run "alpine:3.1" which apk-install
  [ $status -eq 1 ]
}

@test "repository list is correct" {
  run docker run "alpine:3.1" cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-4.alpinelinux.org/alpine/v3.1/main" ]
  [ "${lines[1]}" = "" ]
}

@test "cache is empty" {
  run docker run "alpine:3.1" sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "root password is disabled" {
  run docker run --user nobody "alpine:3.1" su
  [ $status -eq 1 ]
}
