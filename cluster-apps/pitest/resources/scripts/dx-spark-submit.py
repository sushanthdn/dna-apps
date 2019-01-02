import argparse

import json
import os.path
import sys
import logging
import subprocess

# List of cluster configuration files that can be customized
conf_files_supported = ["spark-default.conf"]
# Spark configurations that cannot be overridden by app developer or user
system_spark_confs = ["spark.driver.host",
                      "spark.driver.bindAddress",
                      "spark.driver.port",
                      "spark.driver.blockManager.port",
                      "spark.blockManager.port",
                      "spark.port.maxRetries",
                      "spark.master",
                      "spark.driver.extraClassPath",
                      "spark.jars",
                      "spark.hadoop.mapreduce.fileoutputcommitter.algorithm.version"]


def dx_spark_submit(spark_args, log_level, log_collect, log_upload_dir, app_config, user_config):
    validator = SparkConfigValidator(app_config, user_config)
    try:
        resolved_configs = validator.validate()
        job_status = spark_submit(spark_args=spark_args, log_level=log_level, conf=resolved_configs)
        logging.info("Spark submit exit status " + str(job_status))
        if log_collect:
            log_collection_status = collect_logs(log_upload_dir)
            logging.info("Log collection exit status " + str(log_collection_status))
        return job_status
    except SparkConfigValidatorException as e:
        error_msg = "Spark configuration validation error. " + e.message
        logging.error(error_msg)
        raise Exception(error_msg)


def spark_submit(spark_args, log_level, conf):
    if conf is None:
        conf = ""

    log_options = ""

    if log_level is not None:
        log_conf = "/cluster/dnax/config/log/log4j-" + log_level + ".properties"
        log_options = "--driver-java-options -Dlog4j.configuration=file:" + log_conf \
                      + " --conf spark.executor.extraJavaOptions=-Dlog4j.configuration=file:" + log_conf

    logging.debug("Config Options = [ {0} ]".format(conf))
    logging.debug("Spark Args = [ {0} ]".format(spark_args))
    logging.debug("Logging Options = [ {0} ]".format(log_options))

    exitcode = run_command(["/scripts/dx-spark-submitter.sh", log_options, conf, spark_args], "[SPARK]")
    return exitcode

def collect_logs(log_upload_dir):
    folder = ""
    if log_upload_dir is not None:
        folder = log_upload_dir
    exitcode = run_command(["/scripts/collect_log.sh", folder], "[COLLECT_LOGS]")
    return exitcode


def run_command(arguments, log_prefix=None):
    def log_subprocess_output(pipe, log_prefix=None):
        if log_prefix is None:
            log_prefix = ""
        for line in iter(pipe.readline, b''):  # b'\n'-separated lines
            print log_prefix + ' ' + line.rstrip()

    exitcode = 0
    try:
        logging.info("Submitting command ["+str(arguments)+"]")
        process = subprocess.Popen(arguments, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        with process.stdout:
            log_subprocess_output(process.stdout, log_prefix)
        exitcode = process.wait()

    except Exception as e:
        exitcode = 1
        logging.error("Failed to run command. " + e.message)

    return exitcode


# SparkConfigValidator validates the app developer or user configurations and resolves according the order or
# precedence. It also makes sure that the app or user is not overriding something that is restricted by the platform
class SparkConfigValidator:
    def __init__(self, app_config, user_config):
        self.app_config = app_config
        self.user_config = user_config

    def validate(self):
        if self.app_config is not None:
            appconf = self.get_json(self.app_config)
            self.validate_config_file(appconf)
            return self.generate_conf_options(appconf)
        return None

    @staticmethod
    def generate_conf_options(config_dict):
        spark_defaults = config_dict["spark-default.conf"]
        options = ""
        for spark_conf in spark_defaults:
            conf_options = " --conf \"{0}={1}\"".format(spark_conf["name"], spark_conf["value"])
            options = options + conf_options
        return options

    @staticmethod
    def validate_config_file(config_dict):
        for key in config_dict.keys():
            if key not in conf_files_supported:
                raise SparkConfigValidatorException("Updating config file " + key + " is not allowed")

    @staticmethod
    def get_json(data):
        if os.path.isfile(data):
            logging.info("Input " + data[0:20] + " is a file, getting contents from file")
            with open(data) as f:
                return json.load(f)

        try:
            logging.info("Input " + data[0:20] + " might be json string")
            return json.loads(data)
        except Exception:
            raise SparkConfigValidatorException(
                "Input \'" + data + "\' is invalid, should either be a json string or a "
                                    "file containing json")

    @staticmethod
    def check_supported_conf_files(conf_dict):
        print "Check for config files"


class DxSparkSubmitException(Exception):
    pass


class ValidationException(DxSparkSubmitException):
    pass


class SparkConfigValidatorException(DxSparkSubmitException):
    pass


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description="Dx Spark Submit Utility")
    parser.add_argument("--spark-args", help="Spark Submit Arguments")
    parser.add_argument("--log-level", choices=["INFO", "WARN", "TRACE", "DEBUG"],
                        help="Log level for driver and executor")
    parser.add_argument("--collect-logs", action="store_true", help="Collect logs to a project in the platform")
    parser.add_argument("--log-collect-dir", help="Directory in project to upload logs collected")
    parser.add_argument("--app-config", help="Application configuration json / file")
    parser.add_argument("--user-config", help="User configuration json / file")

    args = parser.parse_args()
    script_log_level = logging.INFO
    if args.log_level is not None and args.log_level == "DEBUG":
        script_log_level = logging.DEBUG
    # logging.basicConfig(format='%(asctime)s : [DX_SPARK_SUBMIT] %(levelname)s: %(message)s',
    #                     datefmt='%m/%d/%Y %I:%M:%S %p', level=script_log_level)
    logging.basicConfig(format='[DX_SPARK_SUBMIT] %(levelname)s: %(message)s', level=script_log_level)

    logging.info("Arguments :" + str(args))
    if args.spark_args is None:
        logging.error("--spark-args option is required")
        raise DxSparkSubmitException("--spark-args option is required")

    status = dx_spark_submit(args.spark_args, args.log_level, args.collect_logs, args.log_collect_dir, args.app_config,
                             args.user_config)
    # Exit with spark job status. Ignore log collection errors.
    sys.exit(status)
