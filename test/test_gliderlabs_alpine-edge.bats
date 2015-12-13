setup() {
  docker history gliderlabs/alpine:edge >/dev/null 2>&1
}

@test "version is correct" {
  run docker run gliderlabs/alpine:edge cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.3.0_rc2" ]
}

@test "package installs cleanly" {
  run docker run gliderlabs/alpine:edge apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run gliderlabs/alpine:edge date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be available" {
  run docker run gliderlabs/alpine:edge which apk-install
  [ $status -eq 0 ]
}

@test "repository list is correct" {
  run docker run gliderlabs/alpine:edge cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://alpine.gliderlabs.com/alpine/edge/main" ]
  [ "${lines[1]}" = "http://alpine.gliderlabs.com/alpine/edge/community" ]
  [ "${lines[2]}" = "" ]
}

@test "cache is empty" {
  run docker run gliderlabs/alpine:edge sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "root password is disabled" {
  run docker run --user nobody gliderlabs/alpine:edge su
  [ $status -eq 1 ]
}
