#!/usr/bin/env bash
#sudo add-apt-repository -y ppa:webupd8team/java
#sudo apt-get update
#sudo apt-get install -y oracle-java8-installer

sudo apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y --no-install-recommends --no-install-suggests numactl openjdk-8-jre-headless linux-tools-common linux-tools-generic
java -version