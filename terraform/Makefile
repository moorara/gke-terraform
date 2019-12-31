account_file := account.json
project := $(shell cat terraform.tfvars | grep project | grep -oe '".*"')
region := $(shell cat terraform.tfvars | grep region | grep -oe '".*"')
environment := $(shell cat terraform.tfvars | grep environment | grep -oe '".*"')

uuid := $(shell uuidgen | tr [:upper:] [:lower:])
owner := $(shell whoami)
branch := $(shell git rev-parse --abbrev-ref HEAD)
commit := $(shell git rev-parse --short HEAD)

ssh_user := admin
key_name := gke-$(environment)-$(region)-bastion


.PHONY: clean
clean:
	@ rm -rf .terraform terraform.tfstate terraform.tfstate.backup && \
	  rm -f *.pub *.pem $(key_name)

.PHONY: keys
keys:
	@ ssh-keygen -f $(key_name) -t rsa -N '' -C $(ssh_user) 1> /dev/null && \
	  chmod 400 $(key_name) && \
	  mv $(key_name) $(key_name).pem

.PHONY: init
init:
	@ GOOGLE_APPLICATION_CREDENTIALS="$(account_file)" \
	  terraform init \
	    -backend-config="bucket=terraform-$(project)" \
	    -backend-config="prefix=$(environment)/state" \

.PHONY: validate
validate:
	@ terraform validate

.PHONY: plan
plan:
	@ GOOGLE_APPLICATION_CREDENTIALS="$(account_file)" \
	  terraform plan \
	    -var uuid=$(uuid) \
	    -var owner=$(owner) \
	    -var git_branch=$(branch) \
	    -var git_commit=$(commit)

.PHONY: apply
apply:
	@ GOOGLE_APPLICATION_CREDENTIALS="$(account_file)" \
	  terraform apply \
	    -var uuid=$(uuid) \
	    -var owner=$(owner) \
	    -var git_branch=$(branch) \
	    -var git_commit=$(commit)

.PHONY: refresh
refresh:
	@ GOOGLE_APPLICATION_CREDENTIALS="$(account_file)" \
	  terraform refresh \
	    -var uuid=$(uuid) \
	    -var owner=$(owner) \
	    -var git_branch=$(branch) \
	    -var git_commit=$(commit)

.PHONY: destroy
destroy:
	@ GOOGLE_APPLICATION_CREDENTIALS="$(account_file)" \
	  terraform destroy \
	    -var uuid=$(uuid) \
	    -var owner=$(owner) \
	    -var git_branch=$(branch) \
	    -var git_commit=$(commit)
