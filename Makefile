DEFAULT_ENV := local

ifeq ($(wildcard .env),)
    ifneq ($(filter fresh, $(MAKECMDGOALS)), fresh)
        $(error .env file not found. Please run 'make fresh' first)
    endif
else
    include .env
    export ENV
endif

TF_DIR := terraform
TF := terraform -chdir=$(TF_DIR)
TF_VARS_ARGS := -var 'environment=$(ENV)' -var-file="tfvars/$(ENV).tfvars"

.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))
.DEFAULT_GOAL := help
help:
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'
fresh:
	[ -f .env ] || echo 'ENV=$(DEFAULT_ENV)' > .env; \
	source .env; \
	[ -f $(TF_DIR)/tfvars/$${ENV}.tfvars ] || cp $(TF_DIR)/tfvars/terraform.tfvars.example $(TF_DIR)/tfvars/$${ENV}.tfvars
init:
	set -xe; \
	$(TF) init -upgrade $(TF_VARS_ARGS); \
	$(TF) providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64 -platform=darwin_arm64 -platform=linux_arm64 $(TF_VARS_ARGS)
plan:
	set -xe; \
	$(TF) plan $(TF_VARS_ARGS)
apply:
	set -xe; \
	$(TF) apply -auto-approve $(TF_VARS_ARGS)
destroy:
	set -xe; \
	$(TF) destroy -auto-approve $(TF_VARS_ARGS)
