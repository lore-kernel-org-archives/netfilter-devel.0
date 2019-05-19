Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE8BC04AB4
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF70020578
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WOXNHO+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfESRgf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 13:36:35 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43345 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfESRgf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 13:36:35 -0400
Received: by mail-pl1-f193.google.com with SMTP id gn7so1444656plb.10
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2019 10:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7xCWPbezokXDzuCITcDWfM0uSLVcMS81/STKrmvyMyo=;
        b=WOXNHO+cE5gVvriqpI1Q9XYYOzaatBToIE2XsbRHgNG22a1jwJjVaY8jPtu0tCMxDg
         PON3QdceTH3L0q1VAeKb/tsV2y6XX8z4fHFl2kZIfdu70GKbgJXHxwlz2TvWliYoJ7t6
         vVEqS89ZTE6o0lFN+pPDC+aX2kZbzKXSDuyJLP7LLqLK/vzxAgh5wX2/Ss87D5QyjcQU
         Ez/+PgMtHEMNKeGxHFpRlbiHhretUwWSL5Mh5//vJpoXVQ/oCYDeTG3O8nO4281sVwcJ
         3BNtGJM14/7NfFAxfWyqHkK2M/vvDMpLuKdvqHLGwGX48yKiOcuRnQGBlzcSuh1naNRO
         LgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7xCWPbezokXDzuCITcDWfM0uSLVcMS81/STKrmvyMyo=;
        b=K/MRmsqawvsAlVdPC4Hk2nq7uOD4tJTHm6CuJc4iviOixX5Np04Gwr1SVAKEVAmUfT
         ip77AqLxZga/lIWRKNJi/ht7aobBvO1kbnTwsnza6oKRuJJWG7EI2B0SyU0ro6oEgmNZ
         lF5UnbIUNp1cs9fD/9xF6Pn2gJfujfQhW++JrMuRSC0v1TSLvWzZHRvxj4NwHZ66YqxD
         tt9tOtYRKdg2tL70OYMDMg9WqizjgV6o74lFlhN4Z3dt7VTIDI/CSoBtEI+nEq0FywZt
         KNJOo4IFQQDaYYGg066sO0NB6F1gwcegfLwPkQRCVNGelQsW+aFPybpfZuAidgrEw5fg
         i76A==
X-Gm-Message-State: APjAAAV4wmmw1IWP/qBEoKwcmXHxj+OcF8+WIcNjR5pVaoBgCoSUh3Ji
        BuhxBoowo6yTtK1ULzYNJ/7tE9Zv7pQ=
X-Google-Smtp-Source: APXvYqzVgMipb7mV2TkAa8q2zfv99XkKr8+wJZ7Xwxi8q/jVPDfj5LF6j6CxGGC5mKFCtPVVTlap6w==
X-Received: by 2002:a17:902:bf4a:: with SMTP id u10mr49199248pls.56.1558266982805;
        Sun, 19 May 2019 04:56:22 -0700 (PDT)
Received: from localhost.localdomain ([2405:204:e283:bf15:d2f:8e08:d39a:5be7])
        by smtp.gmail.com with ESMTPSA id c189sm33643758pfg.46.2019.05.19.04.56.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 04:56:22 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v1] tests: py: Add netns feature
Date:   Sun, 19 May 2019 17:26:04 +0530
Message-Id: <20190519115604.125692-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the netns feature to the nft-test.py file.
In some of the functions, the default value of the netns argument has been set to 0 due to the presence of other default arguments, rest of the functions have netns as a non-default argument.
(P.S.: The file has also been converted to python3 according to the previous patch titled: [PATCH nft v2] tests: py: fix python3.)

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 tests/py/nft-test.py | 120 ++++++++++++++++++++++++++++++-------------
 1 file changed, 84 insertions(+), 36 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 1c0afd0e..cb8b6cf4 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -13,6 +13,8 @@
 # Thanks to the Outreach Program for Women (OPW) for sponsoring this test
 # infrastructure.
 
