#!/bin/bash
. scripts/lib.sh

tmp=$(curl -fsSL 'https://api.github.com/repos/crash-utility/crash/releases/latest')
ver=$(grep -Pom1 '(?<=https://api.github.com/repos/crash-utility/crash/tarball/)[0-9.]+' <<<$tmp)
fname=crash-$ver.tar.gz
url=https://github.com/crash-utility/crash/archive/refs/tags/$ver.tar.gz
remove_glob=crash-*.tar.gz

curl_replace "$remove_glob" "$url" "$fname"
