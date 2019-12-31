[![Build Status][workflow-image]][workflow-url]

# gke-terraform

## TO-DO

  - [ ] Use a real domain name and storage bucket
  - [ ] Making the cluster private and accessing the cluster only through a bastion host

## Prerequisites

You need to have the following tools installed:

  - [Terraform](https://www.terraform.io)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)

## Deployment

### Prerequisites

You need to have the following Google Cloud resources ready:

  - A **Storage Bucket** for Terraform backend state named as `terraform-<project-id>`

### Preparation

Inside `terraform` directory, you need to create a file named `terraform.tfvars` with the following variables set.

```
project     = <project-id>
region      = <google-cloud-region>
environment = <environment-name>
```

### Deployment

First run `make init plan` and once everything is green, you can run `make apply` to deploy the cluster.

## Tear Down

For tearing down the cluster, run `make destroy`.

## References

  - [Bucket Naming](https://cloud.google.com/storage/docs/naming)
  - [Bucket Verification](https://cloud.google.com/storage/docs/domain-name-verification)

### Google Cloud

  - [Compute](https://cloud.google.com/compute)
    - [Instance Groups](https://cloud.google.com/compute/docs/instance-groups)
    - [Instance Templates](https://cloud.google.com/compute/docs/instance-templates)
    - [Minimum CPU Platform](https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform)
  - [Preemptible VMs](https://cloud.google.com/preemptible-vms)
  - [Kubernetes Engine](https://cloud.google.com/kubernetes-engine)
    - [Concepts](https://cloud.google.com/kubernetes-engine/docs/concepts)
      - [Node Pools](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools)
    - [Guides](https://cloud.google.com/kubernetes-engine/docs/how-to)
      - [Preemptible VMs](https://cloud.google.com/kubernetes-engine/docs/how-to/preemptible-vms)
      - [Minimum CPU Platform](https://cloud.google.com/kubernetes-engine/docs/how-to/min-cpu-platform)
    - [API](https://cloud.google.com/kubernetes-engine/docs/reference/rest)
      - [NodeConfig](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1/NodeConfig)
  - [Labels](https://cloud.google.com/resource-manager/docs/creating-managing-labels)

#### Authentication

  - [Getting Started](https://cloud.google.com/docs/authentication/getting-started)
  - [Production Applications](https://cloud.google.com/docs/authentication/production)


[workflow-url]: https://github.com/moorara/gke-terraform/actions
[workflow-image]: https://github.com/moorara/gke-terraform/workflows/Main/badge.svg
