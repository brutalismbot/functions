FUNCTIONS   := $(shell command ls functions)
VENDOR_DIRS := $(foreach FUNCTION,$(FUNCTIONS),functions/$(FUNCTION)/lib/vendor)

init: $(VENDOR_DIRS)
	terraform init

plan:
	terraform plan

apply:
	terraform apply

clean:
	rm -rf .terraform

.PHONY: init plan apply clean

functions/%/lib/vendor: functions/%/lib/Gemfile
	cd $$(dirname $@) ; bundle
	touch $@
