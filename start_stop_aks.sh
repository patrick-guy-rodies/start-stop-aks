#!/bin/bash

cmd="$1"
cname="$2"

if [ -z "$cmd" ] || [ -z "$cname" ] 
then
      echo "You need to pass two arguments: first argument has to be start, stop or show and second argument has to be the cluster name to the script"
else
      echo "$cmd your AKS cluster for $cname in $SUB_ID_NP"
      az aks $cmd --name $cname --resource-group $RG_SANDBOX --subscription $SUB_ID_NP
fi

exit