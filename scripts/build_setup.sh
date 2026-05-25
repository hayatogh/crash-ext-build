#!/bin/bash
. scripts/lib.sh

scripts=$(pwd)/scripts
src=$(pwd)/src
crashdir=$(basename $src/crash-*.tar.gz .tar.gz)
extdir=$crashdir/extensions

rm -rf build
mkdir -p build
cd build

tar -xf $src/crash-*.tar.gz
cp $src/gdb-*.tar.gz $crashdir
tar -xf $src/Python-*.tar.xz

git -C $src/pykdump archive --prefix=pykdump/ HEAD | tar -xf -
cp $src/crash-trace/trace.c $extdir
cp -r $src/crash-gcore/src/* $extdir
cp $src/crash-cacheutils/cacheutils.c $extdir
cp $src/crash-pageowner/page_owner.c $extdir
cp $src/crash-diskutils/scsi.{c,mk} $extdir
cp -n $src/crash-extensions/*.{c,mk} $extdir
tar -xf $src/crash-extensions/ptdump-1.0.7.tar.gz \
	--transform=s:ptdump-1.0.7:$extdir: --exclude=COPYING
eppic_branch=$(grep -Po '(?<=EPPIC_BRANCH=)v[0-9.]+' $extdir/eppic.mk)
git -C $src/eppic archive --prefix=eppic/ origin/$eppic_branch | tar -xf - -C $extdir
git -C $src/quic-crash-plugins archive --prefix=quic-crash-plugins/ HEAD | tar -xf -

cp $scripts/build.sh .

touch "$stampfile"
