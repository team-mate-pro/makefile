### This is a reference (complete) MAKE file setup
### Remove the functionalities you don't need

.PHONY: help

## --- Mandatory variables ---

docker-compose=docker compose
main-container-name=app

help: ### Display available targets and their descriptions
	@echo "Usage: make [target]"
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?### "}; /^[a-zA-Z_-]+:.*?### / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

## --- General ---

# General git commands
include git/MAKE_GIT_v1

# Docker
include docker/MAKE_DOCKER_v1

# --- Backend ---

# Symfony +7
include sf-7/MAKE_SYMFONY_v1

# PHPCS
include phpcs/MAKE_PHPCS_v1

# PHPUNIT
include phpunit/MAKE_PHPUNIT_v1

# PHPSTAN
include phpstan/MAKE_PHPSTAN_v1

## --- Frontend ---

## --- Mandatory aliases ---

start: ### Full start and rebuild of the container
	echo "./tools/dev/start.sh"

fast: ### Fast start already built containers
	echo "./tools/dev/fast.sh"

stop: ### Stop all existing containers
	echo "./tools/dev/fast.sh"

check: ### [c] Should run all mandatory checks that run in CI and CD process
	echo "alias to makefile for example: make check: phpstan phpcs etc"

check_fast: ### [cf] Should run all mandatory checks that run in CI and CD process skiping heavy ones like functional tests
	echo "alias to makefile for example: make check: phpstan phpcs etc"

fix: ### [f] Should run auto fix checks that run in CI and CD process
	echo "alias to makefile for example: make check: phpcs_fix"