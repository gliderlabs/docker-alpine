#!/bin/sh

# This mkimage-alpine.sh is a modified version from
# https://github.com/docker/docker/blob/master/contrib/mkimage-alpine.sh.
# Changes were inspired by work done by Eivind Uggedal (uggedal) and
# Luis Lavena (luislavena).

set -e
[ $TRACE ] && set -x

[ $(id -u) -eq 0 ] || {
	printf >&2 '%s requires root\n' "$0"
	exit 1
}

usage() {
	printf >&2 '%s: [-r release] [-m mirror] [-s] [-e]\n' "$0"
	exit 1
}

tmp() {
	TMP=$(mktemp -d ${TMPDIR:-/var/tmp}/alpine-docker-XXXXXXXXXX)
	ROOTFS=$(mktemp -d ${TMPDIR:-/var/tmp}/alpine-docker-rootfs-XXXXXXXXXX)
	trap "rm -rf $TMP $ROOTFS" EXIT TERM INT
}

apkv() {
	curl -sSL $REPO/$ARCH/APKINDEX.tar.gz | tar -Oxz |
		grep '^P:apk-tools-static$' -a -A1 | tail -n1 | cut -d: -f2
}

getapk() {
	curl -sSL $REPO/$ARCH/apk-tools-static-$(apkv).apk |
		tar -xz -C $TMP sbin/apk.static
}

mkbase() {
	$TMP/sbin/apk.static --repository $REPO --update-cache --allow-untrusted \
		--root $ROOTFS --initdb add alpine-base
}

conf() {
	printf '%s\n' $REPO > $ROOTFS/etc/apk/repositories
	[ $REPO_EXTRA -eq 1 ] && {
		[ $REL = "edge" ] || printf '%s\n' "@edge $MIRROR/edge/main" >> $ROOTFS/etc/apk/repositories
		printf '%s\n' "@testing $MIRROR/edge/testing" >> $ROOTFS/etc/apk/repositories
	}
	rm -f $ROOTFS/var/cache/apk/*
}

save() {
	[ $SAVE -eq 1 ] || return

	tar --numeric-owner -C $ROOTFS -c . | xz > rootfs.tar.xz
}

while getopts "hr:m:se" opt; do
	case $opt in
		r)
			REL=$OPTARG
			;;
		m)
			MIRROR=$OPTARG
			;;
		s)
			SAVE=1
			;;
		e)
			REPO_EXTRA=1
			;;
		*)
			usage
			;;
	esac
done

REL=${REL:-edge}
MIRROR=${MIRROR:-http://nl.alpinelinux.org/alpine}
SAVE=${SAVE:-0}
REPO=$MIRROR/$REL/main
REPO_EXTRA=${REPO_EXTRA:-0}
ARCH=$(uname -m)

tmp && getapk && mkbase && conf && save
