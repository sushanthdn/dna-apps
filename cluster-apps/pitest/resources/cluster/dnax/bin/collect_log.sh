#!/usr/bin/env bash

set -e -o

source /etc/profile.d/dnanexus.environment.sh
source /cluster/dx-cluster.environment
source /home/dnanexus/environment

DEST="/"
if [ "$#" -lt 1 ]; then
    echo "No project folder specified, logs will be copied to root"
else
    echo  "Creating folder $1 in project $DX_PROJECT_CONTEXT_ID"
    DEST="/$1/"
    dx mkdir -p $DX_PROJECT_CONTEXT_ID:$DEST
fi


echo  "Initiating log collection"
/cluster/log_collector.sh /home/dnanexus/logs/cluster_runtime_logs_tarball
echo  "Upload collected log to $DX_PROJECT_CONTEXT_ID:$DEST"
dx upload /home/dnanexus/logs/cluster_runtime_logs_tarball/* --destination=$DX_PROJECT_CONTEXT_ID:$DEST
echo  "Done."
