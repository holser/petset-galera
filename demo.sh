#!/bin/bash

. $(dirname "${BASH_SOURCE[0]}")/util.sh

desc "A small demo of Galera Cluster based on PetSet"

desc "There are no PV volumes yet. Let's check it out"
run "kubectl get pv"

desc "Create PVs"
run "cat pv.yaml"
run "kubectl create -f $(relative pv.yaml)"

desc "Check them out"
run "kubectl get pv"

desc "Let's create svc for for Galera Cluster"
run "cat svc.yaml"
run "kubectl --namespace=demos create -f $(relative svc.yaml)"
run "kubectl --namespace=demos get svc"

desc "Let's create petset for Galera Cluster"
run "cat mysql-galera.yaml"
run "kubectl --namespace=demos create -f $(relative mysql-galera.yaml)"

desc "Let's check petset"
run "kubectl --namespace=demos get petset"

desc "Let's wait until one pod is up"
while kubectl get pods --namespace=demos -o=json \
  | jq '.items[] | select(.status.phase == "Running")| .status.phase' \
  | grep -q Running; do
    desc "Waiting"
    sleep 5
done

tmux new -s my-session -d \
    "$(dirname ${BASH_SOURCE[0]})/split1_scale.sh" \; \
    split-window -h -d "$(dirname ${BASH_SOURCE[0]})/split1_pod.sh" \; \
    attach \;
