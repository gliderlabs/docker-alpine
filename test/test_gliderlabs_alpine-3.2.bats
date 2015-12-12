setup() {
  docker history gliderlabs/alpine:3.2 >/dev/null 2>&1
}

@test "version is correct" {
  run docker run gliderlabs/alpine:3.2 cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.2.3" ]
}

@test "package installs cleanly" {
  run docker run gliderlabs/alpine:3.2 apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run gliderlabs/alpine:3.2 date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be available" {
  run docker run gliderlabs/alpine:3.2 which apk-install
  [ $status -eq 0 ]
}

@test "repository list is correct" {
  run docker run gliderlabs/alpine:3.2 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://alpine.gliderlabs.com/alpine/v3.2/main" ]
  [ "${lines[1]}" = "" ]
}

@test "cache is empty" {
  run docker run gliderlabs/alpine:3.2 sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "root password is disabled" {
  run docker run gliderlabs/alpine:3.2 sh -c "adduser -D -s /bin/ash test; su -c 'echo | su' - test"
  [ $status -eq 1 ]
  [ "${lines[1]}" = "su: incorrect password" ]
}
