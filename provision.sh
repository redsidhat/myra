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
fi