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
	printf >&2 '%s: [-r release] [-m mirror] [-s] [-e] [-c] [-t timezone] [-p packages] [-b]\n' "$0" && exit 1
}

output_redirect() {
	if [[ "$STDOUT" ]]; then
		cat - 1>&2
	else
		cat -
	fi
}

build() {
	declare mirror="$1" rel="$2" timezone="${3:-UTC}" packages="${4:-alpine-base}"
	local repo="$mirror/$rel/main"
	local arch="$(uname -m)"

	# tmp
	local tmp="$(mktemp -d "${TMPDIR:-/var/tmp}/alpine-docker-XXXXXXXXXX")"
	local rootfs="$(mktemp -d "${TMPDIR:-/var/tmp}/alpine-docker-rootfs-XXXXXXXXXX")"
	# trap "rm -rf $tmp $rootfs" EXIT TERM INT

	# mkbase
	{
		apk --repository "$repo" --update-cache \
			fetch --recursive --output "$tmp" \
			tzdata ${packages//,/ }
		[[ "$ADD_BASELAYOUT" ]] && \
			apk --repository "$repo" fetch --stdout alpine-base \
				| tar -xvz -C "$rootfs" etc
		apk --root "$rootfs" --allow-untrusted add --initdb "$tmp"/*.apk
		cp -a "$rootfs/usr/share/zoneinfo/$timezone" "$rootfs/etc/localtime"
		apk --root "$rootfs" del tzdata
	} | output_redirect

	# conf
	printf '%s\n' "$repo" > "$rootfs/etc/apk/repositories"
	[[ "$REPO_EXTRA" ]] && {
		[[ "$rel" == "edge" ]] || printf '%s\n' "@edge $mirror/edge/main" >> "$rootfs/etc/apk/repositories"
		printf '%s\n' "@testing $mirror/edge/testing" >> "$rootfs/etc/apk/repositories"
	}

	[[ "$ADD_APK_SCRIPT" ]] && cp /apk-install "$rootfs/usr/sbin/apk-install"

	# save
	tar -z -f rootfs.tar.gz --numeric-owner -C "$rootfs" -c .
	[[ "$STDOUT" ]] && cat rootfs.tar.gz

	return 0
}

main() {
	while getopts "hr:m:t:secp:b" opt; do
		case $opt in
			r) REL="$OPTARG";;
			m) MIRROR="$OPTARG";;
			s) STDOUT=1;;
			e) REPO_EXTRA=1;;
			t) TIMEZONE="$OPTARG";;
			c) ADD_APK_SCRIPT=1;;
			p) PACKAGES="$OPTARG";;
			b) ADD_BASELAYOUT=1;;
			*) usage;;
		esac
	done

	build "$MIRROR" "$REL" "$TIMEZONE" "$PACKAGES"
}

main "$@"
