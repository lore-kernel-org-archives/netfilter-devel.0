Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B33EC433DB
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Jan 2021 00:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3A2225AC
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Jan 2021 00:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbhAXAXX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Jan 2021 19:23:23 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:40391 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbhAXAXW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Jan 2021 19:23:22 -0500
Received: by mail-wm1-f44.google.com with SMTP id c127so7587045wmf.5
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Jan 2021 16:23:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=fUm7jXpVlmnxyMxnKOepRJhYPSZoUXaQZaKnpez9mVM=;
        b=DyXg27O0/o7/41HDSRMVvWCgg1xaVFLQTBblj18r04rwQ30+YkMQ2U3Hp5Fz31GOUS
         NHPHXwIapoYGmAoS0dSPlvFQ7redJQHhCbHJS7VGNZbDWm4MkWIqY784BF/kGjLczKbh
         bNCj1q2EN5MeW2VejmQZ+i+ukYfVIUisgcluWLoJzFalAh+k1oYTokgVM6i0W0/2vja2
         BqNU9p8HxkI4A94D8d/FHYICxA9ge4JH+8yV6gnMntjQprYSLj6kvk3SQa3+Wt025SIG
         BqfnjmLGhREP80vb9n35AuT17yUaqLUYCfObCuw4GdPywA+ksWVyBaIw56vG2NHO+Cxz
         8Nsw==
X-Gm-Message-State: AOAM532IQSOUVFusWXBB6KtVLySXreFsmlqFZIjGucwB5+5BuMcef6Cm
        i9B12HPuUPYRJYNu/v2w7NUrmM0scYQcQw==
X-Google-Smtp-Source: ABdhPJz1NJcO/DIgNVXv70iEF131W8OmD3wLobFT5qL0im2sXQXAi2ueBysqzbcifH248y6tRHHISQ==
X-Received: by 2002:a1c:2b05:: with SMTP id r5mr9770462wmr.179.1611447758651;
        Sat, 23 Jan 2021 16:22:38 -0800 (PST)
Received: from localhost ([213.194.141.17])
        by smtp.gmail.com with ESMTPSA id d5sm15296389wrs.21.2021.01.23.16.22.37
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 16:22:38 -0800 (PST)
Subject: [conntrack-tools PATCH 1/3] tests: introduce new python-based
 framework for running tests
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Sun, 24 Jan 2021 01:22:37 +0100
Message-ID: <161144773322.52227.18304556638755743629.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This test suite should help us develop better tests for conntrack-tools in general and conntrackd
in particular.

The framework is composed of a runner script, written in python3, and 3 yaml files for
configuration and testcase definition:

 - scenarios.yaml: contains information on network scenarios for tests to use
 - tests.yaml: contains testcase definition
 - env.yaml: contains default values for environment variables

The test cases can be anything, from a simple command to an external script call to perform more
complex operations. See follow-up patches to know more on how this works.

The plan is to replace or call from this framework the other testsuites in this tree.

The runner script is rather simple, and it should be more or less straight forward to use it.
It requires the python3-yaml package to be installed.

For reference, here are the script options:

=== 8< ===
$ tests/cttools-testing-framework.py --help
usage: cttools-testing-framework.py [-h] [--tests-file TESTS_FILE]
				[--scenarios-file SCENARIOS_FILE]
				[--env-file ENV_FILE]
				[--single SINGLE]
				[--start-scenario START_SCENARIO]
				[--stop-scenario STOP_SCENARIO]
				[--debug]

Utility to run tests for conntrack-tools

optional arguments:
  -h, --help            show this help message and exit
  --tests-file TESTS_FILE
                        File with testcase definitions. Defaults to 'tests.yaml'
  --scenarios-file SCENARIOS_FILE
                        File with configuration scenarios for tests. Defaults to 'scenarios.yaml'
  --env-file ENV_FILE   File with environment variables for scenarios/tests. Defaults to 'env.yaml'
  --single SINGLE       Execute a single testcase and exit. Use this for developing testcases
  --start-scenario START_SCENARIO
                        Execute scenario start commands and exit. Use this for developing testcases
  --stop-scenario STOP_SCENARIO
                        Execute scenario stop commands and exit. Use this for cleanup
  --debug               debug mode
