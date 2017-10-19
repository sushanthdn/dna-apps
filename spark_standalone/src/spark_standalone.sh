#!/bin/bash
set -e -x -o pipefail
# spark_standalone 0.0.1
# Create a spark standalone cluster with a number of worker nodes
# and run your spark application
#
# See https://wiki.dnanexus.com/Developer-Portal for tutorials on how
# to modify this file.

main() {

    echo "Value of application: '$application'"
    echo "Value of app_input: '$app_args'"
    echo "Value of executors: '$workers'"
    echo "Value of cores: '$cores'"
    echo "Value of executor_memory: '$executor_memory'"
    echo "Value of class: '$class'"
    echo "Value of in: '$in_files'"

    # The following line(s) use the dx command-line tool to download your file
    # inputs to the local file system using variable names for the filenames. To
    # recover the original filenames, you can use the output of "dx describe
    # "$variable" --name".

    # Download all input files
    dx-download-all-inputs --parallel

    echo "Starting Apache Spark in Standalone Mode"
    export SPARK_WORKER_INSTANCES=$workers

    source /apps/resources/spark/spark.environment
    /apps/resources/spark/setup/setup-standalone.sh

    $SPARK_HOME/bin/spark-submit --class $class \
    --executor-cores $cores \
    --executor-memory $executor_memory \
    --master $SPARK_MASTER_URL \
    $application_path $app_args

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

    # Upload outputs
    dx-upload-all-outputs --parallel

}
