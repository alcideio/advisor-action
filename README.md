# *Alcide Advisor* Action

[![](https://github.com/alcideio/advisor-action/workflows/Test/badge.svg?branch=master)](https://github.com/alcideio/advisor-action/actions)


A GitHub Action for security scan your Kubernetes clustet in a pipeline workflow.


## About *Alcide Advisor*

Alcide Advisor is an agentless service for Kubernetes audit and compliance that’s built to ensure a frictionless and secured DevSecOps workflow by layering a hygiene scan of Kubernetes cluster & workloads early in the development process and before moving to production. With Alcide Advisor, you can cover the following security checks:
*  Kubernetes infrastructure vulnerability scanning.
*  Hunting misplaced secrets, or excessive priviliges for secret access.
*  Workload hardening from Pod Security to network policies.
*  Istio security configuration and best practices.
*  Ingress Controllers for security best practices.
*  Kubernetes API server access privileges.
*  Kubernetes operators security best practices.
*  Deployment conformance to labeling, annotating, resource limits and much more ...


## Usage

### Pre-requisites

Create a workflow YAML file in your `.github/workflows` directory. An [example workflow](#example-workflow) is available below.
For more information, reference the GitHub Help Documentation for [Creating a workflow file](https://help.github.com/en/articles/configuring-a-workflow#creating-a-workflow-file).

### Inputs

For more information on inputs, see the [API Documentation](https://developer.github.com/v3/repos/releases/#input)

- `version`: The kind version to use (default: `v0.7.0`)
- `config`: The path to the kind config file
- `node_image`: The Docker image for the cluster nodes
- `cluster_name`: The name of the cluster to create (default: `chart-testing`)
- `wait`: The duration to wait for the control plane to become ready (default: `60s`)
- `log_level`: The log level for kind

### Example Workflow

Create a workflow (eg: `.github/workflows/create-cluster.yml`):

```yaml
name: Create Cluster

on: pull_request

jobs:
  create-cluster:
    runs-on: ubuntu-latest
    steps:
      - name: Create k8s Kind Cluster
        uses: alcideio/advisor-action@v1.0.0-alpha.3
```

This uses [@alcideio/advisor-action](https://www.github.com/alcideio/advisor-action) GitHub Action to spin up a [kind](https://kind.sigs.k8s.io/) Kubernetes cluster on every Pull Request.
See [@helm/chart-testing-action](https://www.github.com/helm/chart-testing-action) for a more practical example.

## Code of conduct

Participation in the Helm community is governed by the [Code of Conduct](CODE_OF_CONDUCT.md).
