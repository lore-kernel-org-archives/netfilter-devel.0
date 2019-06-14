Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA45C31E4B
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 14:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1BF82133D
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 14:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LD7JGVf3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbfFNOjs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 10:39:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42786 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbfFNOjr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 10:39:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so1579659pff.9
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 07:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O7hR6Z7nfuuWLdTMHxriX9n3p4cTL0dcTvH37sBffNQ=;
        b=LD7JGVf3ABNxSqV3HWRiKsr+1qIqCFoq5xK/oWWHAqAVuqEZV0SboEz5S2yvlFlkMp
         k+2mSO8qkf7fCxE7Kz7SAgUQmYuk8In+KISrL80G1T/s0JlZ0VGClzW5sRqxAcbTXl+M
         5kPnERSQnNzb3TGmw68e1jv6JVD+RfcqYwpOYqTgFQKvayidY4C2i2hcLxIZ17OgZqt5
         gCqIDRmsWjF2WbWLZmiN2FJbZ6+fGFqCKzMeXefUjCEIqoj2DQA3qbB4Zpdp6X/V2m/Q
         lXkXbtFwtxHrqyRNKzMmuIHWQ6bdFzS91ov+OXrgbEOamdqSfgpoKCNwuLRfGfo8lbNQ
         OYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O7hR6Z7nfuuWLdTMHxriX9n3p4cTL0dcTvH37sBffNQ=;
        b=LCKOkswSb4rDOclKbT/fwCna7DSRIa6OK+vtweu2h2n4BOZzAsAOLwlK2tGO1WYCmS
         67RIJvc3o+kO4dSh4BJTVikLc+svBrFgG5FTk3kn3OHePv+u51j/eAGdOudIrmYN7Qud
         fN/80QUEoGv2DoJhpGtYOk68reet+NSCPt8NgP2hk9nWpUyBUyRGRBZqmzue1f6vpyK/
         cMh4+w6om9Lpnr8DCmhHE+CJDSa30l12PyDBGhHki6aq74vZn2aq9saEqXlV/PImA8mn
         kNqzUvMUA9Am5YqF16t36qmVvyqK2hB/BvsMxXwuJ+ICMAMdzb/9oeLpOI6DxLtI2QAG
         pnEw==
X-Gm-Message-State: APjAAAXTVNjUE+Qzdlc/e4x/lnLQiCr82Do4oI8wbj/654+UiqiFmB1r
        bquAulSjHFGXtc0gu/S5y54riClg6DU=
X-Google-Smtp-Source: APXvYqz6BgS0K+0vNipih7afnyZBabPJOlPhoT5TsqdYprcUZfkoKVcj+Sld5h97DB8S7FOJ6vHgFQ==
X-Received: by 2002:a63:d512:: with SMTP id c18mr17673501pgg.397.1560523186021;
        Fri, 14 Jun 2019 07:39:46 -0700 (PDT)
Received: from shekhar.domain.name ([59.91.149.38])
        by smtp.gmail.com with ESMTPSA id e6sm2860339pfi.42.2019.06.14.07.39.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 07:39:45 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v7 2/2]tests:py: add netns feature
Date:   Fri, 14 Jun 2019 20:09:34 +0530
Message-Id: <20190614143934.10659-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the netns feature to the 'nft-test.py' file.


Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
The version history of the patch is :
v1: add the netns feature
v2: use format() method to simplify print statements.
v3: updated the shebang
v4: resent the same with small changes
v5&v6: resent with small changes
v7: netns commands changed for passing the netns name via netns argument.

 tests/py/nft-test.py | 141 +++++++++++++++++++++++++++++++------------
 1 file changed, 102 insertions(+), 39 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 09d00dba..6ec27267 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python
 #
 # (C) 2014 by Ana Rey Botello <anarey@gmail.com>
 #
@@ -13,6 +13,7 @@
 # Thanks to the Outreach Program for Women (OPW) for sponsoring this test
 # infrastructure.
 
+from __future__ import print_function
 import sys
 import os
 import argparse
