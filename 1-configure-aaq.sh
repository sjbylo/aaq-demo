#!/bin/bash
# Configure Application Aware Quotas DP feature

oc apply -f - <<END
apiVersion: v1
kind: Namespace
metadata:
  name: demo-aaq
  labels:
    application-aware-quota/enable-gating: "true"
END

patch_yaml=$(cat <<EOF
spec:
  applicationAwareConfig:
    allowApplicationAwareClusterResourceQuota: false
    vmiCalcConfigName: VirtualResources    
  featureGates:
    enableApplicationAwareQuota: true 
EOF
)

oc -n openshift-cnv patch hyperconverged kubevirt-hyperconverged --type=merge --patch "$patch_yaml"

oc rollout status deployment -n openshift-cnv aaq-controller
oc rollout status deployment -n openshift-cnv aaq-operator
oc rollout status deployment -n openshift-cnv aaq-server

oc apply -f - <<END
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

sleep 1

oc get ApplicationAwareResourceQuota demo-aaq -o yaml

exit 0

spec:
  applicationAwareConfig:
    allowApplicationAwareClusterResourceQuota: false
    namespaceSelector:
      matchExpressions:
        - key: name
          operator: In
          values:
            - <NAMESPACE1>
            - <NAMESPACE2>
    vmiCalcConfigName: VirtualResources    
  featureGates:
    enableApplicationAwareQuota: true 
