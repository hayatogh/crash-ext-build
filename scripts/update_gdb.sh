#!/bin/bash
. scripts/lib.sh

crashver=$(ls src/crash-*.tar.gz | grep -Po '(?<=crash-)[0-9.]+(?=\.tar\.gz)')
ver=$(tar -xOf src/crash-$crashver.tar.gz crash-$crashver/configure.c \
	| grep -Po '(?<=GDB=gdb-)[0-9.]+' | tail -n1)
url=https://sourceware.org/pub/gdb/releases/gdb-$ver.tar.gz
remove_glob=gdb-*.tar.gz

curl_replace "$remove_glob" "$url"
