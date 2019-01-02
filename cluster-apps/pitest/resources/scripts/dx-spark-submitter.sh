#!/usr/bin/env bash

set -e -o -x

source /cluster/dx-cluster.environment
source /home/dnanexus/environment

echo "Submitting spark job with arguments $@"

$SPARK_HOME/bin/spark-submit $@