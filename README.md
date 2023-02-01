## Purpose

This project uses Terraform to deploy Redpanda and other tools into a Kubernetes cluster. You can choose to create the infrastructure, or make use of an existing cluster.

Modify `terraform.tfvars`

```
# general
region                        = "eu-south-1"
zones                         = [ "eus1-az1", "eus1-az2", "eus1-az3"]

# cluster
create_cluster                = false
cluster_name                  = "dlt"

# vpc
create_vpc                    = false
vpc_cidr                      = "10.40.8.0/21"
private_subnet_cidrs          = [ "10.40.10.0/23" ,    "10.40.8.0/23", "10.40.12.0/23" ]
public_subnet_cidrs           = [ "10.40.14.0/25" , "10.40.14.128/25", "10.40.15.0/25" ]
vpc_dns_support               = true
vpc_dns_hostnames             = true

# load balancer
generate_load_balancer_config = false
load_balancer_source_ranges   = [ "104.162.102.216/32" ]

```

Run terraform

This will create the network, as well as two configuration files for EKS and for configuring the load balancer.

```
terraform init
terraform apply
```

Create the EKS cluster

```
eksctl create cluster -f eks-config.yaml
```

Create the namespace and load balancer

```
kubectl create ns redpanda
kubectl apply -f lb-config.yaml
```


Start to deploy Redpanda...
