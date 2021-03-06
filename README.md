# *Alcide Advisor* Action

![Alcide Advisor](https://codelab.alcide.io/images/card-frontpage/frontpage-alcide-advisor.png "Alcide Advisor")


A GitHub Action to add security scanning of your Kubernetes cluster as part of your pipeline workflow.
To customize the scan [Create Alcide Advisor Account](https://www.alcide.io/pricing).


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

  - `include_namespaces`: Namespaces to include in the scan - defaults to all
  - `exclude_namespaces`: Namespaces to exclude in the scan - defaults to kube-system,istio-system
  - `output_file`: Scan result file name. You can publish this artifact in a later step.
  - `fail_on_critical`: Fail the task if critical findings observed.
  - `policy_profile`:Alcide policy profile the cluster will be scanned against. 
  - `policy_profile_id`: The profile id with which cluster should be scanned. Note - Alcide Api Key is required to run a scan with customized profile 
  - `alcide_apikey`: Alcide API Key - to run advisor scan with customized profile an api-key is needed - login to your account to obtain one
  - `alcide_apiserver`: Alcide API Server - The api server provisioned to your account

![Alcide Kubernetes Advisor](https://d2908q01vomqb2.cloudfront.net/77de68daecd823babbb58edb1c8e14d7106e83bb/2019/06/19/Alcide-Advisor-Amazon-EKS-1.png "Alcide Kubernetes Advisor")

### Example Workflow

Create a workflow (eg: `.github/workflows/advisor-scan.yml`):

```yaml
name: Alcide Advisor Workflow Example

on:
  pull_request:
  push:
    branches:
      - '*'
      - '!master'

jobs:
  advisor-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v1

      - name: Launch Cluster
        uses: helm/kind-action@v1.0.0-alpha.3
        with:
          version: v0.7.0
          name: kruzer
          node_image: kindest/node:v1.16.4
          wait: 5m
          install_local_path_provisioner: true

      - name: Test
        run: |
          kubectl cluster-info
          kubectl get storageclass standard

      - name: Scan Local Cluster
        uses: alcideio/advisor-action@v1.1.0   
        with:
          exclude_namespaces: '-'
          include_namespaces: '*'
          output_file: 'advisor-scan.html'

      - name: Upload Alcide Advisor Scan Report
        uses: actions/upload-artifact@v1
        with:
          name: advisor-scan.html 
          path: advisor-scan.html         
```

This uses [@alcideio/advisor-action](https://www.github.com/alcideio/advisor-action) GitHub Action to security scan your Kubernetes cluster configuration.

## Additional References

* [Alcide Advisor Overview](https://www.alcide.io/kubernetes-advisor)
* [Alcide Advisor on GitHub](https://github.com/alcideio/advisor)
* [Alcide Codelabs](https://codelab.alcide.io)

## Code of conduct

Participation in the Helm community is governed by the [Code of Conduct](CODE_OF_CONDUCT.md).
