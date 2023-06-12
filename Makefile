# template from https://ricardoanderegg.com/posts/makefile-python-project-tricks/
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
# .DELETE_ON_ERROR:
MAKEFLAGS = --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


MAKEFILE_PWD := $(CURDIR)
WORKTREE_ROOT := $(shell git rev-parse --show-toplevel 2> /dev/null)


# Using $$() instead of $(shell) to run evaluation only when it's accessed
# https://unix.stackexchange.com/a/687206
py = $$(if [ -d $(PWD)/'.venv' ]; then echo $(PWD)/".venv/bin/python3"; else echo "python3"; fi)
pip = $(py) -m pip

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show help text
	@echo "Commands:"
	@grep -E '^\.?[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

.venv: requirements.txt  ## Build the virtual environment
	$(py) -m venv .venv
	$(pip) install -U pip setuptools wheel build
	$(pip) install -U -r requirements.txt
	touch .venv
