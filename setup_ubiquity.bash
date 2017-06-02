LANDING_IP=192.168.1.239

echo \# Python Settings for the local builder > local.py
echo REDIRECT=\"$LANDING_IP\" >> local.py

mkdir -p ubiquity_config/dnsmasq.d

python make_from_list.py
mv small_adult.conf ubiquity_config/dnsmasq.d/
python make_from_reddit_list.py
mv reddit_adult.conf ubiquity_config/dnsmasq.d/
cp conf/safe_search.conf ubiquity_config/dnsmasq.d/



