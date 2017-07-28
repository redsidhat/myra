#!/bin/bash
#checking machine type
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN"
esac
if [ $machine == 'UNKNOWN' ]; then
	echo "Unknown machine type. Exiting"
	exit 1
fi
echo "Checking if terraform is present"
if [ ! -f terraform ]; then
    echo "Terraform is not present downloading."
    if [ $machine == 'Linux' ]; then
    	curl -o terraform.zip https://releases.hashicorp.com/terraform/0.9.11/terraform_0.9.11_linux_amd64.zip
    elif [ $machine == 'Mac' ]; then
    	curl -o terraform.zip https://releases.hashicorp.com/terraform/0.9.11/terraform_0.9.11_darwin_amd64.zip
    fi
    unzip terraform.zip
    if [ $? -ne 0 ]; then
    	print "unzip failed"
    	exit 1
    fi
    chmod +x terraform
    if [ -f terraform ]; then
    	echo "terraform downloaded"
    fi
    echo "cleaning up"
    rm -rf terraform.zip
else
	echo "Terraform is present; proceeding"
fi
echo "Checking if the keypair exist in the directory"
if [ ! -f keyfile ] || [ ! -f keyfile.pub ]; then
	echo "Keypair not present. Generating new keypair"
	ssh-keygen -b 2048 -t rsa -f ./keyfile -q -N ""
    if [ $? -ne 0 ]; then
    	print "keyfile generation failed"
    	exit 1
    fi
else
	echo "Keypair found; proceeding"
fi
PUB_KEY=`cat keyfile.pub`
echo "Updating terraform keypair class with new public key"
REPLACE="  public_key = \\\"$PUB_KEY\\\""
#Following line does a simple sed replace in keypair.tf. 
#Did not use direct file replacement to ensure compatibility on linux and BSD based OSs
cd terraform_code
echo `cat keypair.tf |sed -e "s|.*public_key.*|$REPLACE|g" > keypair.tf.bk && mv keypair.tf.bk keypair.tf`
echo "Running terraform plan"
../terraform plan