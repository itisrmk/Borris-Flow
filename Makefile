SHELL := /usr/bin/env bash

.PHONY: install install-force verify lint clean

SCRIPTS := \
	./borris-flow \
	./borris-workflow \
	./scripts/install-borris-workflow.sh \
	./scripts/borris-workflow.sh

install:
	@./scripts/install-borris-workflow.sh

install-force:
	@./scripts/install-borris-workflow.sh --force

verify:
	@for script in $(SCRIPTS); do \
		bash -n "$$script"; \
	done
	@./scripts/borris-workflow.sh --dry-run --json "smoke: verify parser and path resolution"

lint: verify

clean:
	@install_dir="$(HOME)/.local/bin"; \
	repo_root="$(shell pwd)"; \
	for name in borris-flow borris-workflow; do \
		path="$$install_dir/$$name"; \
		if [ -L "$$path" ]; then \
			resolved=""; \
			if command -v realpath >/dev/null 2>&1; then \
				resolved="`realpath "$$path"`"; \
			else \
				resolved="$(cd "$(dirname "$$path")" && pwd)/$$(readlink "$$path")"; \
			fi; \
			if [ "$$resolved" = "$$repo_root/$$name" ]; then \
				rm -f "$$path"; \
				echo "removed symlink: $$path"; \
			else \
				echo "skip: $$path does not point to this repo"; \
			fi; \
		else \
			echo "skip: no symlink at $$path"; \
		fi; \
	done
