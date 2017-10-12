#!/bin/bash
set -e -x -o pipefail
# spark_standalone 0.0.1
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

    echo "Value of application: '$application'"
    echo "Value of app_input: '$app_input'"
    echo "Value of executors: '$executors'"

    # The following line(s) use the dx command-line tool to download your file
    # inputs to the local file system using variable names for the filenames. To
    # recover the original filenames, you can use the output of "dx describe
    # "$variable" --name".

    # Download the file as application in the home directory
    dx download "$application" -o application

    echo "Starting Apache Spark in Standalone Mode"
    export SPARK_HOME=/apps/spark
    export SPARK_MASTER_IP=localhost
    export SPARK_MASTER_PORT=7077
    export SPARK_MASTER_URL=spark://$SPARK_MASTER_IP:$SPARK_MASTER_PORT
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

    $SPARK_HOME/sbin/start-master.sh -h $SPARK_MASTER_IP -p $SPARK_MASTER_PORT
    $SPARK_HOME/sbin/start-slave.sh $SPARK_MASTER_URL

    $SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi --deploy-mode client --master $SPARK_MASTER_URL /home/dnanexus/application  10


    # Fill in your application code here.
    #
    # To report any recognized errors in the correct format in
    # $HOME/job_error.json and exit this script, you can use the
    # dx-jobutil-report-error utility as follows:
    #
    #   dx-jobutil-report-error "My error message"
    #
    # Note however that this entire bash script is executed with -e
    # when running in the cloud, so any line which returns a nonzero
    # exit code will prematurely exit the script; if no error was
    # reported in the job_error.json file, then the failure reason
    # will be AppInternalError with a generic error message.

}