@@ -172,27 +173,31 @@ def print_differences_error(filename, lineno, cmd):
     print_error(reason, filename, lineno)
 
 
-def table_exist(table, filename, lineno):
+def table_exist(table, filename, lineno, netns=""):
     '''
     Exists a table.
     '''
     cmd = "list table %s" % table
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def table_flush(table, filename, lineno):
+def table_flush(table, filename, lineno, netns=""):
     '''
     Flush a table.
     '''
     cmd = "flush table %s" % table
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns, cmd)
     execute_cmd(cmd, filename, lineno)
 
     return cmd
 
 
-def table_create(table, filename, lineno):
+def table_create(table, filename, lineno, netns=""):
     '''
     Adds a table.
     '''
@@ -206,6 +211,8 @@ def table_create(table, filename, lineno):
 
     # We add a new table
     cmd = "add table %s" % table
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, lineno)
 
     if ret != 0:
@@ -234,7 +241,7 @@ def table_create(table, filename, lineno):
     return 0
 
 
-def table_delete(table, filename=None, lineno=None):
+def table_delete(table, filename=None, lineno=None, netns=""):
     '''
     Deletes a table.
     '''
@@ -244,6 +251,8 @@ def table_delete(table, filename=None, lineno=None):
         return -1
 
     cmd = "delete table %s" % table
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "%s: I cannot delete table %s. Giving up!" % (cmd, table)
@@ -259,17 +268,19 @@ def table_delete(table, filename=None, lineno=None):
     return 0
 
 
-def chain_exist(chain, table, filename):
+def chain_exist(chain, table, filename, netns=""):
     '''
     Checks a chain
     '''
     cmd = "list chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, chain.lineno)
 
     return True if (ret == 0) else False
 
 
-def chain_create(chain, table, filename):
+def chain_create(chain, table, filename, netns=""):
     '''
     Adds a chain
     '''
@@ -280,6 +291,9 @@ def chain_create(chain, table, filename):
         return -1
 
     cmd = "add chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(cmd)
+
     if chain.config:
         cmd += " { %s; }" % chain.config
 
@@ -298,7 +312,7 @@ def chain_create(chain, table, filename):
     return 0
 
 
-def chain_delete(chain, table, filename=None, lineno=None):
+def chain_delete(chain, table, filename=None, lineno=None, netns=""):
     '''
     Flushes and deletes a chain.
     '''
@@ -309,6 +323,9 @@ def chain_delete(chain, table, filename=None, lineno=None):
         return -1
 
     cmd = "flush chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "I cannot " + cmd
@@ -316,6 +333,8 @@ def chain_delete(chain, table, filename=None, lineno=None):
         return -1
 
     cmd = "delete chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "I cannot " + cmd
@@ -341,7 +360,7 @@ def chain_get_by_name(name):
     return chain
 
 
-def set_add(s, test_result, filename, lineno):
+def set_add(s, test_result, filename, lineno, netns=""):
     '''
     Adds a set.
     '''
@@ -363,6 +382,9 @@ def set_add(s, test_result, filename, lineno):
             flags = "flags %s; " % flags
 
         cmd = "add set %s %s { type %s;%s %s}" % (table, s.name, s.type, s.timeout, flags)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and test_result == "fail") or \
@@ -380,7 +402,7 @@ def set_add(s, test_result, filename, lineno):
     return 0
 
 
-def set_add_elements(set_element, set_name, state, filename, lineno):
+def set_add_elements(set_element, set_name, state, filename, lineno, netns=""):
     '''
     Adds elements to the set.
     '''
@@ -400,6 +422,9 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
 
         element = ", ".join(set_element)
         cmd = "add element %s %s { %s }" % (table, set_name, element)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (state == "fail" and ret == 0) or (state == "ok" and ret != 0):
@@ -417,12 +442,15 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
 
 
 def set_delete_elements(set_element, set_name, table, filename=None,
-                        lineno=None):
+                        lineno=None, netns=""):
     '''
     Deletes elements in a set.
     '''
     for element in set_element:
         cmd = "delete element %s %s { %s }" % (table, set_name, element)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
         if ret != 0:
             reason = "I cannot delete element %s " \