+from __future__ import print_function
+from nftables import Nftables
 import sys
 import os
 import argparse
@@ -22,7 +24,6 @@ import json
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
 
-from nftables import Nftables
 
 TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
 LOGFILE = "/tmp/nftables-test.log"
@@ -171,27 +172,31 @@ def print_differences_error(filename, lineno, cmd):
     print_error(reason, filename, lineno)
 
 
-def table_exist(table, filename, lineno):
+def table_exist(table, filename, lineno, netns):
     '''
     Exists a table.
     '''
     cmd = "list table %s" % table
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd 
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def table_flush(table, filename, lineno):
+def table_flush(table, filename, lineno, netns):
     '''
     Flush a table.
     '''
     cmd = "flush table %s" % table
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     execute_cmd(cmd, filename, lineno)
 
     return cmd
 
 
-def table_create(table, filename, lineno):
+def table_create(table, filename, lineno, netns):
     '''
     Adds a table.
     '''
@@ -205,6 +210,8 @@ def table_create(table, filename, lineno):
 
     # We add a new table
     cmd = "add table %s" % table
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     ret = execute_cmd(cmd, filename, lineno)
 
     if ret != 0:
@@ -233,7 +240,7 @@ def table_create(table, filename, lineno):
     return 0
 
 
-def table_delete(table, filename=None, lineno=None):
+def table_delete(table, filename=None, lineno=None, netns=0):
     '''
     Deletes a table.
     '''
@@ -243,6 +250,8 @@ def table_delete(table, filename=None, lineno=None):
         return -1
 
     cmd = "delete table %s" % table
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "%s: I cannot delete table %s. Giving up!" % (cmd, table)
@@ -258,17 +267,19 @@ def table_delete(table, filename=None, lineno=None):
     return 0
 
 
-def chain_exist(chain, table, filename):
+def chain_exist(chain, table, filename, netns):
     '''
     Checks a chain
     '''
     cmd = "list chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     ret = execute_cmd(cmd, filename, chain.lineno)
 
     return True if (ret == 0) else False
 
 
-def chain_create(chain, table, filename):
+def chain_create(chain, table, filename, netns):
     '''
     Adds a chain
     '''
@@ -279,6 +290,8 @@ def chain_create(chain, table, filename):
         return -1
 
     cmd = "add chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     if chain.config:
         cmd += " { %s; }" % chain.config
 
@@ -297,7 +310,7 @@ def chain_create(chain, table, filename):
     return 0
 
 
-def chain_delete(chain, table, filename=None, lineno=None):
+def chain_delete(chain, table, filename=None, lineno=None, netns=0):
     '''
     Flushes and deletes a chain.
     '''
@@ -308,6 +321,8 @@ def chain_delete(chain, table, filename=None, lineno=None):
         return -1
 
     cmd = "flush chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "I cannot " + cmd
@@ -315,6 +330,8 @@ def chain_delete(chain, table, filename=None, lineno=None):
         return -1
 
     cmd = "delete chain %s %s" % (table, chain)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "I cannot " + cmd
@@ -340,7 +357,7 @@ def chain_get_by_name(name):
     return chain
 
 
-def set_add(s, test_result, filename, lineno):
+def set_add(s, test_result, filename, lineno, netns):
     '''
     Adds a set.
     '''
@@ -362,6 +379,8 @@ def set_add(s, test_result, filename, lineno):
             flags = "flags %s; " % flags
 
         cmd = "add set %s %s { type %s;%s %s}" % (table, s.name, s.type, s.timeout, flags)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test" + cmd
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and test_result == "fail") or \
@@ -379,7 +398,7 @@ def set_add(s, test_result, filename, lineno):
     return 0
 
 
-def set_add_elements(set_element, set_name, state, filename, lineno):
+def set_add_elements(set_element, set_name, state, filename, lineno, netns):
     '''
     Adds elements to the set.
     '''
