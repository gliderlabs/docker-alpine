# About

[Alpine Linux](http://alpinelinux.org/) is a lightweight Linux distribution based on [musl libc][musl] and [BusyBox][busybox]. The base is extremely small, builds as a Docker image in a matter of minutes, and has a full-featured package index.

## musl libc

musl provides consistent quality and implementation behavior from tiny embedded systems to full-fledged servers. Minimal machine-specific code means less chance of breakage on minority architectures and better success with “write once run everywhere” C development. Designed from the ground up for static linking, musl carefully avoids pulling in large amounts of code or data that the applications will not use.

Using musl maximizes application deployability. Binaries statically linked with musl have no external dependencies, even for features like DNS lookups or character set conversions that are implemented with dynamic loading on glibc. An application can really be deployed as a single binary file and run on any machine with the appropriate instruction set architecture and Linux kernel or Linux syscall ABI emulation layer.

## BusyBox

BusyBox combines tiny versions of many common UNIX utilities into a single small executable. It provides replacements for most of the utilities you usually find in GNU fileutils, shellutils, etc. The utilities in BusyBox generally have fewer options than their full-featured GNU cousins; however, the options that are included provide the expected functionality and behave very much like their GNU counterparts. BusyBox provides a fairly complete environment for any small or embedded system.

BusyBox has been written with size-optimization and limited resources in mind. It is also extremely modular so you can easily include or exclude commands (or features) at compile time. This makes it easy to customize your embedded systems. To create a working system, just add some device nodes in `/dev`, a few configuration files in `/etc`, and a Linux kernel.

## Match made in heaven

Pairing musl libc with BusyBox to combine common UNIX utilities into a single small executable, it makes for an excellent Docker image base. We get extremely small builds (the base image is only 5 MB) that end up cutting time during push and pull.

[musl]: http://www.musl-libc.org/
[busybox]: http://www.busybox.net/
