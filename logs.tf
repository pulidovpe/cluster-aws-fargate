# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "erp_log_group" {
   name              = "/ecs/app"
   retention_in_days = 30

   tags = {
      Name = "erp-log-group"
   }
}

# resource "aws_cloudwatch_log_stream" "erp_log_stream" {
#   name           = "erp-log-stream"
#   log_group_name = aws_cloudwatch_log_group.erp_log_group.name
# }

# -----------------------------------------------------------------------------
# Create IAM for logging
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "erp_log_publishing" {
   statement {
      actions = [
         "logs:CreateLogStream",
         "logs:PutLogEvents",
         "logs:PutLogEventsBatch",
      ]

      resources = ["arn:aws:logs:${var.aws_region}:*:log-group:/ecs/app:*"]
   }
}

resource "aws_iam_policy" "erp_log_publishing" {
   name        = "erp-log-pub"
   path        = "/"
   description = "Allow publishing to cloudwach"

   policy = data.aws_iam_policy_document.erp_log_publishing.json
}

data "aws_iam_policy_document" "erp_assume_role_policy" {
   statement {
      actions = ["sts:AssumeRole"]

      principals {
         type        = "Service"
         identifiers = ["ecs-tasks.amazonaws.com"]
      }
   }
}

resource "aws_iam_role" "erp_role" {
   name               = "erp-role"
   path               = "/system/"
   assume_role_policy = data.aws_iam_policy_document.erp_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "erp_role_log_publishing" {
   role       = aws_iam_role.erp_role.name
   policy_arn = aws_iam_policy.erp_log_publishing.arn
}