@@ -399,6 +418,8 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
 
         element = ", ".join(set_element)
         cmd = "add element %s %s { %s }" % (table, set_name, element)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test" + cmd
         ret = execute_cmd(cmd, filename, lineno)
 
         if (state == "fail" and ret == 0) or (state == "ok" and ret != 0):
@@ -416,12 +437,14 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
 
 
 def set_delete_elements(set_element, set_name, table, filename=None,
-                        lineno=None):
+                        lineno=None, netns=0):
     '''
     Deletes elements in a set.
     '''
     for element in set_element:
         cmd = "delete element %s %s { %s }" % (table, set_name, element)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test" + cmd
         ret = execute_cmd(cmd, filename, lineno)
         if ret != 0:
             reason = "I cannot delete element %s " \
@@ -432,11 +455,11 @@ def set_delete_elements(set_element, set_name, table, filename=None,
     return 0
 
 
-def set_delete(table, filename=None, lineno=None):
+def set_delete(table, filename=None, lineno=None, netns=0):
     '''
     Deletes set and its content.
     '''
-    for set_name in all_set.keys():
+    for set_name in list(all_set.keys()):
         # Check if exists the set
         if not set_exist(set_name, table, filename, lineno):
             reason = "The set %s does not exist, " \
@@ -450,6 +473,8 @@ def set_delete(table, filename=None, lineno=None):
 
         # We delete the set.
         cmd = "delete set %s %s" % (table, set_name)
+        if netns:
+	    cmd = "ip netns exec ___nftables-container-test" + cmd
         ret = execute_cmd(cmd, filename, lineno)
 
         # Check if the set still exists after I deleted it.
@@ -461,21 +486,25 @@ def set_delete(table, filename=None, lineno=None):
     return 0
 
 
-def set_exist(set_name, table, filename, lineno):
+def set_exist(set_name, table, filename, lineno, netns):
     '''
     Check if the set exists.
     '''
     cmd = "list set %s %s" % (table, set_name)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def _set_exist(s, filename, lineno):
+def _set_exist(s, filename, lineno, netns):
     '''
     Check if the set exists.
     '''
     cmd = "list set %s %s %s" % (s.family, s.table, s.name)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -509,7 +538,7 @@ def set_check_element(rule1, rule2):
     return cmp(rule1[end1:], rule2[end2:])
 
 
-def obj_add(o, test_result, filename, lineno):
+def obj_add(o, test_result, filename, lineno, netns):
     '''
     Adds an object.
     '''
@@ -528,6 +557,8 @@ def obj_add(o, test_result, filename, lineno):
             return -1
 
         cmd = "add %s %s %s %s" % (o.type, table, o.name, o.spcf)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test" + cmd
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and test_result == "fail") or \
@@ -554,7 +585,7 @@ def obj_add(o, test_result, filename, lineno):
         print_error(reason, filename, lineno)
         return -1
 
-def obj_delete(table, filename=None, lineno=None):
+def obj_delete(table, filename=None, lineno=None, netns=0):
     '''
     Deletes object.
     '''
@@ -568,6 +599,8 @@ def obj_delete(table, filename=None, lineno=None):
 
         # We delete the object.
         cmd = "delete %s %s %s" % (o.type, table, o.name)
+        if netns:
+            cmd = "ip netns exec ___nftables-container-test" + cmd
         ret = execute_cmd(cmd, filename, lineno)
 
         # Check if the object still exists after I deleted it.
@@ -579,21 +612,25 @@ def obj_delete(table, filename=None, lineno=None):
     return 0
 
 
-def obj_exist(o, table, filename, lineno):
+def obj_exist(o, table, filename, lineno, netns):
     '''
     Check if the object exists.
     '''
     cmd = "list %s %s %s" % (o.type, table, o.name)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def _obj_exist(o, filename, lineno):
+def _obj_exist(o, filename, lineno, netns):
     '''
     Check if the object exists.
     '''
     cmd = "list %s %s %s %s" % (o.type, o.family, o.table, o.name)
