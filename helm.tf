resource "kubernetes_namespace" "redpanda" {
  count = var.deploy_redpanda && var.redpanda_create_namespace ? 1 : 0
  metadata {
    name = var.redpanda_namespace
  }
}

resource "helm_release" "redpanda" {
  count      = var.deploy_redpanda ? 1 : 0
  name       = var.redpanda_helm_name
  repository = "${var.redpanda_helm_chart_repo}"
  chart      = "${var.redpanda_helm_chart}"
  namespace  = var.redpanda_namespace

  values = fileexists(var.redpanda_helm_values_path) ? [
    file("${var.redpanda_helm_values_path}")
  ] : null

  depends_on = [
    kubernetes_namespace.redpanda,
  ]
}

resource "kubernetes_namespace" "prometheus" {
  count = var.deploy_prometheus && var.prometheus_create_namespace ? 1 : 0
  metadata {
    name = var.prometheus_namespace
  }

  #depends_on = [
  #  helm_release.redpanda,
  #]
}

resource "helm_release" "prometheus" {
  count      = var.deploy_prometheus ? 1 : 0
  name       = var.prometheus_helm_name
  repository = "${var.prometheus_helm_chart_repo}"
  chart      = "${var.prometheus_helm_chart}"
  namespace  = var.prometheus_namespace

  values = fileexists(var.prometheus_helm_values_path) ? [
    file("${var.prometheus_helm_values_path}")
  ] : null

  depends_on = [
    kubernetes_namespace.prometheus,
  ]
}

resource "kubernetes_namespace" "grafana" {
  count = var.deploy_grafana && var.grafana_create_namespace ? 1 : 0
  metadata {
    name = var.grafana_namespace
  }

  depends_on = [
    helm_release.prometheus,
  ]
}

resource "helm_release" "grafana" {
  count      = var.deploy_grafana ? 1 : 0
  name       = var.grafana_helm_name
  repository = "${var.grafana_helm_chart_repo}"
  chart      = "${var.grafana_helm_chart}"
  namespace  = var.grafana_namespace

  values = fileexists(var.grafana_helm_values_path) ? [
    file("${var.grafana_helm_values_path}")
  ] : null

  depends_on = [
    kubernetes_namespace.grafana,
  ]
}
