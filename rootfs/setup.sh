#!/bin/bash

echo "Setting up firewall rules using DOCKER-USER chain..."

# ensure the chain exists
iptables -N DOCKER-USER 2>/dev/null || true

# flush existing rules in DOCKER-USER to avoid duplicates
iptables -F DOCKER-USER

BLOCK_PRIVATE_SUBNETS="${FIREWALL_BLOCK_PRIVATE_SUBNETS:-false}"
BLOCK_SUBNETS="${FIREWALL_BLOCK_SUBNETS:-}"

# Optionally append RFC1918 private subnets.
# ,172.16.0.0/12 excluded because it used by docker
if [[ "${BLOCK_PRIVATE_SUBNETS,,}" == "true" ]]; then
  if [[ -n "$BLOCK_SUBNETS" ]]; then
    BLOCK_SUBNETS="${BLOCK_SUBNETS},"
  fi
  BLOCK_SUBNETS="${BLOCK_SUBNETS}192.168.0.0/16,10.0.0.0/8"
fi

IFS=',' read -r -a CIDR_LIST <<< "$BLOCK_SUBNETS"
for raw_cidr in "${CIDR_LIST[@]}"; do
  cidr="${raw_cidr#"${raw_cidr%%[![:space:]]*}"}"
  cidr="${cidr%"${cidr##*[![:space:]]}"}"

  if [[ -z "$cidr" ]]; then
    continue
  fi

  if [[ "$cidr" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/([0-9]|[12][0-9]|3[0-2])$ ]]; then
    iptables -I DOCKER-USER -d "$cidr" -j DROP
    echo "Blocked subnet: $cidr"
  else
    echo "Skipping invalid CIDR: $cidr"
  fi
done

# Ensure traffic can still go out to the internet
iptables -A DOCKER-USER -j RETURN

echo "Firewall rules applied successfully!"
