import sys

REDIRECT="interceptor"

with open(sys.argv[1], "r") as domains:
    with open(sys.argv[2], "w") as conf:
        for domain in domains:
            domain_no_cr = domain[:-1]
            #conf.write("address=/." + domain_no_cr + "/" + REDIRECT + "\n")
            conf.write("cname=." + domain_no_cr + "," + REDIRECT + "\n")

