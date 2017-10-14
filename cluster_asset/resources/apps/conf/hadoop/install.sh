#!/usr/bin/env bash
set -e -x -o pipefail
# Download hadoop tarball
wget http://apache.claz.org/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz -P downloads/

# Extracting the tarball to /apps/hadoop folder
sudo tar -xvzf downloads/hadoop-2.8.1.tar.gz -C /apps
sudo mv /apps/hadoop-2.8.1 /apps/hadoop

# Cleanup the downloaded file
rm -rf downloads/hadoop-2.8.1.tar.gz

echo "Setting hadoop environment"
source /apps/conf/hadoop/hadoop.environment

# Copy hadoop config files to hadoop config folder
sudo cp /apps/conf/hadoop/core-site.xml $HADOOP_CONF_DIR/
sudo cp /apps/conf/hadoop/hdfs-site.xml $HADOOP_CONF_DIR/
sudo cp /apps/conf/hadoop/mapred-site.xml /$HADOOP_CONF_DIR/
sudo cp /apps/conf/hadoop/hadoop-env.sh /$HADOOP_CONF_DIR/