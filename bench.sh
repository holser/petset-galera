#!/bin/bash

usage() {
  echo "Usage $0 -d|--db-host dbhostname -t|--task {prepare|run|cleanup}"
  exit 1
}

while [[ $# -gt 1 ]]; do
  case $1 in
    -h|--help)
      usage
      ;;
    -d|--db-host)
      DBHOST=$2
      shift
      ;;
    -t|--task)
      TASK=$2
      shift
      ;;
    *)
      usage
      ;;
  esac
shift
done

if [ -z ${DBHOST} -o -z ${TASK} ]; then
  usage
fi

sysbench \
  --test=oltp \
  --mysql-db=test \
  --mysql-host="${DBHOST}" \
  --mysql-port=3306 \
  --mysql-table-engine=innodb \
  --oltp-test-mode=complex \
  --oltp-read-only=off \
  --oltp-table-size=20000000 \
  --max-requests=1000000 \
  --num-threads=16 \
  "${TASK}"
