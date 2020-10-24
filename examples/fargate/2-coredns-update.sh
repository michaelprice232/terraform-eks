#!/bin/bash

kubectl -n kube-system edit coredns

# remove 'compute-type' annotation from pod spec