#!/bin/bash

kubectl create priorityclass pan-node-critical-priority --value=1000000000  --description="This priority class should be used for pan-cni and pan-mgmt pods only"

kubectl create priorityclass pan-cluster-critical-priority --value=999999999   --description="This priority class should be used for pan-ngfw pods only"
