# ctk-dns
Filtering DNS For Christ the King

This is a set of secripts that will setup DNS filtering for the Christ the King school in University City, MO. The general idea is to use the free blacklist of adult sites from the [UT1 Blacklist Site](http://dsi.ut-capitole.fr/blacklists/index_en.php). Specifically the [adult](ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/adult.tar.gz) one from their FTP server.

The `setup_onetime.bash` script will install the [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) DNS caching server and add a config file routing all those hosts back to this server. It will then install a web server ([apache2](https://httpd.apache.org/)) and a landing page that individuals will see. It also sets up a configation file to point queries to google.com (and other google domains) through google's [safe search](https://support.google.com/websearch/answer/186669?hl=en) domain instead. Finally, it will make a symlink to the config file that is created each time the update script is run.

The `update.bash` script will download the latest version of the blacklist and convert it to the format used by dnsmasq.  This can be run from a cron job, possibly monthly.

Once this is setup, the DHCP server that serves DNS can be set to point to this machine. To enable this, the machine should have a static address set, including its own DNS addresss. The dnsmasq server config has google's dns servers hard-coded into it, but if the network dns settings are used it will become cirricular and possibly have difficulting performing updates.


