#!/bin/bash
# metastore_test 0.0.1
# Generated by dx-app-wizard.
#
# Basic execution pattern: Your app will run on a single machine from
# beginning to end.
#
# Your job's input variables (if any) will be loaded as environment
# variables before this script runs.  Any array inputs will be loaded
# as bash arrays.
#
# Any code outside of main() (or any entry point you may add) is
# ALWAYS executed, followed by running the entry point itself.
#
# See https://wiki.dnanexus.com/Developer-Portal for tutorials on how
# to modify this file.

main() {

    echo "Value of query: '$query'"
    echo "Value of uri: '$uri"

    sed -i -e 's,@@METASTORE_URI@@,'"$uri"',g' /scripts/hive-site.xml

    cp /scripts/hive-site.xml /cluster/spark/conf/

    cat /home/dnanexus/environment
    source /cluster/dx-cluster.environment

    $SPARK_HOME/bin/spark-submit /scripts/metastore_test.py "'$query'"

}