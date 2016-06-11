#!/bin/bash
# This script will configure the system as a DNS filter

# Install dnsmasq DNS caching server and apach2 web server
sudo apt-get -y install dnsmasq apache2

# Load the settings for dnsmasq
sudo cp conf/dnsmasq_settings.conf /etc/dnsmasq.d/

# Support google safe search
sudo cp conf/safe_search.conf /etc/dnsmasq.d/

# Set a landing page for intercepted queries
sudo cp conf/index.html /var/www/html/

# Set a line in the hosts file to handle intercepted queries, pointed to the public IP of this computer
sudo echo \# The following is the line that sets where rejected DNS queries should go >> /etc/hosts
sudo echo `ip route get 8.8.8.8 | head -1 | cut -d' ' -f8`      interceptor >> /etc/hosts

script_dir=`pwd`
pushd /etc/dnsmasq.d/
ln -s $script_dir/adult/adult.conf .
popd

