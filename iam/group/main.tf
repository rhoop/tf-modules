resource "aws_iam_group" "user_group" {
  name = var.group_name
}

resource "aws_iam_group_policy_attachment" "group_policy_attach" {
  group      = aws_iam_group.user_group.name
  policy_arn = var.group_iam_policy_arn
}

resource "aws_iam_group_membership" "group_members" {
  name = var.group_membership_name

  users = var.group_member_users

  group = aws_iam_group.user_group.name
}