#!/bin/bash

. $(dirname "${BASH_SOURCE[0]}")/util.sh

desc "Let's wait when 3 Galera nodes are up"
while [ $(kubectl get pods --namespace=demos -o=json \
  | jq '.items[] | select(.status.phase == "Running" )| .status.phase' \
  | grep -c Running) -lt 3 ]; do
    run "kubectl get pods --namespace=demos -o=json | jq '.items[] | select(.status.phase == \"Running\" and .status.conditions[1].status == \"True\") | .status.phase' | grep -c Running"
    sleep 10
done
desc "All nodes are up"

desc "Prepare benchmark"
run "$(dirname ${BASH_SOURCE[0]})/bench.sh -t prepare -d galera.demos.svc.cluster.local"

desc "Run benchmark"
run "$(dirname ${BASH_SOURCE[0]})/bench.sh -t run -d galera.demos.svc.cluster.local"

desc "Cleanup benchmark data"
run "$(dirname ${BASH_SOURCE[0]})/bench.sh -t cleanup -d galera.demos.svc.cluster.local"

desc "Let's scale up to 5 nodes"
run "kubectl patch petset mysql -p '{\"spec\":{\"replicas\":5}}' --namespace=demos"
while [ $(kubectl get pods --namespace=demos -o=json \
  | jq '.items[] | select(.status.phase == "Running" )| .status.phase' \
  | grep -c Running) -lt 5 ]; do
    run "kubectl get pods --namespace=demos -o=json | jq '.items[] | select(.status.phase == \"Running\" and .status.conditions[1].status == \"True\") | .status.phase' | grep -c Running"
    sleep 5
done
desc "All nodes are up"

desc "Prepare benchmark"
run "$(dirname ${BASH_SOURCE[0]})/bench.sh -t prepare -d galera.demos.svc.cluster.local"

desc "Run benchmark"
run "$(dirname ${BASH_SOURCE[0]})/bench.sh -t run -d galera.demos.svc.cluster.local"

desc "Cleanup benchmark data"
run "$(dirname ${BASH_SOURCE[0]})/bench.sh -t cleanup -d galera.demos.svc.cluster.local"

desc "Prepare benchmark"
run "$(dirname ${BASH_SOURCE[0]})/bench.sh -t prepare -d galera.demos.svc.cluster.local"

desc "Let's destroy random node"
run "kubectl delete pod mysql-$(( $RANDOM % 3 )) --namespace=demos"

desc "Run benchmark"
run "$(dirname ${BASH_SOURCE[0]})/bench.sh -t run -d galera.demos.svc.cluster.local"

desc "Cleanup benchmark data"
run "$(dirname ${BASH_SOURCE[0]})/bench.sh -t cleanup -d galera.demos.svc.cluster.local"

desc "Thank you"
