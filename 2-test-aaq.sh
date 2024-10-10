#!/bin/bash -e
# Test Application Aware Quotas DP feature. 3rd VM should fail to start!

# Create vms
for i in 1 2 3
do
	n=rhel9-$i
	echo Creating VM $n ...
	oc process rhel9-server-tiny -n openshift -p NAME=$n | oc apply -f - -n demo-aaq
	oc -n demo-aaq patch vm $n --type=merge --patch '{"spec": {"running": true}}'
	sleep 1
	oc get vm $n -n demo-aaq
	#virtctl start $n -n demo-aaq
done

sleep 2

echo
oc get vm,vmi -n demo-aaq
echo
oc get ApplicationAwareResourceQuota demo-aaq -o yaml

echo "One of the 3 Vms will not start (READY = False)..."
sleep 15
oc get vm,vmi

