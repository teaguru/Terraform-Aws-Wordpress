#!/bin/bash
exec > >(tee -a "/tmp/init.log") 2>&1
#sudo yum update -y
sudo yum install httpd mysql -y
sudo amazon-linux-extras install -y php7.2
#sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo systemctl enable httpd
sudo systemctl start httpd
sudo echo "${efs_ip}:/ /var/www/html nfs4 defaults,_netdev 0 0" | sudo tee -a /etc/fstab
#sleep 10
sudo mount -a
touch /tmp/srv-${srv_index}
## use srv 0 to deploy
if [[ ${srv_index} -eq 0 ]]; then
  cd /tmp
  wget https://ru.wordpress.org/wordpress-5.7.2-ru_RU.tar.gz
  tar -xzf wordpress-5.7.2-ru_RU.tar.gz
  sudo cp -r wordpress/* /var/www/html/
#  sudo chown -R apache:apache /var/www/html/
#  sudo chmod -R 755 /var/www/html/
  sudo service httpd restart

  # wp-cli
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod 777 /tmp/wp-cli.phar
  cd /var/www/html
  sudo /tmp/wp-cli.phar config create --dbhost=${mysqlhost} --dbname=${mysqldb} --dbuser=${mysqluser} --dbpass=${mysqlpass}
  sudo /tmp/wp-cli.phar core install --url=${siteurl} --title=Terraform-Aws-Wordpress --admin_user=wp_admin --admin_email=wp_admin@admin.com
  sudo /tmp/wp-cli.phar post update 1 --post_title='Andrey Vsyakikh Terraform-AWS-Wordpress Example' --post_content="${wp_post}"



  sudo chown -R apache:apache /var/www/html/
  sudo chmod -R 755 /var/www/html/
fi
sudo service httpd restart

