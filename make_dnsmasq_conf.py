import sys

import local

with open(sys.argv[1], "r") as domains:
    with open(sys.argv[2], "w") as conf:
        for domain in domains:
            domain_no_cr = domain[:-1]

            conf.write("address=/." + domain_no_cr + "/" +
                local.REDIRECT + "\n")

            # The cname option doesn't work with domains with a dot in front, 
            # so it only applies to the exact domain, instead of any
            # subdomains
            #conf.write("cname=." + domain_no_cr + "," + REDIRECT + "\n")

