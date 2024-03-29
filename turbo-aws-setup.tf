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

output "group_applied" {
  value = "${aws_iam_group_membership.turbo_access_group.group}"
}

output "user_applied" {
  value = "${aws_iam_user.lb.name}"
}

output "user_access_key" {
  value = "${aws_iam_access_key.lb.id}"
}

output "user_secret" {
  value = "${aws_iam_access_key.lb.secret}"
  sensitive = true
}

output "user_arn" {
  value = "${aws_iam_user.lb.arn}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "bucket_policy_from_another" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json

}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type     = "AWS"
      identifiers = [
      		  "${aws_iam_user.lb.arn}",
		  "386209384616"
      ] 
    }

    actions = [
       "s3:GetBucketAcl",
       "s3:GetBucketPolicy",
       "s3:PutObject"
    ]

    resources = [
    	      aws_s3_bucket.bucket.arn,
	      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }
}

/*
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
*/

output "s3_cur_bucket_name" {
  value = "${var.bucket_name}"
}

output "s3_cur_bucket_path" {
  value = "/"
}
