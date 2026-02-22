#!/bin/bash

echo "Setting up firewall rules using DOCKER-USER chain..."

# ensure the chain exists
iptables -N DOCKER-USER 2>/dev/null || true

# flush existing rules in DOCKER-USER to avoid duplicates
iptables -F DOCKER-USER

# Block access to private subnets
# iptables -I DOCKER-USER -d 192.168.0.0/16 -j DROP
# iptables -I DOCKER-USER -d 10.0.0.0/8 -j DROP
# iptables -I DOCKER-USER -d 172.16.0.0/12 -j DROP

# Ensure traffic can still go out to the internet
iptables -A DOCKER-USER -j RETURN

echo "Firewall rules applied successfully!"
