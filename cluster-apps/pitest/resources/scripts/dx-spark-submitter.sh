#!/usr/bin/env bash

set -e -o -x

source /cluster/dx-cluster.environment
source /home/dnanexus/environment

#export SPARK_HOME=/Users/sreddy/dev/spark240

#$SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples_2.11-2.4.0.jar

$SPARK_HOME/bin/spark-submit $@