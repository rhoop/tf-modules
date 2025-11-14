# aws-vpc

There is a `variables.tf` at the project root. It contains a listing of all the Terraform variables. Some defaults are set there as well. If you want to override any of them, override them in `terraform.tfvars`.

### Plan

The plan phase takes your Terraform configuration and attempts to provide you with a plan of what it **would** do if you applied it. It outputs an execution plan to `stdout` along a `terraform.tfplan` file (not human-readable).

```bash
$ terraform plan
Refreshing Terraform state prior to plan...

The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed.

Your plan was also saved to the path below. Call the "apply" subcommand
with this plan file and Terraform will exactly execute this execution
plan.

Path: terraform.tfplan
```

### Apply

The apply phase simply takes the Terraform execution plan and attempts to execute it. It outputs its progress to `stdout` along a `terraform.tfstate` file (not human-readable).

```bash
$ terraform apply
aws_vpc.default: Creating...
  cidr_block: "" => "10.0.0.0/16"
aws_vpc.default: Creation complete

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate
```

### Destroy

The destroy phase happens in two steps. First, Terraform generates a destroy execution plan, and then applies it. It outputs an execution plan to `stdout` along a new `terraform.tfplan` file. After that, it attempts to apply the destroy execution plan.

```bash
$ terradform destroy
Refreshing Terraform state prior to plan...

aws_vpc.default: Refreshing state... (ID: vpc-20bf1d45)

The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed.

Your plan was also saved to the path below. Call the "apply" subcommand
with this plan file and Terraform will exactly execute this execution
plan.

Path: terraform.tfplan

- aws_vpc.default


aws_vpc.default: Destroying...
aws_vpc.default: Destruction complete

Apply complete! Resources: 0 added, 0 changed, 1 destroyed.
```

**Note**: The `destroy` step usually has to be run more than once because of an issue with deleting the Elastic IP (EIP) before it is unbound from the NAT instance. Run `terraform destroy` again after the failure to complete the destroy phase.

### TODO
Add pgandluri@liquidhub.com  to RO for All
