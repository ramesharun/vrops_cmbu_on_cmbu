#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#set IS_SAAS environment true
mkdir -p /opt/vmware
touch /opt/vmware/deployed_on_saas.sh
chmod 755 /opt/vmware/deployed_on_saas.sh
echo "export IS_SAAS=true" >> /opt/vmware/deployed_on_saas.sh
cat /opt/vmware/deployed_on_saas.sh

# Set VAMI hostname
#/opt/vmware/share/vami/vami_set_hostname
