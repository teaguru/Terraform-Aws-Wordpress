# Creating EFS file system
resource "aws_efs_file_system" "efs" {
  creation_token = "wp-store"
  encrypted = true
  tags = {
    Name = "WP-EFS-Store"
  }
}

resource "aws_efs_mount_target" "mount" {

  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = module.vpc.private_subnets[0]
  security_groups = [module.app_security_group.this_security_group_id]
}

