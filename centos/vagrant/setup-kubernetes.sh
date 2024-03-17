{
# Configure Network Requirement for container runtime
cat <<EOF > /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system


# Configure and start containerD runtime
yum update -y
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install containerd.io -y
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd

KUBE_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | awk 'BEGIN { FS="." } { printf "%s.%s", $1, $2 }')

# Configure kubernetes repository

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/$KUBE_LATEST/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/$KUBE_LATEST/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF

# Install kubeadm, kubelet and kubectl

yum install -y kubeadm kubelet kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

systemctl start kubelet


# Disable SELinux to allow containers to access the host filesystem

setenforce 0

sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Disable SWAP

sed -i '/swap/d' /etc/fstab
swapoff -a


# Set container runtime for crictl
crictl config \
    --set runtime-endpoint=unix:///run/containerd/containerd.sock \
    --set image-endpoint=unix:///run/containerd/containerd.sock
}

