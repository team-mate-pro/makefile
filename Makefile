.PHONY: help

docker-compose=docker compose
main-container-name=app

help: ### Display available targets and their descriptions
	@echo "Usage: make [target]"
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?### "}; /^[a-zA-Z_-]+:.*?### / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

include git/MAKE_GIT_v1
include phpunit/MAKE_PHPUNIT_v1
include phpcs/MAKE_PHPCS_v1
include phpstan/MAKE_PHPSTAN_v1
include sf-7/MAKE_SYMFONY_v1
#include tools/dev/make/MAKE_SF
#include tools/dev/make/MAKE_QA
#include tools/dev/make/MAKE_PHPUNIT_v1
#include tools/dev/make/MAKE_GIT
