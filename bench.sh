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
  --db-driver=mysql \
  --mysql-db=test \
  --mysql-host="${DBHOST}" \
  --mysql-port=3306 \
  --mysql-table-engine=innodb \
  --oltp-test-mode=complex \
  --oltp-read-only=off \
  --oltp-table-size=200000 \
  --oltp-auto-inc=off \
  --max-requests=10000 \
  --db-ps-mode=disable \
  --num-threads=16 \
  "${TASK}"
