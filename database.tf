resource "random_password" "db_pass" {
  length           = 20
  special          = false
#  override_special = "_%@"
}
resource "aws_db_instance" "mysql" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  identifier = "wp-db"
  name                   = "wp_db"
  username               = "wp_user"
  publicly_accessible    = false
  password               = random_password.db_pass.result
  skip_final_snapshot = true
  vpc_security_group_ids = [module.app_security_group.this_security_group_id]
  db_subnet_group_name = aws_db_subnet_group.main.id
  tags = {
    Name = "wp-db-instance"
  }
}