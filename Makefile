### This is a reference (complete) MAKE file setup
### Remove the functionalities you don't need

.PHONY: help

### --- Mandatory variables ---
#
#docker-compose=docker compose
#main-container-name=app
#
#help: ### Display available targets and their descriptions
#	@echo "Usage: make [target]"
#	@echo "Targets:"
#	@awk 'BEGIN {FS = ":.*?### "}; /^[a-zA-Z_-]+:.*?### / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
#	@echo ""
#
### --- General ---
#
## General git commands
#include vendor/team-mate-pro/make/git/MAKE_GIT_v1
#
## Docker
#include vendor/team-mate-pro/make/docker/MAKE_DOCKER_v1
#
## --- Backend ---
#
## Symfony +7
#include vendor/team-mate-pro/make/sf-7/MAKE_SYMFONY_v1
#
## PHPCS
#include vendor/team-mate-pro/make/phpcs/MAKE_PHPCS_v1
#
## PHPUNIT
#include vendor/team-mate-pro/make/phpunit/MAKE_PHPUNIT_v1
#
## PHPSTAN
#include vendor/team-mate-pro/make/phpstan/MAKE_PHPSTAN_v1
#
### --- Frontend ---
#
## Vue
#
#run_form: ### Runs complain form vue in dev mode from the host machine
#	cd srr-form-vue && npm run dev
#
### --- Mandatory aliases ---
#
#start: ### Full start and rebuild of the container
#	./tools/dev/stop.sh
#	./tools/dev/start.sh
#
#fast: ### Fast start already built containers
#	./tools/dev/fast.sh
#
#stop: ### Stop all existing containers
#	./tools/dev/stop.sh
#
#check: ### [c] Should run all mandatory checks that run in CI and CD process
#	make phpcs
#	make phpstan
#	make tests
#
#check_fast: ### [cf] Should run all mandatory checks that run in CI and CD process skipping heavy ones like functional tests
#	make phpcs_fix
#	make phpcs
#	make phpstan
#
#fix: ### [f] Should run auto fix checks that run in CI and CD process
#	make phpcs_fix
#
#tests: ### [t] Run all tests defined in the project
#	make tests_unit
#	make tests_integration
#	make tests_application
#
### --- Project related scripts ---
#
#dev_seed: ### [ds] Seeds local environment
#	$(docker-compose) exec -it app composer dev:seed
#
#prod_seed: ### [ps] Seeds local environment like a prod is
#	$(docker-compose) exec -it app composer app:seed:prod
#
#ssh_stage: ### Fake temporary stage ssh
#	ssh ubuntu@54.38.55.136
#
#c: check
#cf: check_fast
#f: fix
#t: tests
#ds: dev_seed
#ps: prod_seed

## Local

publish_dev_main: ### [pdm] Remove dev-master tag locally and remotely, push master branch and tags
	git push origin :refs/tags/dev-main || true
	git tag -d dev-master || true
	git push origin main
	git push origin --tags