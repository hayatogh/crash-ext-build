#!/bin/bash
. scripts/lib.sh

git_clone 'https://git.code.sf.net/p/pykdump/code' pykdump
git_clone 'https://github.com/fujitsu/crash-trace'
git_clone 'https://github.com/fujitsu/crash-gcore'
git_clone 'https://github.com/k-hagio/crash-cacheutils'
git_clone 'https://github.com/k-hagio/crash-pageowner'
git_clone 'https://github.com/briston-dev/crash-diskutils'
git_clone 'https://github.com/crash-utility/crash-extensions'
git_clone 'https://github.com/lucchouina/eppic' eppic --no-single-branch
git_clone 'https://github.com/quic/crash-plugins' quic-crash-plugins
