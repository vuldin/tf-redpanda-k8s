apiVersion: eksctl.io/v1alpha5
cloudWatch:
  clusterLogging: {}
iam:
  vpcResourceControllerPolicy: true
  withOIDC: false
kind: ClusterConfig
kubernetesNetworkConfig:
  ipFamily: IPv4
managedNodeGroups:
- amiFamily: AmazonLinux2
  desiredCapacity: 3
  disableIMDSv1: false
  disablePodIMDS: false
  iam:
    withAddonPolicies:
      albIngress: false
      appMesh: false
      appMeshPreview: false
      autoScaler: false
      awsLoadBalancerController: false
      certManager: false
      cloudWatch: false
      ebs: false
      efs: false
      externalDNS: false
      fsx: false
      imageBuilder: false
      xRay: false
  instanceSelector: {}
  instanceType: m5.xlarge
  labels:
    alpha.eksctl.io/cluster-name: ${cluster_name}
    alpha.eksctl.io/nodegroup-name: ${cluster_name}-workers
  maxSize: 4
  minSize: 3
  name: dlt-workers
  privateNetworking: true
  releaseVersion: ""
  securityGroups:
    withLocal: null
    withShared: null
  ssh:
    allow: false
    publicKeyPath: ""
  tags:
    alpha.eksctl.io/nodegroup-name: ${cluster_name}-workers
    alpha.eksctl.io/nodegroup-type: managed
  volumeIOPS: 3000
  volumeSize: 80
  volumeThroughput: 125
  volumeType: gp3
metadata:
  name: ${cluster_name}
  region: ${region}
  version: "1.23"
privateCluster:
  enabled: false
  skipEndpointCreation: false
vpc:
  clusterEndpoints:
    privateAccess: true
    publicAccess: true
  id: ${vpc_id}
  subnets:
    private:
%{ for i, az in private_subnet_azs ~}
      ${az}:
        id: ${private_subnet_ids[i]}
%{ endfor ~}
    public:
%{ for i, az in public_subnet_azs ~}
      ${az}:
        id: ${public_subnet_ids[i]}
%{ endfor ~}

