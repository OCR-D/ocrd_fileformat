DOCKER_BASE_IMAGE ?= docker.io/ocrd/core:latest
DOCKER_TAG ?= ocrd/fileformat
DOCKER ?= docker

PYTHON ?= python3
PIP ?= pip3
PYTEST_ARGS ?= -vv

# BEGIN-EVAL makefile-parser --make-help Makefile

help:
	@echo ""
	@echo "  Targets"
	@echo ""
	@echo "    deps-ubuntu        Install system dependencies"
	@echo "    deps               Install Python dependency"
	@echo "    install            Install Python package and scripts"
	@echo "    uninstall          Uninstall Python package and scripts"
	@echo "    build              Build Python package source and binary distribution"
	@echo "    docker             Build Docker image"
	@echo "    tests/assets       Setup test assets"
	@echo "    assets-clean       Remove tests/assets"
	@echo "    deps-test          Install dev dependencies with pip"
	@echo "    test               Run tests with pytest"


deps-ubuntu:
	apt-get update && apt-get install -y openjdk-11-jdk-headless wget git gcc unzip

deps:
	$(PIP) install -r requirements.txt

install-fileformat:
	make -C repo/ocr-fileformat PREFIX=$(VIRTUAL_ENV) vendor install

install: install-fileformat
	$(PIP) install .

# Uninstall scripts and $(SHAREDIR)
uninstall:
	-$(PIP) uninstall ocrd_fileformat
	-$(MAKE) -C repo/ocr-fileformat PREFIX=$(PREFIX) uninstall

build:
	$(PIP) install build
	$(PYTHON) -m build .

# Build Docker image
docker:
	$(DOCKER) build \
	--build-arg DOCKER_BASE_IMAGE=$(DOCKER_BASE_IMAGE) \
	--build-arg VCS_REF=$$(git rev-parse --short HEAD) \
	--build-arg BUILD_DATE=$$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
	-t $(DOCKER_TAG) .

#
# Assets
#

.PHONY: always-update
repo/assets repo/ocr-fileformat: always-update
	git submodule sync --recursive $@
	if git submodule status --recursive $@ | grep -qv '^ '; then \
		git submodule update --init --recursive $@ && \
		touch -c $@; \
	fi

.PHONY: assets assets-clean
assets: tests/assets

# Setup test assets
tests/assets: repo/assets
	mkdir -p tests/assets
	cp -r repo/assets/data/* tests/assets

assets-clean:
	-$(RM) -rf tests/assets

# Install dev dependencies with pip
deps-test:
	$(PIP) install -r requirements-test.txt

# Run tests with pytest
test:
	$(PYTHON) -m pytest  tests --durations=0 $(PYTEST_ARGS)

.PHONY: help deps deps-test install-fileformat install uninstall build docker
