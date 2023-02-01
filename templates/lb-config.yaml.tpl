%{ for i, az in public_subnet_azs ~}
%{ if i > 0 ~}
---
%{ endif ~}
apiVersion: v1
kind: Service
metadata:
  name: lb-${cluster_name}-${i}
  namespace: redpanda
spec:
  type: LoadBalancer
  loadBalancerSourceRanges:
  ${ yamlencode(load_balancer_source_ranges) ~}
  ports:
  - name: schemaregistry
    targetPort: 8081
    port: 8081
  - name: http
    targetPort: 8082
    port: 8082
  - name: kafka
    targetPort: 9092
    port: 9092
  - name: admin
    targetPort: 9644
    port: 9644
  selector:
    statefulset.kubernetes.io/pod-name: ${cluster_name}-${i}
  externalTrafficPolicy: Local
%{ endfor ~}
