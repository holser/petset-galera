#!/bin/bash

. $(dirname "${BASH_SOURCE[0]}")/util.sh

desc "Let's watch the status of pods"
run "kubectl get pods --namespace=demos --watch-only"
