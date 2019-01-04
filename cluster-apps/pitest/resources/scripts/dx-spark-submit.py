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
    try:
        resolved_configs = resolve_config(app_config, user_config)
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
        driver_log_opts = "--driver-java-options -Dlog4j.configuration=file:" + log_conf
        executor_log_opts = " --conf spark.executor.extraJavaOptions=-Dlog4j.configuration=file:" + log_conf
        # log_options = "--driver-java-options -Dlog4j.configuration=file:" + log_conf \
        #               + " --conf spark.executor.extraJavaOptions=-Dlog4j.configuration=file:" + log_conf

    logging.debug("Config Options  = [ {0} ]".format(conf))
    logging.debug("Spark Args      = [ {0} ]".format(spark_args))
    logging.debug("Driver Logging Options = [ {0} ]".format(driver_log_opts))
    logging.debug("Executor Logging Options = [ {0} ]".format(executor_log_opts))

    exitcode = run_command(["/scripts/dx-spark-submitter.sh", driver_log_opts, executor_log_opts, conf, spark_args],
                           "[SPARK]")
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
        logging.info("Submitting command [" + str(arguments) + "]")
        process = subprocess.Popen(arguments, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        with process.stdout:
            log_subprocess_output(process.stdout, log_prefix)
        exitcode = process.wait()

    except Exception as e:
        exitcode = 1
        logging.error("Failed to run command. " + e.message)

    return exitcode


def resolve_config(app_config_file=None, user_config_file=None):
    spark_config_util = SparkConfigUtil()
    app_config_dict, user_config_dict = None, None
    if app_config_file is not None:
        app_config_dict = spark_config_util.get_config_dict(app_config_file)
        logging.debug("Application Configuration : " + str(app_config_dict))
    if user_config_file is not None:
        user_config_dict = spark_config_util.get_config_dict(user_config_file)
        logging.debug("User Configuration : " + str(user_config_dict))
    return spark_config_util.generate_conf_options(app_config_dict, user_config_dict)


class SparkConfigUtil:
    def __init__(self):
        pass

    def get_config_dict(self, config_file):
        config_dict = self.json_file_to_dict(config_file)
        self.check_system_override(config_dict)
        return config_dict

    @staticmethod
    def generate_conf_options(app_config_dict=None, user_config_dict=None):

        spark_default_key = "spark-default.conf"
        app_spark_conf, user_spark_conf = None, None
        if app_config_dict is not None and spark_default_key in app_config_dict:
            app_spark_conf = app_config_dict[spark_default_key]

        if user_config_dict is not None and spark_default_key in user_config_dict:
            user_spark_conf = user_config_dict[spark_default_key]

        resolved_configs = []
        if app_spark_conf is not None:
            if user_spark_conf is not None:
                for app_config in app_spark_conf:
                    updated = False
                    for user_config in user_spark_conf:
                        if app_config["name"] == user_config["name"]:
                            override_allowed = "override_allowed"
                            if override_allowed not in app_config or app_config[override_allowed]:
                                resolved_configs.append(user_config)
                                updated = True
                            else:
                                raise SparkConfigValidatorException(
                                    "App config {" + app_config["name"] + "} cannot be overridden")
                    if not updated:
                        # append to the final list
                        resolved_configs.append(app_config)
            else:
                resolved_configs = app_spark_conf
        else:
            if user_spark_conf is not None:
                resolved_configs = user_spark_conf

        logging.debug("Resolved Configs Size=" + str(len(resolved_configs)) + ", Content => " + str(resolved_configs))

        user_only_config = []
        # For configs only present in user_conf add them to final list
        if user_spark_conf is not None:
            for user_config in user_spark_conf:
                found = False
                for rconfig in resolved_configs:
                    if user_config["name"] == rconfig["name"]:
                        found = True
                        break
                if not found:
                    user_only_config.append(user_config)

        logging.debug("UserOnly Configs Size=" + str(len(user_only_config)) + ", Content => " + str(user_only_config))
        final_config = user_only_config + resolved_configs
        logging.debug("Merged Configs Size=" + str(len(final_config)) + ", Content => " + str(final_config))

        options = ""
        if user_only_config is not None:
            for spark_conf in final_config:
                value = spark_conf["value"]
                # if its of type string and has spaces in it, need to add inside quotes
                if isinstance(value, basestring) and ' ' in value:
                    # TODO values with spaces is unsupported. Have some issue with quotes when its passes to bash.
                    # will be supported later.
                    raise SparkConfigValidatorException(
                        "Configuration {0} should not contain values with spaces  \"{1}\". Unsupported".format(
                            spark_conf["name"], value))
                    # conf_options = " --conf {0}=\"{1}\"".format(spark_conf["name"], value)
                else:
                    conf_options = " --conf {0}={1}".format(spark_conf["name"], value)
                options = options + conf_options
        return options

    @staticmethod
    def json_file_to_dict(data):
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
    def check_system_override(config):
        for key in config.keys():
            if key not in conf_files_supported:
                raise SparkConfigValidatorException("Updating config file " + key + " is not allowed")
            for property in config[key]:
                if property["name"] in system_spark_confs and key == "spark-default.conf":
                    raise SparkConfigValidatorException("Cannot override system config " + property["name"])


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
