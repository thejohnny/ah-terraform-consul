# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
}

data "aws_iam_openid_connect_provider" "app_terraform_io" {
  arn = "arn:aws:iam::727169316875:oidc-provider/app.terraform.io"
}

# Creates a role which can only be used by the specified Terraform
# cloud workspace.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "tfc_role" {
  name = "ah-consul-infra-nva1-dev"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
       "Federated": "${data.aws_iam_openid_connect_provider.app_terraform_io.arn}"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringEquals": {
         "${var.tfc_hostname}:aud": "${one(data.aws_iam_openid_connect_provider.app_terraform_io.client_id_list)}"
       },
       "StringLike": {
         "${var.tfc_hostname}:sub": "organization:${data.tfe_organization.is.name}:project:${tfe_project.consul_infra.name}:workspace:${tfe_workspace.nva1_dev.name}:run_phase:*"
       }
     }
   }
 ]
}
EOF
}

# Creates a policy that will be used to define the permissions that
# the previously created role has within AWS.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "tfc_policy" {
  name        = "ah-consul-infra-nva1-dev"
  description = "TFC run policy"

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "*"
     ],
     "Resource": "*"
   }
 ]
}
EOF
}

# Creates an attachment to associate the above policy with the
# previously created role.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = aws_iam_policy.tfc_policy.arn
}

output "openid_claims" {
  description = "OpenID Claims for trust relationship"
  value       = one(jsondecode(aws_iam_role.tfc_role.assume_role_policy).Statement).Condition
}

output "role_arn" {
  description = "ARN for trust relationship role"
  value       = aws_iam_role.tfc_role.arn
}
