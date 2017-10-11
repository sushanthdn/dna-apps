SHELL=/bin/bash -x

all:
	sudo apt-get -y install openjdk-8-jdk
	wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz -P downloads/
	mkdir spark
	sudo tar -xvzf downloads/spark-2.2.0-bin-hadoop2.7.tgz -C spark