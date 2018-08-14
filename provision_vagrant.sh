#!/bin/bash

sudo su

yum update -y

yum install epel-release -y

yum install ansible -y

yum install python-pip -y

yum install cowsay -y

pip install --upgrade pip

python -m pip --version

pip install ansible[azure]

rpm --import https://packages.microsoft.com/keys/microsoft.asc

sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

yum install gcc gcc-c++ -y

yum install python-devel -y

yum install azure-cli -y

yum update azure-cli -y

yes | pip uninstall pyOpenSSL cryptography

pip install pyOpenSSL cryptography

pip install azure

mkdir ~/.azure

mv sync/.credentials ~/.azure/credentials

rm -rf sync/.credentials

pip install "pywinrm>=0.3.0"

pip install azure-common --upgrade

pip install msrestazure --upgrade

yum install wget unzip -y

cd sync/

wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip

unzip terraform*

#rm -f terraform_*

echo "export PATH=\"\$PATH:/home/vagrant/sync\"" >> /home/vagrant/.bashrc

cd /usr/bin

ln -s /home/vagrant/sync/terraform terraform

cd /home/vagrant/sync/

source /home/vagrant/.bashrc
