# Makefile for bb-cli-examples.
#
# Purpose:
#   Provide simple, safe commands for installing `bb`, verifying this examples
#   repository, and running Phase 0 examples.
#
# Repository role:
#   bb-cli-examples teaches users how to use the BrikByteOS `bb` CLI.
#
# This repository must not:
#   - build the bb CLI source
#   - publish bb release artifacts
#   - contain private credentials
#   - duplicate the release pipeline
#
# Source/build repo:
#   BrikByte-Studios/bb-cli
#
# Public installer/release repo:
#   BrikByte-Studios/bb-cli-releases

SHELL := /usr/bin/env bash

INSTALLER_URL ?= https://raw.githubusercontent.com/BrikByte-Studios/bb-cli-releases/main/install.sh
INSTALL_DIR ?= $(HOME)/.local/bin
BB ?= $(INSTALL_DIR)/bb
VERSION ?=

BASIC_EXAMPLE_DIR := examples/phase0-basic-project

.PHONY: \
	help \
	install install-version install-dry-run uninstall \
	version doctor \
	verify verify-examples verify-no-secrets verify-basic-example \
	run-basic-example run-basic-script \
	clean upgrade downgrade

help:
	@echo "bb-cli-examples commands"
	@echo ""
	@echo "Install:"
	@echo "  make install                  Install latest stable bb"
	@echo "  make install-version VERSION=v0.1.0"
	@echo "  make install-dry-run          Preview install without writing files"
	@echo "  make uninstall                Remove bb from INSTALL_DIR"
	@echo ""
	@echo "Use bb:"
	@echo "  make version                  Run bb version"
	@echo "  make doctor                   Run bb doctor"
	@echo ""
	@echo "Examples:"
	@echo "  make run-basic-example        Run the Phase 0 basic project commands"
	@echo "  make run-basic-script         Run the demo hello.sh script"
	@echo ""
	@echo "Verification:"
	@echo "  make verify                   Verify repository and examples"
	@echo "  make verify-examples          Verify required example files"
	@echo "  make verify-no-secrets        Scan for obvious secret-like content"
	@echo "  make verify-basic-example     Verify Phase 0 basic example files"
	@echo ""
	@echo "  make upgrade                  Upgrade bb to latest stable"
	@echo "  make downgrade VERSION=v0.1.0 Install/downgrade to a specific version"
	@echo ""
	@echo "Variables:"
	@echo "  INSTALL_DIR=$(INSTALL_DIR)"
	@echo "  BB=$(BB)"
	@echo "  VERSION=$(VERSION)"

install:
	@echo "Installing latest stable bb into $(INSTALL_DIR)"
	@curl -sSL "$(INSTALLER_URL)" | bash -s -- --install-dir "$(INSTALL_DIR)"
	@$(BB) version

install-version:
	@if [[ -z "$(VERSION)" ]]; then \
		echo "VERSION is required. Example: make install-version VERSION=v0.1.0"; \
		exit 1; \
	fi
	@echo "Installing bb $(VERSION) into $(INSTALL_DIR)"
	@curl -sSL "$(INSTALLER_URL)" | bash -s -- --version "$(VERSION)" --install-dir "$(INSTALL_DIR)"
	@$(BB) version

install-dry-run:
	@echo "Running installer dry-run"
	@if [[ -n "$(VERSION)" ]]; then \
		curl -sSL "$(INSTALLER_URL)" | bash -s -- --version "$(VERSION)" --install-dir "$(INSTALL_DIR)" --dry-run; \
	else \
		curl -sSL "$(INSTALLER_URL)" | bash -s -- --install-dir "$(INSTALL_DIR)" --dry-run; \
	fi

uninstall:
	@echo "Removing $(BB)"
	@rm -f "$(BB)"
	@echo "Uninstall complete."

version:
	@$(BB) version

doctor:
	@$(BB) doctor

run-basic-example: verify-basic-example
	@echo "Running Phase 0 basic project example"
	@cd "$(BASIC_EXAMPLE_DIR)" && "$(BB)" version
	@cd "$(BASIC_EXAMPLE_DIR)" && "$(BB)" doctor
	@cd "$(BASIC_EXAMPLE_DIR)" && "$(BB)" config validate

run-basic-script: verify-basic-example
	@cd "$(BASIC_EXAMPLE_DIR)" && chmod +x scripts/hello.sh
	@cd "$(BASIC_EXAMPLE_DIR)" && ./scripts/hello.sh

verify: verify-examples verify-no-secrets
	@echo "bb-cli-examples verification passed"

verify-examples: verify-basic-example
	@echo "examples verification passed"

verify-basic-example:
	@test -f "$(BASIC_EXAMPLE_DIR)/README.md"
	@test -f "$(BASIC_EXAMPLE_DIR)/brikbyteos.yaml"
	@test -f "$(BASIC_EXAMPLE_DIR)/scripts/hello.sh"
	@test -f "$(BASIC_EXAMPLE_DIR)/expected-output/version.txt"
	@test -f "$(BASIC_EXAMPLE_DIR)/expected-output/doctor.txt"
	@test -f "$(BASIC_EXAMPLE_DIR)/expected-output/config-validate.txt"
	@bash -n "$(BASIC_EXAMPLE_DIR)/scripts/hello.sh"
	@echo "basic example verification passed"

verify-no-secrets:
	@echo "Scanning for obvious secret-like content"
	@if grep -RInE '(GITHUB_TOKEN|DIST_RELEASE_TOKEN|SECRET=|PASSWORD=|PRIVATE KEY|BEGIN RSA|BEGIN OPENSSH|BEGIN PRIVATE KEY)' . \
		--exclude-dir=.git \
		--exclude=Makefile; then \
		echo "Possible secret-like content found."; \
		exit 1; \
	fi
	@echo "no obvious secrets found"

clean:
	@find . -name ".DS_Store" -delete
	@find . -name "*.tmp" -delete
	@echo "clean complete"

upgrade:
	@echo "Upgrading bb to the latest stable version in $(INSTALL_DIR)"
	@curl -sSL "$(INSTALLER_URL)" | bash -s -- --install-dir "$(INSTALL_DIR)"
	@$(BB) version

downgrade:
	@if [[ -z "$(VERSION)" ]]; then \
		echo "VERSION is required. Example: make downgrade VERSION=v0.1.0"; \
		exit 1; \
	fi
	@echo "Downgrading/installing bb $(VERSION) into $(INSTALL_DIR)"
	@curl -sSL "$(INSTALLER_URL)" | bash -s -- --version "$(VERSION)" --install-dir "$(INSTALL_DIR)"
	@$(BB) version