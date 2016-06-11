#!/bin/bash
# Updates to latest filter
mkdir -p downloads
wget ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/adult.tar.gz -O downloads/adult.tar.gz
tar -xf downloads/adult.tar.gz
python make_dnsmasq_conf.py adult/domains adult/adult.conf


sudo service dnsmasq restart
