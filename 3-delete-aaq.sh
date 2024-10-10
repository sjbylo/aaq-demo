#!/bin/bash -e
# Delete Application Aware Quotas DP feature

oc delete -f - <<END
apiVersion: v1
kind: Namespace
metadata:
  name: demo-aaq
END

oc delete -f - <<END
apiVersion: aaq.kubevirt.io/v1alpha1
kind: ApplicationAwareResourceQuota
metadata:
  name: demo-aaq
  namespace: demo-aaq
spec:
  hard:
    limits.cpu: "2" 
    limits.memory: 10Gi
END

##oc -n demo-aaq delete vm,vmi --all

#patch_yaml=$(cat <<EOF
#spec:
#  applicationAwareConfig:
#    allowApplicationAwareClusterResourceQuota: false
#    vmiCalcConfigName: VirtualResources    
#  featureGates:
#    enableApplicationAwareQuota: true 
#EOF
#)

#kubectl patch <resource> <resource-name> --type=merge -p '{"spec": {"fieldToRemove": null}}'

oc -n openshift-cnv patch hyperconverged kubevirt-hyperconverged --type=merge --patch '{"spec": {"applicationAwareConfig": null}}'
oc -n openshift-cnv patch hyperconverged kubevirt-hyperconverged --type=merge --patch '{"spec": {"featureGates": {"enableApplicationAwareQuota": null}}}'
###oc -n openshift-cnv patch hyperconverged kubevirt-hyperconverged --type=merge --patch "$patch_yaml"

