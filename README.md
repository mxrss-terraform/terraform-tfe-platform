# Introduction 

These are the modules that are used in the terraform module that we use to provision
infrastructure. Each module has a series of E2E tests that can be used to determine if 
they work or if they need to be modified.

Modules are built in the following format

1. provisioning - provisions a resource or a set of resources

## Modules

1. `tfe/provisioning`

```bash
terraform test
```
 

# Getting Started

You will need to install `terraform ~1.7` and `terramate ~0.8.4`

