#!/usr/bin/env bash
echo "Installing Apache Spark"
wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
tar -xvzf spark-2.2.0-bin-hadoop2.7.tgz
sudo mkdir -p /spark
sudo mv spark-2.2.0-bin-hadoop2.7/ /spark
ls -ail /spark