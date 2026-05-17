# crash-ext-build

Build `crash` command and its extension modules in one go.

The crash-utility webpage maintains the list of its extension modules at
[crash-utility.github.io/extensions.html](https://crash-utility.github.io/extensions.html).
Thanks to extension developers, the extensions are so useful and straight-forward to compile,
but because there are so many, I'd like to share my build script.

This repository contains scripts to download and compile crash-utility `crash`
command and its extensions.


## Usage

```bash
make
```
This will do the following things:
1. (For the first time) Invoke `make update` explained below
1. Build in `build` directory
1. Store the binaries in `build/output` directory

```bash
make update
```
will do:
1. Check latest available versions
1. Download tar balls and clone repositories in `src` directory if necessary

```bash
make clean
```
- Delete `build` directory and hidden time stamp files but leave `src` directory,
  so that next `make` will check latest versions but not re-download them.

```bash
make distclean
```
- Delete all, going back to the just cloned state of this repository.


### More usages

Use `target` option to build `crash` for inspecting specific CPU arch dump files.
Currently only `target` variable is passed to `crash`.

`make clean` will be needed beforehand if you change `target` after some compilation.

E.g.
```bash
make clean
make target=ARM64
```

Build process can be done on remote host via ssh.
This will dangerously overwrite files in remote host.
Please first check Makefile rule `remotebuild` to understand what it does.

E.g.
```bash
make VM=mytesthost remotebuild
```

You can write your own wrapper script to apply patches.

E.g.
```bash
make build_setup
# Apply patches to `build` directory here
# Or even edit `build/build.sh` to modify build process, like excluding some extensions
make
```

## Build dependencies

Build dependencies depend on the version of `crash` and what extensions to build.
I haven't bisected all the extensions and I cannot provide the list of them.

I recommend doing `make` and installing missing dependencies on the fly.


## Links this repository pulls

Crash release:

- https://github.com/crash-utility/crash

All extensions listed in [crash-utility.github.io/extensions.html](https://crash-utility.github.io/extensions.html):

- https://git.code.sf.net/p/pykdump/code
- https://github.com/fujitsu/crash-trace
- https://github.com/fujitsu/crash-gcore
- https://github.com/k-hagio/crash-cacheutils
- https://github.com/k-hagio/crash-pageowner
- https://github.com/briston-dev/crash-diskutils
- https://github.com/crash-utility/crash-extensions
- https://github.com/lucchouina/eppic
- https://github.com/quic/crash-plugins

Dependencies:

- https://sourceware.org/pub/gdb/releases/
- https://www.python.org/ftp/python/ (for PyKdump)


## Acknowledgements

- I would like to express my gratitude to the creators of crash and its extension modules.
  Thank you for providing such an excellent tool to the community.
