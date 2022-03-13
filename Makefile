FUNCTIONS   := $(shell command ls functions)
VENDOR_DIRS := $(foreach FUNCTION,$(FUNCTIONS),functions/$(FUNCTION)/lib/vendor)

plan: .terraform $(VENDOR_DIRS)
	terraform plan

apply: .terraform $(VENDOR_DIRS)
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
