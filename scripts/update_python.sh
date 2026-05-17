#!/bin/bash
. scripts/lib.sh

tmp=$(curl -fsSL 'https://www.python.org/ftp/python/')
pyverfull=$(grep -Po '(?<=href=")'"${pyver/./\\.}"'\.[0-9]+' <<<$tmp | sort -V | tail -n1)
url=https://www.python.org/ftp/python/$pyverfull/Python-$pyverfull.tar.xz
remove_glob=Python-*.tar.xz

curl_replace "$remove_glob" "$url"
