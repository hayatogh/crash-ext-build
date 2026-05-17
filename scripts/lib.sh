#!/bin/bash
set -euEo pipefail
shopt -s inherit_errexit failglob

# Update Python version to the latest verified one at https://pykdump.readthedocs.io/en/latest/install/build-steps.html
pyver=3.10
stampfile=$(pwd)/.$(basename $0 .sh)

curl_replace()
(
	local remove_glob=$1 url=$2
	local out=${3:-$(basename "$url")}

	mkdir -p src
	cd src

	if [[ ! -f $out ]]; then
		shopt -u failglob
		eval rm -f "$remove_glob"
		shopt -s failglob

		curl -fsSLo "$out" "$url"
		touch "$stampfile"
	elif [[ ! -f $stampfile ]]; then
		touch "$stampfile"
	fi
)

git_clone()
(
	local url=$1
	local dir=${2:-$(basename $1)}
	local opt=${3:-}

	mkdir -p src
	cd src

	if [[ ! -e $dir ]]; then
		git clone -q --depth 1 $opt "$url" "$dir"
		touch "$stampfile"
	elif [[ $(git -C "$dir" pull) != 'Already up to date.' || ! -f $stampfile ]]; then
		touch "$stampfile"
	fi
)
