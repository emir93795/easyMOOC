#!/bin/bash
#canvasInstallV2. ATT!! This will only work in Amazon Linux AMI 2014.09.1 (HVM). 
#IT IS NOT COMPLETELY AUTOMATED BY NOW.

yum update -y

yum install -y gcc zlib-devel mysql-devel httpd openssl-devel gcc-c++ curl-devel
yum install -y httpd-devel apr-util-devel libxml2-devel libsxlt-devel postgresql-devel libxslt-devel sqlite-devel
yum install -y mod_ssl

yum install -y libyaml libyaml-devel

yum install -y git
yum install -y rubygems

gem install rails

gem install passenger -f
yum install -y ruby-devel
curl -sL https://rpm.nodesource.com/setup | bash -
yum install -y nodejs

passenger-install-apache2-module -a
echo 'LoadModule passenger_module /home/ec2-user/.gem/ruby/2.0/gems/passenger-4.0.53/buildout/apache2/mod_passenger.so' >> /etc/httpd/conf/httpd.conf
echo '   <IfModule mod_passenger.c>' >> /etc/httpd/conf/httpd.conf
echo '     PassengerRoot /home/ec2-user/.gem/ruby/2.0/gems/passenger-4.0.53' >> /etc/httpd/conf/httpd.conf
echo '     PassengerDefaultRuby /usr/bin/ruby2.0' >> /etc/httpd/conf/httpd.conf
echo '   </IfModule>' >> /etc/httpd/conf/httpd.conf


rpm -Uvh --force http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-redhat93-9.3-1.noarch.rpm
yum install -y postgresql93-server postgresql93
sudo /etc/init.d/postgresql93 initdb
chkconfig postgresql93 on
sed -i 's/peer/trust/' /var/lib/pgsql93/data/pg_hba.conf
sed -i 's/iden/trust/' /var/lib/pgsql93/data/pg_hba.conf
service postgresql93 start
psql -U postgres < CanvasDatabaseCreation.sql


#Canvas git cloning
git clone http://github.com/instructure/canvas-lms.git canvas
mkdir /var/www/canvas
mkdir /var/www/gems
cd canvas
cp -av * /var/www/canvas
cd /var/www/canvas
gem uninstall bundler -v 1.7.4
gem install bundler -v 1.6.0
yum install -y /usr/include/libpq-fe.h
gem install execjs

chown -R ec2-user /var/www/canvas
bundle update
bundle install

cd config
cp /var/www/canvas/config/security.yml.example /var/www/canvas/config/security.yml
cp /var/www/canvas/config/database.yml.example /var/www/canvas/config/database.yml
cp /var/www/canvas/config/amazon_s3.yml.example /var/www/canvas/config/amazon_s3.yml 
cp /var/www/canvas/config/delayed_jobs.yml.example /var/www/canvas/config/delayed_jobs.yml 
cp /var/www/canvas/config/domain.yml.example /var/www/canvas/config/domain.yml 
cp /var/www/canvas/config/file_store.yml.example /var/www/canvas/config/file_store.yml 
cp /var/www/canvas/config/outgoing_mail.yml.example /var/www/canvas/config/outgoing_mail.yml
sed -i 's/your_password/canvas/' config/database.yml

#database population. Pendent AUTOMATITZAR, tema mail, password i nom usuari.
RAILS_ENV=production bundle exec rake db:initial_setup


#nodejs modules installation
npm install compute-cluster
npm install glob
npm install mkdirp
npm install node-sass
npm install js-yaml
npm install lodash
npm install autoprefixer
npm install

#file generation
bundle exec rake canvas:compile_assets

echo '<VirtualHost *:80>
      ServerName 54.94.164.45
      DocumentRoot /var/www/canvas/public
      <Directory /var/www/canvas/public>
         # This relaxes Apache security settings.
         AllowOverride all
         # MultiViews must be turned off.
         Options -MultiViews
         #Require all granted
      </Directory>
   </VirtualHost>' /etc/httpd/conf/httpd.conf
