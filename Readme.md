
What is this?
-------------
This is a terraform project which will configure an AWS account for use with Turbonomic. It will

1) Create (or update) a user for use with Turbonomic
2) Create a RO and RW group for the user in #1
3) Join the user to the RO group unless rw group is preferred (see below)
4) Create an S3 bucket for the Turbonomic cost-and-usage report with appropriate permissions

What is Terraform?
------------------
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

Configuration files describe to Terraform the components needed to run a single application or your entire datacenter. Terraform generates an execution plan describing what it will do to reach the desired state, and then executes it to build the described infrastructure. As the configuration changes, Terraform is able to determine what changed and create incremental execution plans which can be applied.

See below for more detail
https://www.terraform.io/intro/index.html

How do I use this?
------------------
1) Download and install Terraform (https://www.terraform.io/downloads.html) or install from your favorite package manager (homebrew)
2) CD into this directory
3) If this is the first time running, launch 'Terraform init'
4) Configure variables.tf as appropriate (see inline for doc, but you may also want to pass in over rides using the command line)
5) exec `terraform plan -out turbo_account_plan` (use -var=FOO if you haven't updated variables.tf)
6) if there are no errors exec `terraform apply turbo_account_plan`

The cloud target and the cost-and-usae report will need to be manually configured with the bucket name and path provided as output.
