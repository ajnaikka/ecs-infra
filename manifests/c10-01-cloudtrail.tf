#Create an s3 bucket to store the cloud trail logs.
resource "aws_s3_bucket" "ecs_cloudtrail_bucket" {
    bucket = "ecs-cloudtrail-logs-2707"
    tags = {
        Name = "ecs-cloudtrail-logs-2707"
    }
}

# Create a cloud trail to log all the API calls made to the AWS account.
resource "aws_cloudtrail" "ecs_cloudtrail" {
    name                          = "ecs-cloudtrail"
    s3_bucket_name                = aws_s3_bucket.ecs_cloudtrail_bucket.id
    s3_key_prefix                 = "ecs-cloudtrail"
    include_global_service_events = true
    is_multi_region_trail         = true
    enable_log_file_validation    = true
    depends_on                    = [aws_s3_bucket.ecs_cloudtrail_bucket, aws_s3_bucket_policy.ecs_cloudtrail_bucket_policy]
}


# Create a cloud watch log group to store the logs from the cloud trail.
resource "aws_cloudwatch_log_group" "ecs_cloudtrail_log_group" {
    name              = "ecs-cloudtrail-log-group"
    retention_in_days = 30
    depends_on        = [aws_cloudtrail.ecs_cloudtrail]
}

resource "aws_s3_bucket_policy" "ecs_cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.ecs_cloudtrail_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.ecs_cloudtrail_bucket.bucket}"
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.ecs_cloudtrail_bucket.bucket}/*",
      "Condition": {"StringEquals": {"s3:x-amz-acl": "bucket-owner-full-control"}}
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "ecs_cloudtrail_bucket_access_block" {
  bucket = aws_s3_bucket.ecs_cloudtrail_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}
