
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
0) Download and install Terraform (https://www.terraform.io/downloads.html)
1) CD into this directory
2) If this is the first time running, launch 'Terraform init'
3) Configure variables.tf as appropriate (see inline for doc)
4) exec `terraform plan -out turbo_account_plan`
5) if there are no errors `exec terraform apply turbo_account_plan`
