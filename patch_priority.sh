#!/bin/bash

kubectl patch statefulset pan-mgmt-sts -n cn-series --patch '{"spec": {"template": {"spec": {"priorityClassName":"pan-node-critical-priority"}}}}'

kubectl patch ds pan-cni -n cn-series --patch '{"spec": {"template": {"spec": {"priorityClassName":"pan-node-critical-priority"}}}}'


kubectl patch ds pan-ngfw-ds -n cn-series --patch '{"spec": {"template": {"spec": {"priorityClassName":"pan-cluster-critical-priority"}}}}'
