#! /usr/bin/env python
# Builds blacklist from alternative source

# The UT1 Blacklist was too big and was causing the server to drag. Instead, we're going to load from a popular listing of adult sites.

import local
import sys

def search_list(lines):
    domains = []
    for line in lines:
        prefix = find_prefix(line)
        if prefix:
            no_prefix_line = line[prefix:]
            only_slash_line = no_prefix_line.replace('>', '/')
            line_parts = only_slash_line.split('/')
            domain = line_parts[0]
            if domain[:4] == "www.":
                domain = domain[4:]
            domains.append(domain)
    return domains

def find_prefix(line):
    prefix = "http://"
    prefix_start = line.find(prefix)
    if prefix_start >= 0:
        return prefix_start + 7
    return False

with open("trimmed_list.html", 'r') as file:
    lines = file.readlines()

    domains = search_list(lines)

    with open("small_adult.conf", 'w') as out:
        for domain in domains:
            if len(sys.argv) > 1 and sys.argv[1] == "hosts":
                out.write("127.0.0.1  " + domain + "\n")
            else:
                out.write("address=/." + domain + "/" + local.REDIRECT + "\n")
