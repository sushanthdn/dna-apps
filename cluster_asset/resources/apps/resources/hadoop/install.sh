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
source /apps/resources/hadoop/hadoop.environment

# Copy hadoop config files to hadoop config folder
sudo cp /apps/resources/hadoop/custom/core-site.xml $HADOOP_CONF_DIR/
sudo cp /apps/resources/hadoop/custom/hdfs-site.xml $HADOOP_CONF_DIR/
sudo cp /apps/resources/hadoop/custom/mapred-site.xml /$HADOOP_CONF_DIR/
sudo cp /apps/resources/hadoop/custom/hadoop-env.sh /$HADOOP_CONF_DIR/

# Create hadoop log folder
sudo mkdir -p $HADOOP_LOG_DIR
sudo chmod -R 766 $HADOOP_LOG_DIR
