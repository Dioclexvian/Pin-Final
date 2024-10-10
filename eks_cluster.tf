# resource "aws_eks_cluster" "eks" {
#   depends_on = [aws_subnet.subnet_public, aws_subnet.subnet_private1, aws_subnet.subnet_private2]
#   name     = var.cluster_name
#   role_arn = aws_iam_role.eks_role.arn
#   vpc_config {
#     subnet_ids = [
#       aws_subnet.subnet_public.id,
#       aws_subnet.subnet_private1.id,
#       aws_subnet.subnet_private2.id,
#     ]
#   }
# }


# resource "aws_eks_node_group" "node_group" {
#   depends_on = [aws_iam_role.eks_role, aws_key_pair.cluster_key]
#   cluster_name    = aws_eks_cluster.eks.name
#   node_role_arn   = aws_iam_role.node_group_role.arn
#   subnet_ids      = [aws_subnet.subnet_private1.id, aws_subnet.subnet_private2.id]

#   scaling_config {
#     desired_size = var.desired_capacity
#     max_size     = var.max_size
#     min_size     = var.min_size
#   }

#   instance_types = [var.node_instance_type]
  
#   remote_access {
#     ec2_ssh_key = aws_key_pair.cluster_key.key_name
#   }

#   ami_type        = "AL2_x86_64"
#   capacity_type   = "ON_DEMAND"
# }

