set -ex
echo "Instance $HOSTNAME"
if [[ "$HOSTNAME" = *controller* ]]
then
  POD_CIDR=192.168.0.0/16

  kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $INTERNAL_IP

  kubectl --kubeconfig /etc/kubernetes/admin.conf \
    create -f "https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml"

  kubectl --kubeconfig /etc/kubernetes/admin.conf \
    create -f "https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/custom-resources.yaml"

  mkdir -p /home/vagrant/.kube
  cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
  chown vagrant:vagrant /home/vagrant/.kube/config

  RESULT=`kubeadm token create --print-join-command`

  echo "$RESULT" > /home/vagrant/join-command.sh
fi

