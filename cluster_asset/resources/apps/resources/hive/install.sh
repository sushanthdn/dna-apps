#!/usr/bin/env bash
set -e -x -o pipefail
# Download hive tarball
wget http://apache.claz.org/hive/hive-2.3.1/apache-hive-2.3.1-bin.tar.gz -P downloads/

# Extracting the tarball to /apps/hive folder
sudo tar -xvzf downloads/apache-hive-2.3.1-bin.tar.gz -C /apps
sudo mv /apps/apache-hive-2.3.1-bin /apps/hive

# Cleanup the downloaded file
rm -rf downloads/apache-hive-2.3.1-bin.tar.gz

echo "Setting hive environment"
source /apps/resources/hive/hive.environment

echo "Install mysql connector"
sudo apt-get install libmysql-java
