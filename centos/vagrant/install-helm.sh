set -ex

wget -P /tmp https://get.helm.sh/helm-v3.14.1-linux-amd64.tar.gz
tar -xvf /tmp/helm-v3.14.1-linux-amd64.tar.gz -C /tmp

mv /tmp/linux-amd64/helm /usr/local/bin/helm
