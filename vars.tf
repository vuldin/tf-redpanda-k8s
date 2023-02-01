variable "region" {}

variable "cluster_name" {
  type        = string
  description = "Cluster name; used for resource tags"
}

variable "load_balancer_source_ranges" {
  type        = list(string)
  description = "Load Balancer Source Ranges"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC base CIDR"
}

variable "zones" {
  type        = list(string)
  description = "List of availability zone ids. Ex: use1-az1"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnets CIDRs"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnets CIDRs"
}

variable "vpc_dns_support" {
  type        = bool
  default     = true
  description = "Whether DNS support is enabled for the VPC."
}

variable "vpc_dns_hostnames" {
  type        = bool
  default     = true
  description = "Whether DNS hostnames are created for the EC2 instances"
}

variable "create_cluster" {
  type        = bool
  default     = false
  description = "Whether to create the cluster (AWS-specific for now). If false, then the cluster at current-context in kubeconfig will be used"
}

variable "generate_load_balancer_config" {
  type        = bool
  default     = false
  description = "Whether to generate the load balancer config file"
}

variable "deploy_redpanda" {
  type        = bool
  description = "Whether to deploy Redpanda via helm"
}

variable "redpanda_helm_chart_repo" {
  type        = string
  description = "Helm chart repository"
}

variable "redpanda_helm_chart" {
  type        = string
  description = "Helm chart name or local path"
}

variable "redpanda_helm_values_path" {
  type        = string
  default     = "file_does_not_exist"
  description = "Location of custom Redpanda helm value.yaml"
}

variable "redpanda_helm_name" {
  type        = string
  description = "Release name for Redpanda"
}

variable "redpanda_namespace" {
  type        = string
  description = "Namespace for Redpanda"
}

variable "redpanda_create_namespace" {
  type        = bool
  description = "Whether to create the Redpanda namespace"
}

variable "deploy_prometheus" {
  type        = bool
  description = "Whether to deploy Prometheus via helm"
}

variable "prometheus_helm_chart_repo" {
  type        = string
  description = "Helm chart repository"
}

variable "prometheus_helm_chart" {
  type        = string
  description = "Helm chart name or local path"
}

variable "prometheus_helm_values_path" {
  type        = string
  default     = "file_does_not_exist"
  description = "Location of custom Prometheus helm value.yaml"
}

variable "prometheus_helm_name" {
  type        = string
  description = "Release name for Prometheus"
}

variable "prometheus_namespace" {
  type        = string
  description = "Namespace for Prometheus"
}

variable "prometheus_create_namespace" {
  type        = bool
  description = "Whether to create the Prometheus namespace"
}
variable "deploy_grafana" {
  type        = bool
  description = "Whether to deploy Grafana via helm"
}

variable "grafana_helm_chart_repo" {
  type        = string
  description = "Helm chart repository"
}

variable "grafana_helm_chart" {
  type        = string
  description = "Helm chart name or local path"
}

variable "grafana_helm_values_path" {
  type        = string
  default     = "file_does_not_exist"
  description = "Location of custom Grafana helm value.yaml"
}

variable "grafana_helm_name" {
  type        = string
  description = "Release name for Grafana"
}

variable "grafana_namespace" {
  type        = string
  description = "Namespace for Grafana"
}

variable "grafana_create_namespace" {
  type        = bool
  description = "Whether to create the Grafana namespace"
}
