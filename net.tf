resource "aws_db_subnet_group" "main" {
  name = "db-private-subnets"
  subnet_ids = module.vpc.private_subnets
  tags = {
    Name = "db-subnet-group"
  }
}