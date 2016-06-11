#!/bin/bash
# This script will configure the system as a DNS filter

# Install dnsmasq DNS caching server and apach2 web server
sudo apt-get -y install dnsmasq apache2 dnsutils

# Automatically use the address that has the route out (test with google's DNS server)
listen_address=`ip route get 8.8.8.8 | head -1 | cut -d' ' -f8`

# Load the settings for dnsmasq
sed s/LISTEN_ADDRESS/$listen_address/g conf/dnsmasq_settings.conf > dnsmasq_settings.conf
sudo mv dnsmasq_settings.conf /etc/dnsmasq.d/

# Support google safe search
sudo cp conf/safe_search.conf /etc/dnsmasq.d/

# Set a landing page for intercepted queries
if [ -d "/var/www/html" ]; then
    sudo cp conf/index.html /var/www/html/
elif [ -d "/var/www" ]; then
    sudo cp conf/index.html /var/wwww/html/
fi

echo \# Python Settings for the local builder > local.py
echo REDIRECT=$listen_address >> local.py

script_dir=`pwd`
pushd /etc/dnsmasq.d/
ln -s $script_dir/adult/adult.conf .
popd

