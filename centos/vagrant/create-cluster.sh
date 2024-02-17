set -ex
echo "Instance $HOSTNAME"
if [[ "$HOSTNAME" = *controller* ]]
then
  POD_CIDR=10.244.0.0/16
  SERVICE_CIDR=10.96.0.0/16

  kubeadm init --pod-network-cidr $POD_CIDR --service-cidr $SERVICE_CIDR --apiserver-advertise-address $INTERNAL_IP

  kubectl --kubeconfig /etc/kubernetes/admin.conf \
    apply -f "https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s-1.11.yaml"

  mkdir -p /home/vagrant/.kube
  cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
  chown vagrant:vagrant /home/vagrant/.kube/config

  RESULT=`kubeadm token create --print-join-command`

  echo "$RESULT" > /home/vagrant/join-command.sh
fi

