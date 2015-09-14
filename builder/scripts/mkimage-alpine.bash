#!/usr/bin/env bash

# This mkimage-alpine.sh is a modified version from
# https://github.com/docker/docker/blob/master/contrib/mkimage-alpine.sh.
# Changes were inspired by work done by Eivind Uggedal (uggedal) and
# Luis Lavena (luislavena).

declare REL="${REL:-edge}"
declare MIRROR="${MIRROR:-http://nl.alpinelinux.org/alpine}"
declare TIMEZONE="${TIMEZONE:-UTC}"

set -eo pipefail; [[ "$TRACE" ]] && set -x

[[ "$(id -u)" -eq 0 ]] || {
	printf >&2 '%s requires root\n' "$0" && exit 1
}

usage() {
	printf >&2 '%s: [-r release] [-m mirror] [-s] [-e] [-c] [-t]\n' "$0" && exit 1
}

output_redirect() {
	if [[ "$STDOUT" ]]; then
		cat - 1>&2
	else
		cat -
	fi
}

get-arch() {
	local hwname="$(uname -m)"
	echo "${hwname/#arm*/armhf}"
}

get-apk-version() {
	declare release="$1" mirror="${2:-$MIRROR}"
	local arch="$(get-arch)"
	curl -sSL "${mirror}/${release}/main/${arch}/APKINDEX.tar.gz" \
		| tar -Oxz \
		| grep '^P:apk-tools-static$' -a -A1 \
		| tail -n1 \
		| cut -d: -f2
}

build(){
	declare mirror="$1" rel="$2" timezone="${3:-UTC}"
	local repo="$mirror/$rel/main"
	local arch="$(get-arch)"

	# tmp
	local tmp="$(mktemp -d "${TMPDIR:-/var/tmp}/alpine-docker-XXXXXXXXXX")"
	local rootfs="$(mktemp -d "${TMPDIR:-/var/tmp}/alpine-docker-rootfs-XXXXXXXXXX")"
	# trap "rm -rf $tmp $rootfs" EXIT TERM INT

	# get apk
	curl -sSL "${repo}/${arch}/apk-tools-static-$(get-apk-version "$rel").apk" \
		| tar -xz -C "$tmp" sbin/apk.static \
		| output_redirect

	# mkbase
	"${tmp}/sbin/apk.static" \
		--repository "$repo" \
		--root "$rootfs" \
		--update-cache \
		--allow-untrusted \
		--initdb \
			add alpine-base tzdata | output_redirect
	cp -a "${rootfs}/usr/share/zoneinfo/${timezone}" "${rootfs}/etc/localtime"
	"${tmp}/sbin/apk.static" \
		--root "$rootfs" \
			del tzdata | output_redirect
	rm -f "${rootfs}"/var/cache/apk/* | output_redirect

	# conf
	printf '%s\n' "$repo" > "${rootfs}/etc/apk/repositories"
	[[ "$REPO_EXTRA" ]] && {
		[[ "$rel" == "edge" ]] || printf '%s\n' "@edge ${mirror}/edge/main" >> "${rootfs}/etc/apk/repositories"
		printf '%s\n' "@testing ${mirror}/edge/testing" >> "${rootfs}/etc/apk/repositories"
	}

	[[ "$ADD_APK_SCRIPT" ]] && cp /apk-install "${rootfs}/usr/sbin/apk-install"

	# save
	tar -z -f rootfs.tar.gz --numeric-owner -C "$rootfs" -c .
	if [[ "$STDOUT" ]]; then
		cat rootfs.tar.gz
	else
		return 0
	fi
}

main() {
	while getopts "hr:m:t:sec" opt; do
		case $opt in
			r) REL="$OPTARG";;
			m) MIRROR="$OPTARG";;
			s) STDOUT=1;;
			e) REPO_EXTRA=1;;
			t) TIMEZONE="$OPTARG";;
			c) ADD_APK_SCRIPT=1;;
			*) usage;;
		esac
	done

	build "$MIRROR" "$REL" "$TIMEZONE"
}

main "$@"
