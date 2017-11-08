#!/usr/bin/env bash
set -e -x -o pipefail

echo "Setting hive environment"
source /apps/resources/hive/hive.environment

ln -s /usr/share/java/mysql-connector-java.jar /apps/hive/lib/mysql-connnector-java.jar
