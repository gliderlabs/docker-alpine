setup() {
  docker history alpine:2.7 >/dev/null 2>&1
}

@test "version is correct" {
  run docker run alpine:2.7 cat /etc/alpine-release
  [ $status -eq 0 ]
  [ "${lines[0]}" = "2.7.9" ]
}

@test "package installs cleanly" {
  run docker run alpine:2.7 apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run alpine:2.7 date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be missing" {
  run docker run alpine:2.7 which apk-install
  [ $status -eq 1 ]
}

@test "repository list is correct" {
  run docker run alpine:2.7 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-4.alpinelinux.org/alpine/v2.7/main" ]
  [ "${lines[1]}" = "" ]
}

@test "cache is empty" {
  run docker run alpine:2.7 sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "root password is disabled" {
  run docker run "alpine:2.7" sh -c "adduser -D -s /bin/ash test; su -c 'echo | su' - test"
  [ $status -eq 1 ]
  [ "${lines[1]}" = "su: incorrect password" ]
}
