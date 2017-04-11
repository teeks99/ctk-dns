ROUTER_IP=192.168.1.238

echo \# Python Settings for the local builder > local.py
echo REDIRECT=\"$ROUTER_IP\" >> local.py

mkdir -p ubiquity_config/dnsmasq.d

python make_from_list.py
mv small_adult.conf ubiquity_config/dnsmasq.d/
python make_from_reddit_list.py
mv reddit_adult.conf ubiquity_config/dnsmasq.d/
cp conf/safe_search.conf ubiquity_config/dnsmasq.d/

mkdir -p ubiquity_config/dns_html_root
cp conf/index.html ubiquity_config/dns_html_root/

mkdir -p ubiquity_config/lighttpd.conf
cfg=ubiquity_config/lighttpd.conf/dns_intercept.conf
echo "\$SERVER[\"socket\"] == \"$ROUTER_IP:80\" {" > $cfg
echo "    server.document-root = \"/var/www/dns_html_root\"" >> $cfg
echo "}" >> $cfg




