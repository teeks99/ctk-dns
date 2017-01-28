#! /usr/bin/env python
# Builds blacklist from alternative source

# The UT1 Blacklist was too big and was causing the server to drag. Instead, we're going to load from a popular listing of adult sites.

# This list was found at:
# http://pasted.co/b2dc3032
# https://www.reddit.com/r/NoFap/comments/3l89jz/the_most_complete_list_of_porn_sites_to_block_in/

import local
import re

def search_list(lines):
    domains = []
    for line in lines:
        try:
            ip, domain = line.split()
            if domain[:4] == "www.":
                domain = domain[4:]
            check_valid(domain)
            domains.append(domain)
        except:
            print("Could not add: " + line)
    return domains

def check_valid(domain):
    pattern = r'[^\-\.a-z0-9]'
    if re.search(pattern, domain):
        raise ValueError

with open("reddit_list.txt", 'r') as file:
    lines = file.readlines()

    domains = search_list(lines)

    with open("reddit_adult.conf", 'w') as out:
        for domain in domains:
            out.write("address=/." + domain + "/" + local.REDIRECT + "\n")