@@ -433,7 +461,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     return 0
 
 
-def set_delete(table, filename=None, lineno=None):
+def set_delete(table, filename=None, lineno=None, netns=""):
     '''
     Deletes set and its content.
     '''
@@ -451,6 +479,9 @@ def set_delete(table, filename=None, lineno=None):
 
         # We delete the set.
         cmd = "delete set %s %s" % (table, set_name)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         # Check if the set still exists after I deleted it.
@@ -462,21 +493,27 @@ def set_delete(table, filename=None, lineno=None):
     return 0
 
 
-def set_exist(set_name, table, filename, lineno):
+def set_exist(set_name, table, filename, lineno, netns=""):
     '''
     Check if the set exists.
     '''
     cmd = "list set %s %s" % (table, set_name)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def _set_exist(s, filename, lineno):
+def _set_exist(s, filename, lineno, netns=""):
     '''
     Check if the set exists.
     '''
     cmd = "list set %s %s %s" % (s.family, s.table, s.name)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -510,7 +547,7 @@ def set_check_element(rule1, rule2):
     return cmp(rule1[end1:], rule2[end2:])
 
 
-def obj_add(o, test_result, filename, lineno):
+def obj_add(o, test_result, filename, lineno, netns=""):
     '''
     Adds an object.
     '''
@@ -529,6 +566,9 @@ def obj_add(o, test_result, filename, lineno):
             return -1
 
         cmd = "add %s %s %s %s" % (o.type, table, o.name, o.spcf)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and test_result == "fail") or \
@@ -555,7 +595,7 @@ def obj_add(o, test_result, filename, lineno):
         print_error(reason, filename, lineno)
         return -1
 
-def obj_delete(table, filename=None, lineno=None):
+def obj_delete(table, filename=None, lineno=None, netns=""):
     '''
     Deletes object.
     '''
@@ -569,6 +609,9 @@ def obj_delete(table, filename=None, lineno=None):
 
         # We delete the object.
         cmd = "delete %s %s %s" % (o.type, table, o.name)
+        if netns:
+            cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         # Check if the object still exists after I deleted it.
@@ -580,21 +623,27 @@ def obj_delete(table, filename=None, lineno=None):
     return 0
 
 
-def obj_exist(o, table, filename, lineno):
+def obj_exist(o, table, filename, lineno, netns=""):
     '''
     Check if the object exists.
     '''
     cmd = "list %s %s %s" % (o.type, table, o.name)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def _obj_exist(o, filename, lineno):
+def _obj_exist(o, filename, lineno, netns=""):
     '''
     Check if the object exists.
     '''
     cmd = "list %s %s %s %s" % (o.type, o.family, o.table, o.name)
+    if netns:
+        cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -696,7 +745,7 @@ def json_validate(json_string):
         print_error("schema validation failed for input '%s'" % json_string)
         print_error(traceback.format_exc())
 
-def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
+def rule_add(rule, filename, lineno, force_all_family_option, filename_path, netns=""):
     '''
     Adds a rule
     '''
@@ -774,6 +823,9 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
             # Add rule and check return code
             cmd = "add rule %s %s %s" % (table, chain, rule[0])
+            if netns:
+                cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
             ret = execute_cmd(cmd, filename, lineno, payload_log, debug="netlink")
 
             state = rule[1].rstrip()
@@ -870,6 +922,9 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
                 # Add rule and check return code
                 cmd = "add rule %s %s %s" % (table, chain, rule_output.rstrip())
+                if netns:
+                    cmd = "ip netns exec " + "{} {}".format(netns,cmd)
+
                 ret = execute_cmd(cmd, filename, lineno, payload_log, debug="netlink")
 
                 if ret != 0:
@@ -1016,9 +1071,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
     :param debug: temporarily set these debug flags
     '''
     global log_file
-    print >> log_file, "command: %s" % cmd
+    print("command: {}".format(cmd),file=log_file)
     if debug_option:
-        print cmd
+        print(cmd)
 
     if debug:
         debug_old = nftables.get_debug()
@@ -1198,7 +1253,7 @@ def json_find_expected(json_log, rule):
     return json_buffer
 
 
-def run_test_file(filename, force_all_family_option, specific_file):
+def run_test_file(filename, force_all_family_option, specific_file,netns=""):
     '''
     Runs a test file
 
@@ -1207,12 +1262,14 @@ def run_test_file(filename, force_all_family_option, specific_file):
     filename_path = os.path.join(TESTS_PATH, filename)
     f = open(filename_path)
     tests = passed = total_unit_run = total_warning = total_error = 0
+    if netns:
+        execute_cmd("ip netns add " + netns, filename, 0)
 
     for lineno, line in enumerate(f):
         sys.stdout.flush()
 
         if signal_received == 1:
-            print "\nSignal received. Cleaning up and Exitting..."
+            print("\nSignal received. Cleaning up and Exitting...")
             cleanup_on_exit()
             sys.exit(0)
 
@@ -1319,13 +1376,15 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
     if specific_file:
         if force_all_family_option:
-            print print_result_all(filename, tests, total_warning, total_error,
-                                   total_unit_run)
+            print(print_result_all(filename, tests, total_warning, total_error,
+                                   total_unit_run))
         else:
-            print print_result(filename, tests, total_warning, total_error)
+            print(print_result(filename, tests, total_warning, total_error))
     else:
         if tests == passed and tests > 0:
-            print filename + ": " + Colors.GREEN + "OK" + Colors.ENDC
+            print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
+        if netns:
+            execute_cmd("ip netns del " + netns, filename, 0)
 
     f.close()
     del table_list[:]
@@ -1336,7 +1395,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
 
 def main():
-    parser = argparse.ArgumentParser(description='Run nft tests', version='1.0')
+    parser = argparse.ArgumentParser(description='Run nft tests')
 
     parser.add_argument('filenames', nargs='*', metavar='path/to/file.t',
                         help='Run only these tests')
@@ -1359,6 +1418,13 @@ def main():
                         dest='enable_schema',
                         help='verify json input/output against schema')
 
+    parser.add_argument('-N', '--netns', action='store_true',
+                        help='Test namespace path')
+
+    parser.add_argument('-v', '--version', action='version',
+                        version='1.0',
+                        help='Print the version information')
+
     args = parser.parse_args()
     global debug_option, need_fix_option, enable_json_option, enable_json_schema
     debug_option = args.debug
@@ -1372,15 +1438,15 @@ def main():
     signal.signal(signal.SIGTERM, signal_handler)
 
     if os.getuid() != 0:
-        print "You need to be root to run this, sorry"
+        print("You need to be root to run this, sorry")
         return
 
     # Change working directory to repository root
     os.chdir(TESTS_PATH + "/../..")
 
     if not os.path.exists('src/.libs/libnftables.so'):
-        print "The nftables library does not exist. " \
-              "You need to build the project."
+        print("The nftables library does not exist. "
+              "You need to build the project.")
         return
 
     if args.enable_schema and not args.enable_json:
@@ -1434,18 +1500,15 @@ def main():
             run_total += file_unit_run
 
     if test_files == 0:
-        print "No test files to run"
+        print("No test files to run")
     else:
         if not specific_file:
             if force_all_family_option:
-                print "%d test files, %d files passed, %d unit tests, " \
-                      "%d total executed, %d error, %d warning" \
-                      % (test_files, files_ok, tests, run_total, errors,
-                         warnings)
+                print("{} test files, {} files passed, {} unit tests, ".format(test_files,files_ok,tests))
+                print("{} total executed, {} error, {} warning".format(run_total, errors, warnings))
             else:
-                print "%d test files, %d files passed, %d unit tests, " \
-                      "%d error, %d warning" \
-                      % (test_files, files_ok, tests, errors, warnings)
+                print("{} test files, {} files passed, {} unit tests, ".format(test_files,files_ok,tests))
+                print("{} error, {} warning".format(errors, warnings))
 
 
 if __name__ == '__main__':
-- 
2.17.1

