#!/bin/bash
set -euEo pipefail
shopt -s inherit_errexit failglob

cd $(dirname $0)

target=${1:-}

pushd Python-*/
./configure CFLAGS=-fPIC --disable-shared
cp ../pykdump/Extension/Setup.local-$(pwd | grep -Po '(?<=Python-)[0-9]+\.[0-9]+') Modules/Setup.local
sed -i 's/^#readline/readline/' Modules/Setup.local
if ! (echo 'int main(void) { return 0; }' | cc -x c - -l:libreadline.a -o /dev/null 2>/dev/null); then
	sed -i 's/ -l:libreadline\.a / -lreadline /' Modules/Setup.local
fi
make -j$(nproc)
strip --strip-debug libpython*.a
popd

pushd crash-*/
make -j$(nproc) $target
make lzo
make snappy
make zstd
make extensions
popd

pushd pykdump/Extension
./configure -p ../../Python-*/ -c ../../crash-*/
# Use single job because PyKdump doesn't compile with -j >=2.
make
popd

pushd quic-crash-plugins
./build.sh
popd

rm -rf output
mkdir -p output
cp crash-*/crash output
cp crash-*/extensions/*.so output
cp quic-crash-plugins/output/arm64/plugins.so output/arm64_plugins.so
if [[ -e quic-crash-plugins/output/arm/plugins.so ]]; then
	cp quic-crash-plugins/output/arm/plugins.so output/arm_plugins.so
fi
strip --strip-debug output/*
# Don't strip mpykdump.so or it would delete necessary sections.
cp pykdump/Extension/mpykdump.so output
chmod a-x output/*.so
