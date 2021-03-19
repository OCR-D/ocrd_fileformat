PROJECT_NAME := ocrd_fileformat
SCRIPTS = ocrd-fileformat-transform
DOCKER_TAG = ocrd/fileformat

PIP ?= pip3

# Directory to install to ('$(PREFIX)')
PREFIX ?= $(if $(VIRTUAL_ENV),$(VIRTUAL_ENV),/usr/local)

BINDIR = $(PREFIX)/bin
SHAREDIR = $(PREFIX)/share/$(PROJECT_NAME)
TESTDIR = tests

# BEGIN-EVAL makefile-parser --make-help Makefile

help:
	@echo ""
	@echo "  Targets"
	@echo ""
	@echo "    deps               Install python packages"
	@echo "    install            Install the executable in $(PREFIX)/bin and the ocrd-tool.json to $(SHAREDIR)"
	@echo "    uninstall          Uninstall scripts and $(SHAREDIR)"
	@echo "    docker             Build Docker image"
	@echo "    $(TESTDIR)/assets  Setup test assets"
	@echo "    assets-clean       Remove $(TESTDIR)/assets"
	@echo "    deps-test          Install dev dependencies with pip"
	@echo "    test               Run tests with pytest"
	@echo ""
	@echo "  Variables"
	@echo ""
	@echo "    PREFIX  Directory to install to ('$(PREFIX)')"

# END-EVAL

# Install python packages
deps:
	$(PIP) install -U ocrd # needed for ocrd CLI (and bashlib)

install-fileformat:
	make -C repo/ocr-fileformat PREFIX=$(PREFIX) vendor install

# Install the executable in $(PREFIX)/bin and the ocrd-tool.json to $(SHAREDIR)
install: install-fileformat deps
	mkdir -p $(BINDIR)
	for script in $(SCRIPTS);do \
		sed 's,^SHAREDIR.*,SHAREDIR="$(SHAREDIR)",' $$script > $(BINDIR)/$$script ;\
		chmod a+x $(BINDIR)/$$script ;\
	done
	mkdir -p $(SHAREDIR)
	cp ocrd-tool.json $(SHAREDIR)
ifeq ($(findstring $(BINDIR),$(subst :, ,$(PATH))),)
	@echo "you need to add '$(BINDIR)' to your PATH"
else
	@echo "you already have '$(BINDIR)' in your PATH. good job."
endif

# Uninstall scripts and $(SHAREDIR)
uninstall:
	for script in $(SCRIPTS);do \
		rm --verbose --force "$(BINDIR)/$$script";\
	done
	rm -rfv $(SHAREDIR)
	make -C repo/ocr-fileformat PREFIX=$(PREFIX) uninstall

# Build Docker image
docker:
	docker build -t '$(DOCKER_TAG)' .

#
# Assets
#

repo/assets repo/ocr-fileformat:
	git submodule update --init

.PHONY: assets $(TESTDIR)/assets
assets: repo/assets $(TESTDIR)/assets

# Setup test assets
$(TESTDIR)/assets:
	mkdir -p $(TESTDIR)/assets
	cp -r -t $(TESTDIR)/assets repo/assets/data/*

# Remove $(TESTDIR)/assets
assets-clean:
	rm -rf $(TESTDIR)/assets

# Install dev dependencies with pip
deps-test:
	$(PIP) install -r requirements-test.txt

# Run tests with pytest
test: install deps-test assets
	PATH="$(PREFIX)/bin:$$PATH" pytest tests



.PHONY: help deps install-fileformat install uninstall docker
