# ah-terraform-consul

Example repo for managing Consul infrastructure and resources side-by-side.

## Directories

### Infra

Terraform to deploy a single-node Consul cluster and a VM running TFC Agent. The agent deploys Consul resources (kv key) to the Consul server as Terraform Cloud cannot reach Consul's API. Infrastructure is deployed to AWS; replace accordingly to support on-prem deployment.

### Management

Terraform for Consul resources which is only a single K/V key. ACL resources such as policies and roles should be maintained here.

### TFE

Terraform to deploy TFE projects, agent pool, workspaces and workspace settings. Enables the VCS workflows to deploy infrastructure and Consul resources from the same repository.

AWS IAM resources allow HCP Terraform to deploy AWS infra and are not applicable to on-prem TFE.