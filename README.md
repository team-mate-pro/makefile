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
include vendor/team-mate-pro/make/nuxt-3/MAKE_NUXT_v1
include vendor/team-mate-pro/make/nuxt-3/MAKE_NUXT_TESTS_v1
include vendor/team-mate-pro/make/nuxt-3/MAKE_NUXT_QA_v1
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

## Nuxt 3 Commands

### Development Commands (MAKE_NUXT_v1)
- `make nuxt_install` - Install npm dependencies
- `make nuxt_dev` - Start Nuxt development server
- `make nuxt_dev_host` - Start dev server with host exposed
- `make nuxt_build` - Build for production
- `make nuxt_generate` - Generate static site (SSG)
- `make nuxt_preview` - Preview production build
- `make nuxt_clean` - Clean node_modules and cache
- `make nuxt_postinstall` - Run postinstall script
- `make nuxt_upgrade` - Upgrade Nuxt to latest version

### Testing Commands (MAKE_NUXT_TESTS_v1)
- `make nuxt_test` - Run all tests
- `make nuxt_test_unit` - Run unit tests with Vitest
- `make nuxt_test_unit_watch` - Run unit tests in watch mode
- `make nuxt_test_unit_coverage` - Run unit tests with coverage
- `make nuxt_test_e2e` - Run e2e tests with Playwright
- `make nuxt_test_e2e_ui` - Run e2e tests with UI mode
- `make nuxt_test_component` - Run component tests

### Quality Assurance Commands (MAKE_NUXT_QA_v1)
- `make nuxt_qa` - Run all QA checks
- `make nuxt_lint` - Run ESLint
- `make nuxt_lint_fix` - Auto-fix ESLint issues
- `make nuxt_format` - Format code with Prettier
- `make nuxt_format_check` - Check code formatting
- `make nuxt_typecheck` - Run TypeScript type checking
- `make nuxt_analyze` - Analyze bundle size
```