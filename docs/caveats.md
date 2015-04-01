# Caveats

The musl libc implementation may work a little different than you are used to. The [musl libc differences from glibc document](http://wiki.musl-libc.org/wiki/Functional_differences_from_glibc#Name_Resolver_.2F_DNS) does a really good job of outlining everything. Please take a glance at it. Here we'll talk about some of the more common things you might encounter.

## DNS

One common issue you may find is with DNS. musl libc does not use `domain` or `search` directives in the `/etc/resolv.conf` file. For example, if you started your Docker daemon with `--dns-search=service.consul`, and then tried to resolve `consul` from within an Alpine Linux container, it would fail as the name `consul.service.consul` would not be tried. You will need to work around this by using fully qualified names.

Another difference is parallel querying of name servers. This can be problematic if your first name server has a different DNS view (such as service discovery through DNS). For example, if you started your Docker daemon with `--dns=172.17.42.1 --dns=10.0.2.15` where `172.17.42.1` is a local DNS server to resolve name for service discovery and `10.0.2.15` is for external DNS resolving, you wouldn't be able to guarantee that `172.17.42.1` will always be queried first. There will be sporadic failures.

In both of these cases, it can help to run a local caching DNS server such as dnsmasq, that can be used for both caching and search path routing. Running dnsmasq with `--server /consul/10.0.0.1` would forward queries for the `.consul` to 10.0.0.1.

## Incompatible Binaries

While there are binaries that will run on musl libc without needing to be recompiled, you will likely encounter binaries and applications that rely on specific glibc functionality that will fail to start up. An example of this would be Oracle Java which relies on specific symbols only found in glibc. You can often use `ldd` to determine the exact symbol:

```console
# ldd bin/java
    /lib64/ld-linux-x86-64.so.2 (0x7f542ebb5000)
    libpthread.so.0 => /lib64/ld-linux-x86-64.so.2 (0x7f542ebb5000)
    libjli.so => bin/../lib/amd64/jli/libjli.so (0x7f542e9a0000)
    libdl.so.2 => /lib64/ld-linux-x86-64.so.2 (0x7f542ebb5000)
    libc.so.6 => /lib64/ld-linux-x86-64.so.2 (0x7f542ebb5000)
Error relocating bin/../lib/amd64/jli/libjli.so: __rawmemchr: symbol not found
```

In this case, the upstream would need to remove the support for this offending symbol or have the ability to compile the software natively on musl libc. Be sure to check the [Alpine Linux package index](http://pkgs.alpinelinux.org/packages) to see if a suitable replacement package already exists.
