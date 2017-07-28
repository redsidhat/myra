# myra-django-environment



This tool project contains the following tools/technologies
  - shell script
  - terraform
  - ansible

#### why terraform?

  Terraform is a tool, more like a wrapper on the cloud. Terraform let you manage all the cloud resources through a bunch of json codes. This tool help you have a backup of the environment you built. Since this is JSON/HCL it has a greater inclenation towards automation. Terraform also provides a local state of the infrastructure. 
  
### Usage
``
bash provision.sh t2.micro 
``
There no count of the server is not handled since I was testing all these in my free account and I can't launch two servers at the same time. Again terraform makes it easy launch multiple servers by simply adding a "count" variable.