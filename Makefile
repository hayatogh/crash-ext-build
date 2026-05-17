ifdef target
	targetopt := target=$(target)
endif


.PHONY: all
all: build

# Download each component into src
.update_crash:
	./scripts/update_crash.sh

.update_gdb: | .update_crash
	./scripts/update_gdb.sh

.update_python:
	./scripts/update_python.sh

.update_extensions:
	./scripts/update_extensions.sh

.update_all: .update_crash .update_gdb .update_python .update_extensions
	touch $@

# Check latest available versions, reusing downloaded files
.PHONY: update
update:
	rm -f .update_*
	$(MAKE) .update_all


# Arrange downloaded files into build
.build_setup: .update_all
	./scripts/build_setup.sh

# Stop after setting up build
.PHONY: build_setup
build_setup: .build_setup


# Build in build and collect artifacts in build/output
.PHONY: build
build: .build_setup
	./build/build.sh $(targetopt)


# Remove files except downloaded files
.PHONY: clean distclean
clean:
	rm -f .update_*
	rm -rf build .build_setup
	rm -f build.tar.gz output.tar.gz

# Remove all
distclean: clean
	rm -rf src


# Build on remote host
.PHONY: remotebuild
remotebuild: .build_setup
	tar -czf build.tar.gz build
	scp build.tar.gz $(VM):
	ssh $(VM) 'tar -xf build.tar.gz && ./build/build.sh $(targetopt) && tar -czf output.tar.gz -C build output'
	scp $(VM):output.tar.gz .
