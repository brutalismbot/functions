FUNCTIONS   := $(shell command ls functions)
VENDOR_DIRS := $(foreach FUNCTION,$(FUNCTIONS),functions/$(FUNCTION)/lib/vendor)

plan: $(VENDOR_DIRS) | .terraform
	terraform plan

apply: $(VENDOR_DIRS) | .terraform
	terraform apply

clean:
	rm -rf .terraform

.PHONY: plan apply clean

.terraform .terraform.lock.hcl:
	terraform init
	touch $@

functions/%/lib/vendor: functions/%/lib/Gemfile
	cd $$(dirname $@) ; bundle
	touch $@
