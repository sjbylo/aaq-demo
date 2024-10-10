#!/bin/bash -e
# Test Application Aware Quotas DP feature. 3rd VM should fail to start!

# Create vms
n=rhel9-$RANDOM
oc process rhel9-server-tiny -n openshift -p NAME=$n | oc apply -f - -n demo-aaq
sleep 2
oc get vm $n -n demo-aaq
virtctl start $n -n demo-aaq
sleep 2

n=rhel9-$RANDOM
oc process rhel9-server-tiny -n openshift -p NAME=$n | oc apply -f - -n demo-aaq
sleep 2
oc get vm $n -n demo-aaq
virtctl start $n -n demo-aaq
sleep 2

n=rhel9-$RANDOM
oc process rhel9-server-tiny -n openshift -p NAME=$n | oc apply -f - -n demo-aaq
sleep 2
oc get vm $n -n demo-aaq
virtctl start $n -n demo-aaq
sleep 2

echo
oc get vm,vmi -n demo-aaq
echo
oc get ApplicationAwareResourceQuota demo-aaq -o yaml
