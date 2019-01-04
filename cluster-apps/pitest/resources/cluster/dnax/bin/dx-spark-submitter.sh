#!/usr/bin/env bash

set -e -o -x

source /cluster/dx-cluster.environment
source /home/dnanexus/environment

echo "Spark Submitter Utility Arguments [ $@ ]"

$SPARK_HOME/bin/spark-submit $@