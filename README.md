# Makefile Modules for Symfony Projects

This repository contains re-usable make file commands that should work as aliased for a project maintained
by "Team Mate Pro" software company.

All projects should follow internal conventions.

## Installation

Install via Composer:

```bash
composer require team-mate-pro/make
```

The installation will automatically:
- Copy the reference `Makefile` to your project root if one doesn't exist
- Create/update `Makefile.example` if a `Makefile` already exists

Then customize your Makefile and include the desired modules:

```makefile
# Define mandatory variables
docker-compose=docker compose
main-container-name=app

# Include desired modules from vendor
include vendor/team-mate-pro/make/git/MAKE_GIT_v1
include vendor/team-mate-pro/make/docker/MAKE_DOCKER_v1
include vendor/team-mate-pro/make/sf-7/MAKE_SYMFONY_v1
include vendor/team-mate-pro/make/phpcs/MAKE_PHPCS_v1
include vendor/team-mate-pro/make/phpunit/MAKE_PHPUNIT_v1
include vendor/team-mate-pro/make/phpstan/MAKE_PHPSTAN_v1
```

## Conventions

### 1. Docker

All projects must be run using `docker` and `docker compose`. Main container should be named `app`.

### 2. Each project must have `Makefile` that defines mandatory variables

```make
## --- Mandatory variables ---

docker-compose=docker compose
main-container-name=app

# ...

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
```