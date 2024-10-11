# resource "aws_iam_role" "ec2_role" {
#   name = "EC2_EKS_Role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action    = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "eks_policy_attachment" {
#   name       = "eks_policy_attachment"
#   roles      = [aws_iam_role.ec2_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# resource "aws_iam_policy_attachment" "eks_cni_policy_attachment" {
#   name       = "eks_cni_policy_attachment"
#   roles      = [aws_iam_role.ec2_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
# }

# resource "aws_iam_policy_attachment" "eks_read_only" {
#   name       = "eks_read_only"
#   roles      = [aws_iam_role.ec2_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSReadOnlyAccess"
# }

# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "EC2_EKS_Instance_Profile"
#   role = aws_iam_role.ec2_role.name
# }