+    if netns:
+        cmd = "ip netns exec ___nftables-container-test" + cmd
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -688,7 +725,7 @@ def json_dump_normalize(json_string, human_readable = False):
         return json.dumps(json_obj, sort_keys = True)
 
 
-def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
+def rule_add(rule, filename, lineno, force_all_family_option, filename_path, netns):
     '''
     Adds a rule
     '''
@@ -766,6 +803,8 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
             # Add rule and check return code
             cmd = "add rule %s %s %s" % (table, chain, rule[0])
+            if netns:
+	        cmd = "ip netns exec ___nftables-container-test" + cmd
             ret = execute_cmd(cmd, filename, lineno, payload_log, debug="netlink")
 
             state = rule[1].rstrip()
@@ -862,6 +901,8 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
                 # Add rule and check return code
                 cmd = "add rule %s %s %s" % (table, chain, rule_output.rstrip())
+                if netns:
+                    cmd = "ip netns exec ___nftables-container-test" + cmd
                 ret = execute_cmd(cmd, filename, lineno, payload_log, debug="netlink")
 
                 if ret != 0:
@@ -946,6 +987,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
             nftables.set_stateless_output(stateless_old)
 
             json_output = json.loads(json_output)
+
             for item in json_output["nftables"]:
                 if "rule" in item:
                     del(item["rule"]["handle"])
@@ -1002,9 +1044,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
     :param debug: temporarily set these debug flags
     '''
     global log_file
-    print >> log_file, "command: %s" % cmd
+    print("command: %s" % cmd, file=log_file)
     if debug_option:
-        print cmd
+        print(cmd)
 
     if debug:
         debug_old = nftables.get_debug()
@@ -1193,12 +1235,14 @@ def run_test_file(filename, force_all_family_option, specific_file):
     filename_path = os.path.join(TESTS_PATH, filename)
     f = open(filename_path)
     tests = passed = total_unit_run = total_warning = total_error = 0
+    if netns:
+        execute_cmd("ip netns add ___nftables-container-test", filename, 0)
 
     for lineno, line in enumerate(f):
         sys.stdout.flush()
 
         if signal_received == 1:
-            print "\nSignal received. Cleaning up and Exitting..."
+            print("\nSignal received. Cleaning up and Exitting...")
             cleanup_on_exit()
             sys.exit(0)
 
@@ -1305,14 +1349,15 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
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
-
+            print(filename + ": " + Colors.GREEN + "OK" + Colors.ENDC)
+	if netns:
+            execute_cmd("ip netns del ___nftables-container-test", filename, 0)
     f.close()
     del table_list[:]
     del chain_list[:]
@@ -1341,6 +1386,9 @@ def main():
                         dest='enable_json',
                         help='test JSON functionality as well')
 
+    parser.add_argument('-N', '--netns', action='store_true',
+                        help='Test namespace path')
+
     args = parser.parse_args()
     global debug_option, need_fix_option, enable_json_option
     debug_option = args.debug
@@ -1353,15 +1401,15 @@ def main():
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
+        print("The nftables library does not exist. " \
+              "You need to build the project.")
         return
 
     global nftables
@@ -1411,18 +1459,18 @@ def main():
             run_total += file_unit_run
 
     if test_files == 0:
-        print "No test files to run"
+        print("No test files to run")
     else:
         if not specific_file:
             if force_all_family_option:
-                print "%d test files, %d files passed, %d unit tests, " \
+                print("%d test files, %d files passed, %d unit tests, " \
                       "%d total executed, %d error, %d warning" \
                       % (test_files, files_ok, tests, run_total, errors,
-                         warnings)
+                         warnings))
             else:
-                print "%d test files, %d files passed, %d unit tests, " \
+                print("%d test files, %d files passed, %d unit tests, " \
                       "%d error, %d warning" \
-                      % (test_files, files_ok, tests, errors, warnings)
+                      % (test_files, files_ok, tests, errors, warnings))
 
 
 if __name__ == '__main__':
-- 
2.21.0.windows.1

