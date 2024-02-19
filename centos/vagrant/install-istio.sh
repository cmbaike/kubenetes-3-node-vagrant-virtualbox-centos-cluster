set -ex
ISTIO_VERSION=1.20.3

echo "Instance $HOSTNAME"
if [[ "$HOSTNAME" = *controller* ]]
then

 wget -P /tmp https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz

 tar -xvf /tmp/istio-${ISTIO_VERSION}-linux-amd64.tar.gz -C /tmp

 mv /tmp/istio-${ISTIO_VERSION} /opt

 chown -R vagrant:vagrant /opt/istio-1.20.3

 echo export PATH=/opt/istio-${ISTIO_VERSION}/bin:$PATH >> ~/.bashrc

 source ~/.bashrc

 istioctl install --kubeconfig /etc/kubernetes/admin.conf -y

 # Configure automatic Envoy proxy injection
 kubectl label namespace default istio-injection=enabled --kubeconfig /etc/kubernetes/admin.conf

fi