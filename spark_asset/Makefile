SHELL=/bin/bash -x

all:
	sudo apt-get -y install openjdk-8-jdk
	mkdir -p /apps
	wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz -P downloads/
	sudo tar -xvzf downloads/spark-2.2.0-bin-hadoop2.7.tgz -C /apps
	sudo mv /apps/spark-2.2.0-bin-hadoop2.7 /apps/spark