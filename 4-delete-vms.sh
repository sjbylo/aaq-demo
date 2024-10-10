#!/bin/bash -e
# Delete Application Aware Quotas DP feature

oc delete vm,vmi --all -n demo-aaq