=== 8< ===

To run it, simply use:

=== 8< ===
$ cd tests/ ; sudo ./cttools-testing-framework.py
[..]
=== 8< ===

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 cttools-testing-framework.py |  263 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 263 insertions(+)

diff --git a/tests/cttools-testing-framework.py b/tests/cttools-testing-framework.py
new file mode 100755
index 0000000..f760351
--- /dev/null
+++ b/tests/cttools-testing-framework.py
@@ -0,0 +1,263 @@
+#!/usr/bin/env python3
+
+# (C) 2021 by Arturo Borrero Gonzalez <arturo@netfilter.org>
+
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 3 of the License, or
+# (at your option) any later version.
+#
+
+# tests.yaml file format:
+#  - name: "test 1"
+#    scenario: scenario1
+#    test:
+#      - test1 cmd1
+#      - test1 cmd2
+
+# scenarios.yaml file format:
+# - name: scenario1
+#   start:
+#     - cmd1
+#     - cmd2
+#   stop:
+#     - cmd1
+#     - cmd2
+
+# env.yaml file format:
+# - VAR1: value1
+# - VAR2: value2
+
+import os
+import sys
+import argparse
+import subprocess
+import yaml
+import logging
+
+
+def read_yaml_file(file):
+    try:
+        with open(file, "r") as stream:
+            try:
+                return yaml.safe_load(stream)
+            except yaml.YAMLError as e:
+                logging.error(e)
+                exit(2)
+    except FileNotFoundError as e:
+        logging.error(e)
+        exit(2)
+
+
+def validate_dictionary(dictionary, keys):
+    if not isinstance(dictionary, dict):
+        logging.error("not a dictionary:\n{}".format(dictionary))
+        return False
+    for key in keys:
+        if dictionary.get(key) is None:
+            logging.error("missing key {} in dictionary:\n{}".format(key, dictionary))
+            return False
+    return True
+
+
+def stage_validate_config(args):
+    scenarios_dict = read_yaml_file(args.scenarios_file)
+    for definition in scenarios_dict:
+        if not validate_dictionary(definition, ["name", "start", "stop"]):
+            logging.error("couldn't validate file {}".format(args.scenarios_file))
+            return False
+
+    logging.debug("{} seems valid".format(args.scenarios_file))
+    ctx.scenarios_dict = scenarios_dict
+
+    tests_dict = read_yaml_file(args.tests_file)
+    for definition in tests_dict:
+        if not validate_dictionary(definition, ["name", "scenario", "test"]):
+            logging.error("couldn't validate file {}".format(args.tests_file))
+            return False
+
+    logging.debug("{} seems valid".format(args.tests_file))
+    ctx.tests_dict = tests_dict
+
+    env_list = read_yaml_file(args.env_file)
+    if not isinstance(env_list, list):
+        logging.error("couldn't validate file {}".format(args.env_file))
+        return False
+
+    # set env to default values if not overridden when calling this very script
+    for entry in env_list:
+        for key in entry:
+            os.environ[key] = os.getenv(key, entry[key])
+
+
+def cmd_run(cmd):
+    logging.debug("running command: {}".format(cmd))
+    r = subprocess.run(cmd, shell=True)
+    if r.returncode != 0:
+        logging.warning("failed command: {}".format(cmd))
+    return r.returncode
+
+
+def scenario_get(name):
+    for n in ctx.scenarios_dict:
+        if n["name"] == name:
+            return n
+
+    logging.error("couldn't find a definition for scenario '{}'".format(name))
+    exit(1)
+
+
+def scenario_start(scenario):
+    for cmd in scenario["start"]:
+        if cmd_run(cmd) == 0:
+            continue
+
+        logging.warning("--- failed scenario: {}".format(scenario["name"]))
+        ctx.counter_scenario_failed += 1
+        ctx.skip_current_test = True
+        return
+
+
+def scenario_stop(scenario):
+    for cmd in scenario["stop"]:
+        cmd_run(cmd)
+
+
+def test_get(name):
+    for n in ctx.tests_dict:
+        if n["name"] == name:
+            return n
+
+    logging.error("couldn't find a definition for test '{}'".format(name))
+    exit(1)
+
+
+def _test_run(test_definition):
+    if ctx.skip_current_test:
+        return
+
+    for cmd in test_definition["test"]:
+        if cmd_run(cmd) == 0:
+            continue
+
+        logging.warning("--- failed test: {}".format(test_definition["name"]))
+        ctx.counter_test_failed += 1
+        return
+
+    logging.info("--- passed test: {}".format(test_definition["name"]))
+    ctx.counter_test_ok += 1
+
+
+def test_run(test_definition):
+    scenario = scenario_get(test_definition["scenario"])
+
+    logging.info("--- running test: {}".format(test_definition["name"]))
+
+    scenario_start(scenario)
+    _test_run(test_definition)
+    scenario_stop(scenario)
+
+
+def stage_run_tests(args):
+    if args.start_scenario:
+        scenario_start(scenario_get(args.start_scenario))
+        return
+
+    if args.stop_scenario:
+        scenario_stop(scenario_get(args.stop_scenario))
+        return
+
+    if args.single:
+        test_run(test_get(args.single))
+        return
+
+    for test_definition in ctx.tests_dict:
+        ctx.skip_current_test = False
+        test_run(test_definition)
+
+
+def stage_report():
+    logging.info("---")
+    logging.info("--- finished")
+    total = ctx.counter_test_ok + ctx.counter_test_failed + ctx.counter_scenario_failed
+    logging.info("--- passed tests: {}".format(ctx.counter_test_ok))
+    logging.info("--- failed tests: {}".format(ctx.counter_test_failed))
+    logging.info("--- scenario failure: {}".format(ctx.counter_scenario_failed))
+    logging.info("--- total tests: {}".format(total))
+
+
+def parse_args():
+    description = "Utility to run tests for conntrack-tools"
+    parser = argparse.ArgumentParser(description=description)
+    parser.add_argument(
+        "--tests-file",
+        default="tests.yaml",
+        help="File with testcase definitions. Defaults to '%(default)s'",
+    )
+    parser.add_argument(
+        "--scenarios-file",
+        default="scenarios.yaml",
+        help="File with configuration scenarios for tests. Defaults to '%(default)s'",
+    )
+    parser.add_argument(
+        "--env-file",
+        default="env.yaml",
+        help="File with environment variables for scenarios/tests. Defaults to '%(default)s'",
+    )
+    parser.add_argument(
+        "--single",
+        help="Execute a single testcase and exit. Use this for developing testcases",
+    )
+    parser.add_argument(
+        "--start-scenario",
+        help="Execute scenario start commands and exit. Use this for developing testcases",
+    )
+    parser.add_argument(
+        "--stop-scenario",
+        help="Execute scenario stop commands and exit. Use this for cleanup",
+    )
+    parser.add_argument(
+        "--debug",
+        action="store_true",
+        help="debug mode",
+    )
+
+    return parser.parse_args()
+
+
+class Context:
+    def __init__(self):
+        self.scenarios_dict = None
+        self.tests_dict = None
+        self.counter_test_failed = 0
+        self.counter_test_ok = 0
+        self.counter_scenario_failed = 0
+        self.skip_current_test = False
+
+
+# global data
+ctx = Context()
+
+
+def main():
+    args = parse_args()
+
+    logging_format = "[%(filename)s] %(levelname)s: %(message)s"
+    if args.debug:
+        logging_level = logging.DEBUG
+    else:
+        logging_level = logging.INFO
+    logging.basicConfig(format=logging_format, level=logging_level, stream=sys.stdout)
+
+    if os.geteuid() != 0:
+        logging.error("root required")
+        exit(1)
+
+    stage_validate_config(args)
+    stage_run_tests(args)
+    stage_report()
+
+
+if __name__ == "__main__":
+    main()

