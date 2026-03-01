#!/bin/bash
set -euo pipefail

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y postgresql-client mysql-client
elif command -v dnf >/dev/null 2>&1; then
  dnf update -y
  dnf install -y postgresql mysql
elif command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y postgresql mysql
fi

echo "Bastion bootstrap completed at $(date)" >/etc/motd
