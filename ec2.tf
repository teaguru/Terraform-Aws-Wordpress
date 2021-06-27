resource "aws_instance" "ec2" {
  count = var.instance_count 
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [module.app_security_group.this_security_group_id]
  associate_public_ip_address = true
  key_name      = aws_key_pair.generated_key.key_name
  user_data = templatefile("${path.module}/init-script.sh", {
    efs_ip = "${aws_efs_mount_target.mount.ip_address}"
    srv_index = "${count.index}"
    mysqlhost = "${aws_db_instance.mysql.address}"
    mysqldb = "${aws_db_instance.mysql.name}"
    mysqluser = "${aws_db_instance.mysql.username}"
    mysqlpass = "${aws_db_instance.mysql.password}"
    siteurl = "${aws_lb.app.dns_name}"
    wp_post = file("wp_post.txt")
    

  })
  depends_on = [aws_efs_mount_target.mount]
  tags = {
    Name = "version-1.0-${count.index}"
  }
}





resource "aws_lb_target_group" "ec2" {
  name     = "ec2-tg-${random_pet.app.id}-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "ec2" {
  count            = length(aws_instance.ec2)
  target_group_arn = aws_lb_target_group.ec2.arn
  target_id        = aws_instance.ec2[count.index].id
  port             = 80
}

resource "random_pet" "app" {
  length    = 2
  separator = "-"
}
