# vagrant-virtualbox-centos-cluster
## 3 Node Kuberbetes Cluster configured with Centos


# Prerequisites
## VM Hardware Requirements

8 GB of RAM
50 GB Disk space

## Virtual Box

Download and Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) on any one of the supported platforms:

 - Windows hosts
 - OS X hosts (x86 only, not M1)
 - Linux distributions
 - Solaris hosts

This lab was last tested with VirtualBox 7.0.12, though newer versions should be ok.

## Vagrant

Once VirtualBox is installed you may chose to deploy virtual machines manually on it.
Vagrant provides an easier way to deploy multiple virtual machines on VirtualBox more consistently.

Download and Install [Vagrant](https://www.vagrantup.com/) on your platform.

- Windows
- Debian
- Centos
- Linux
- macOS (x86 only, not M1)

## Istio

If you want to use Istio to simplify observability, tarffic management, security and policy with a the leading service mesh.

  - $ vagrant ssh controller-node
  - $ sudo /vagrant/centos/vagrant/install-istio.sh  
