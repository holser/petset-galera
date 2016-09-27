#!/bin/bash

. $(dirname "${BASH_SOURCE}[0]")/util.sh

desc "Nuke it all"
run "kubectl delete namespace demos"
while kubectl get namespace demos >/dev/null 2>&1; do
  run "kubectl get namespace demos"
  sleep 5
done
run "kubectl get namespace demos"
run "kubectl get namespaces"
