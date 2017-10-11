#!/usr/bin/env bash
set -e -x -o pipefail

echo "Install Java"
sudo apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y --no-install-recommends --no-install-suggests numactl openjdk-8-jre-headless linux-tools-common linux-tools-generic
java -version
ls -ail /etc/alternatives/java

echo "Installing Apache Spark"
mkdir -p downloads
wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz -P downloads/spark
sudo mkdir -p /apps
sudo tar -xvzf downloads/spark/spark-2.2.0-bin-hadoop2.7.tgz -C /apps && sudo mv /apps/spark-2.2.0-bin-hadoop2.7 /apps/spark

echo "Starting Apache Spark in Standalone Mode"
export SPARK_HOME=/apps/spark
export SPARK_MASTER_IP=localhost
export SPARK_MASTER_PORT=7077
export SPARK_MASTER_URL=spark://$SPARK_MASTER_IP:$SPARK_MASTER_PORT
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

$SPARK_HOME/sbin/start-master.sh -h $SPARK_MASTER_IP -p $SPARK_MASTER_PORT
$SPARK_HOME/sbin/start-slave.sh $SPARK_MASTER_URL

$SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi --deploy-mode client --master $SPARK_MASTER_URL $SPARK_HOME/examples/jars/spark-examples_2.11-2.2.0.jar 10