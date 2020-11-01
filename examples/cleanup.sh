#!/bin/bash

# Managed node group cluster
kubectx hmrc-managed

kubectl delete -f ./sa-roles/0-default-behaviour.yaml
kubectl delete -f ./sa-roles/1-sa-integrated-app.yaml

kubectl delete -f ./pdb/0-deployment-with-pdb.yaml

kubectl delete -f ./storage/0-default-provisioner.yaml
kubectl delete -f ./storage/3-new-storage-class.yaml
kubectl delete -f ./storage/4-sample-app.yaml

kubectl delete -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/alpha/?ref=master"


# Fargate cluster
kubectx hmrc-fargate

kubectl delete -f ./fargate/0-valid-pod.yaml
kubectl delete -f ./fargate/1-invalid-pod.yaml



# Delete EBS CSI KMS key
# Delete attached IAM policies (incline & S3)
# Increase node count to 3
# Fargate coredns annotation