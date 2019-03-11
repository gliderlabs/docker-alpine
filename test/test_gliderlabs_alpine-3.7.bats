setup() {
  docker history gliderlabs/alpine:3.7 >/dev/null 2>&1
}

@test "version is correct" {
  run docker run gliderlabs/alpine:3.7 cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.7.1" ]
}

@test "package installs cleanly" {
  run docker run gliderlabs/alpine:3.7 apk add --update-cache openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run gliderlabs/alpine:3.7 date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be available" {
  run docker run gliderlabs/alpine:3.7 which apk-install
  [ $status -eq 0 ]
}

@test "repository list is correct" {
  run docker run gliderlabs/alpine:3.7 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://alpine.gliderlabs.com/alpine/v3.7/main" ]
  [ "${lines[1]}" = "http://alpine.gliderlabs.com/alpine/v3.7/community" ]
}

@test "cache is empty" {
  run docker run gliderlabs/alpine:3.7 sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "root password is disabled" {
  run docker run --user nobody gliderlabs/alpine:3.7 su
  [ $status -eq 1 ]
}
