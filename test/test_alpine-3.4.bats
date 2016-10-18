setup() {
  docker history alpine:3.4 >/dev/null 2>&1
}

@test "version is correct" {
  run docker run alpine:3.4 cat /etc/os-release
  [ $status -eq 0 ]
  [ "${lines[2]}" = "VERSION_ID=3.4.4" ]
}

@test "package installs cleanly" {
  run docker run alpine:3.4 apk add --update openssl
  [ $status -eq 0 ]
}

@test "timezone" {
  run docker run alpine:3.4 date +%Z
  [ $status -eq 0 ]
  [ "$output" = "UTC" ]
}

@test "apk-install script should be missing" {
  run docker run alpine:3.4 which apk-install
  [ $status -eq 1 ]
}

@test "repository list is correct" {
  run docker run alpine:3.4 cat /etc/apk/repositories
  [ $status -eq 0 ]
  [ "${lines[0]}" = "http://dl-cdn.alpinelinux.org/alpine/v3.4/main" ]
  [ "${lines[1]}" = "http://dl-cdn.alpinelinux.org/alpine/v3.4/community" ]
  [ "${lines[2]}" = "" ]
}

@test "cache is empty" {
  run docker run alpine:3.4 sh -c "ls -1 /var/cache/apk | wc -l"
  [ $status -eq 0 ]
  [ "$output" = "0" ]
}

@test "root password is disabled" {
  run docker run --user nobody alpine:3.4 su
  [ $status -eq 1 ]
}

@test "CVE-2016-2183, CVE-2016-6304, CVE-2016-6306" {
  run docker run alpine:3.4 sh -c 'apk version -t $(apk info -v | grep ^libssl | cut -d- -f2-) 1.0.2i-r0 | grep -q "[=>]"'
  [ $status -eq 0 ]
}

@test "CVE-2016-7052" {
  run docker run alpine:3.4 sh -c 'apk version -t $(apk info -v | grep ^libssl | cut -d- -f2-) 1.0.2j-r0 | grep -q "[=>]"'
  [ $status -eq 0 ]
}

