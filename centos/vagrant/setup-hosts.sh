#!/bin/bash

# Set up /etc/hosts so we can resolve all the machines in the VirtualBox network
set -ex

IFNAME=$1
THISHOST=$2
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
NETWORK=$(echo $ADDRESS | awk 'BEGIN {FS="."} ; { printf("%s.%s.%s", $1, $2, $3) }')
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

sed -e "/^.*$2.*/d" -i /etc/hosts

echo "${ADDRESS} ${HOSTNAME}" | tee /etc/hosts


# Expoert internal IP as an environment variable
echo "INTERNAL_IP=${ADDRESS}" >> /etc/environment

# Install wget
yum install wget -y

# Install git
yum install git -y

# Expose /usr/local/bin
echo export PATH=/usr/local/bin:$PATH >> /home/vagrant/.bashrc

