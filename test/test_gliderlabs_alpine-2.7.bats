setup() {
  docker history gliderlabs/alpine:2.7 >/dev/null 2>&1
}

@test "version is correct" {
  run docker run gliderlabs/alpine:2.7 cat /etc/alpine-release
  [ $status -eq 0 ]
  [ "${lines[0]}" = "2.7.9" ]
}

@test "package installs cleanly" {
  run docker run gliderlabs/alpine:2.7 apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run gliderlabs/alpine:2.7 date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be available" {
  run docker run gliderlabs/alpine:2.7 which apk-install
  [ $status -eq 0 ]
}

@test "repository list is correct" {
  run docker run gliderlabs/alpine:2.7 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://alpine.gliderlabs.com/alpine/v2.7/main" ]
  [ "${lines[1]}" = "" ]
}

@test "cache is empty" {
  run docker run gliderlabs/alpine:2.7 sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "root password is disabled" {
  run docker run --user nobody gliderlabs/alpine:2.7 su
  [ $status -eq 1 ]
}
