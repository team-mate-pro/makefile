# Makefile Modules for Symfony Projects

This repository contains re-usable make file commands that should work as aliased for a project maintained
by "Team Mate Pro" software company.

All projects should follow internal conventions.

## Installation

### Via npm (recommended for Node.js/Nuxt projects)

```bash
npm install --save-dev @team-mate-pro/make
```

Or with yarn:

```bash
yarn add -D @team-mate-pro/make
```

The installation will automatically:
- Copy the reference `Makefile` to your project root if one doesn't exist
- Create/update `Makefile.example` if a `Makefile` already exists

Then customize your Makefile and include the desired modules:

```makefile
# Define mandatory variables
docker-compose=docker compose
main-container-name=app

# Include desired modules from node_modules
include node_modules/@team-mate-pro/make/git/MAKE_GIT_v1
include node_modules/@team-mate-pro/make/docker/MAKE_DOCKER_v1
include node_modules/@team-mate-pro/make/sf-7/MAKE_SYMFONY_v1
include node_modules/@team-mate-pro/make/phpcs/MAKE_PHPCS_v1
include node_modules/@team-mate-pro/make/phpunit/MAKE_PHPUNIT_v1
include node_modules/@team-mate-pro/make/phpstan/MAKE_PHPSTAN_v1
include node_modules/@team-mate-pro/make/nuxt-3/MAKE_NUXT_v1
include node_modules/@team-mate-pro/make/nuxt-3/MAKE_NUXT_TESTS_v1
include node_modules/@team-mate-pro/make/nuxt-3/MAKE_NUXT_QA_v1
include node_modules/@team-mate-pro/make/claude/MAKE_CLAUDE_v1
```

### Via Composer (for PHP/Symfony projects)

```bash
composer require --dev team-mate-pro/make
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
include vendor/team-mate-pro/make/nuxt-3/MAKE_NUXT_v1
include vendor/team-mate-pro/make/nuxt-3/MAKE_NUXT_TESTS_v1
include vendor/team-mate-pro/make/nuxt-3/MAKE_NUXT_QA_v1
include vendor/team-mate-pro/make/claude/MAKE_CLAUDE_v1
```

## Available Modules

### Backend (PHP/Symfony)
- **git/** - Git workflow commands
- **docker/** - Docker and Docker Compose commands
- **sf-7/** - Symfony 7 specific commands
- **phpcs/** - PHP CodeSniffer commands
- **phpunit/** - PHPUnit testing commands
- **phpstan/** - PHPStan static analysis commands

### Frontend (JavaScript/Vue)
- **nuxt-3/** - Nuxt 3 development, testing, and QA commands

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

## Docker tools

Each project should have `tools/{env}/` directory that contains mandatory and re-usable component for defined 
environments. Sample output:

```bash
tools/
├── dev
│   ├── check.sh
│   ├── init-s3.sh
│   ├── fast.sh
│   ├── start.sh
│   └── stop.sh
├── prod
│   ├── post_deploy.sh
│   └── sync_permissions.sh
├── qa
│   └── git-checker.sh
└── test
    ├── application-tests-coverage.sh
    └── test.sh
```