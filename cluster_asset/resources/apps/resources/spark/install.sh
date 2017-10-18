#!/usr/bin/env bash
set -e -x -o pipefail
# Download spark tarball
wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz -P downloads/

# Extracting the tarball to /apps/spark folder
sudo tar -xvzf downloads/spark-2.2.0-bin-hadoop2.7.tgz -C /apps
sudo mv /apps/spark-2.2.0-bin-hadoop2.7 /apps/spark

# Cleanup the downloaded file
rm -rf downloads/spark-2.2.0-bin-hadoop2.7.tgz

echo "Setting spark environment"
source /apps/resources/spark/spark.environment

# Create spark log folder
sudo mkdir -p $SPARK_LOG_DIR
# Create spark work folder
sudo mkdir -p $SPARK_WORK_DIR