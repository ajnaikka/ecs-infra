resource "aws_iam_user" "jenkins_loyal_iam_user" {
  name = "jenkins-loyal-iam-user"
  path = "/system/"
}

resource "aws_iam_user_ssh_key" "ecs_iam_ssh_key" {
  username = aws_iam_user.jenkins_loyal_iam_user.name
  encoding = "SSH"
  public_key = file("~/.ssh/ecs.pub") # replace with the path to your public key
  status = "Active"
}

resource "aws_iam_access_key" "ecs_iam_access_key" {
  user = aws_iam_user.jenkins_loyal_iam_user.name
}

resource "aws_iam_policy" "ecs_codecommit_access_policy" {
  name = "ecs_codecommit_access_policy"
  description = "Allow full access to the codecommit repository"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCodeCommitAccess"
        Effect = "Allow"
        Action = ["codecommit:*"]
        Resource = [aws_codecommit_repository.ecs_codecommit_repo.arn]
      }
    ]
  })
}


resource "aws_iam_user_policy_attachment" "ecs_codecommit_access_policy_attachment" {
    user = aws_iam_user.jenkins_loyal_iam_user.name
    policy_arn = aws_iam_policy.ecs_codecommit_access_policy.arn
    }


output "name" {
  value = aws_iam_user.jenkins_loyal_iam_user.name
}
  
output "arn" {
  value = aws_iam_user.jenkins_loyal_iam_user.arn
}

output "access_key_id" {
  value = aws_iam_access_key.ecs_iam_access_key.id
}

output "access_key_secret" {
  value = aws_iam_access_key.ecs_iam_access_key.secret
  sensitive = true
}
