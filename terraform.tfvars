# General
# If region is undefined, then the region in ~/.aws/config will be used
region                        = "eu-south-1"
zones                         = [ "eus1-az1", "eus1-az2", "eus1-az3"]

# Cluster
create_cluster                = false
# If create_cluster = false, your KUBECONFIG will be used instead of the cluster parameter values below
cluster_name                  = "redpanda"
vpc_cidr                      = "10.40.8.0/21"
private_subnet_cidrs          = [ "10.40.10.0/23" ,    "10.40.8.0/23", "10.40.12.0/23" ]
public_subnet_cidrs           = [ "10.40.14.0/25" , "10.40.14.128/25", "10.40.15.0/25" ]
vpc_dns_support               = true
vpc_dns_hostnames             = true

# Load balancer
generate_load_balancer_config = false
load_balancer_source_ranges   = [ "104.162.102.216/32" ]

# Redpanda
deploy_redpanda               = true
redpanda_helm_chart_repo      = "https://charts.redpanda.com/"
#redpanda_helm_chart           = "../../helm-charts/charts/redpanda"
redpanda_helm_chart           = "redpanda"
redpanda_helm_name            = "redpanda"
redpanda_namespace            = "redpanda"
redpanda_create_namespace     = true

# Prometheus
deploy_prometheus             = true
prometheus_helm_chart_repo    = "https://prometheus-community.github.io/helm-charts"
prometheus_helm_chart         = "prometheus"
prometheus_helm_values_path   = "./values-prometheus.yaml"
prometheus_helm_name          = "prometheus"
prometheus_namespace          = "prometheus"
prometheus_create_namespace   = true


# Grafana
deploy_grafana                = true
grafana_helm_chart_repo       = "https://grafana.github.io/helm-charts/"
grafana_helm_chart            = "grafana"
grafana_helm_values_path      = "./values-grafana.yaml"
grafana_helm_name             = "grafana"
grafana_namespace             = "grafana"
grafana_create_namespace      = true
