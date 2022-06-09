#!/bin/bash
set -xe

DEBIAN_FRONTEND=noninteractive

db_username="${db_username}"
db_password="${db_password}"
db_name="${db_name}"
db_host="${db_host}"

# install LAMP Server
sudo apt update  -y
sudo apt upgrade -y

apt install -y apache2 wget mysql-common libapache2-mod-php
apt install -y php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,bcmath,json,xml,intl,zip,imap,imagick}

systemctl enable --now apache2

# Change OWNER and permission of directory /var/www
useradd apache
usermod -a -G www-data apache
chown -R apache:www-data /var/www

find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Download wordpress package and extract
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

# Create wordpress configuration file and update database value
cd /var/www/html
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_username/g" wp-config.php
sed -i "s/password_here/$db_password/g" wp-config.php
sed -i "s/localhost/$db_host/g" wp-config.php

cat <<EOF >>/var/www/html/wp-config.php

define('FS_METHOD', 'direct');
define('WP_MEMORY_LIMIT', '256M');
EOF

cat <<EOF >>/var/www/html/wp-content/themes/twentytwentytwo/parts/footer.html
<h1>From instance ${team}/${instance}</h1>
EOF

# Change permission of /var/www/html/
chown -R apache:www-data /var/www/html
chmod -R 774 /var/www/html
rm /var/www/html/index.html

#  enable .htaccess files in Apache config using sed command
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf

# restart apache
systemctl restart apache2
