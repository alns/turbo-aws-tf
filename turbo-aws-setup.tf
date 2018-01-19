provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_iam_access_key" "lb" {
  user = "${aws_iam_user.lb.name}"
}

resource "aws_iam_user" "lb" {
  name = "${var.user_name}"
}

resource "aws_iam_group_membership" "turbo_access_group" {
  name = "turbonomic-access-group-membership"

  users = [
    "${aws_iam_user.lb.name}",
  ]

  group = "${var.rw_user == "1" ? aws_iam_group.turbo_rw_group.name : aws_iam_group.turbo_ro_group.name}"
}

resource "aws_iam_group_policy" "lb_rw" {
  name   = "TurbonomicRWIAMPolicy"
  policy = "${file("TurboRWGroupPolicy.json")}"
  group  = "${aws_iam_group.turbo_rw_group.id}"
}

resource "aws_iam_group_policy" "lb_ro" {
  name   = "TurbonomicROIAMPolicy"
  policy = "${file("TurboROGroupPolicy.json")}"
  group  = "${aws_iam_group.turbo_ro_group.id}"
}

resource "aws_iam_group" "turbo_rw_group" {
  name = "TurbonomicRWgroup"
  path = "/"
}

resource "aws_iam_group" "turbo_ro_group" {
  name = "TurbonomicROgroup"
  path = "/"
}

output "Group applied" {
  value = "${aws_iam_group_membership.turbo_access_group.group}"
}

output "User applied" {
  value = "${aws_iam_user.lb.name}"
}

output "User access key" {
  value = "${aws_iam_access_key.lb.id}"
}

output "User secret" {
  value = "${aws_iam_access_key.lb.secret}"
}

output "User ARN" {
  value = "${aws_iam_user.lb.arn}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "TurboPolicyCUR",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.lb.arn}",
        "AWS": "386209384616"
      },
      "Action": [
        "s3:GetBucketAcl",
        "s3:GetBucketPolicy"
      ],
      "Resource": "arn:aws:s3:::${var.bucket_name}"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.lb.arn}",
        "AWS": "386209384616"
      },
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
POLICY
}

output "S3 CUR bucket name" {
  value = "${var.bucket_name}"
}

output "S3 CUR bucket path" {
  value = "/"
}
