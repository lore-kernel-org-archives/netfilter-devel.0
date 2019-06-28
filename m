Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5E8C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 20:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 563912086D
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 20:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y56xEBQH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfF1UCn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 16:02:43 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:33562 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfF1UCm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 16:02:42 -0400
Received: by mail-pf1-f172.google.com with SMTP id x15so3529979pfq.0
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 13:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sWTuF+Lv7F4QfGwHyCrGNRZEpglJGlp66bEUilxWapQ=;
        b=Y56xEBQHC9dy7lDWHroMhzlo3sb2C23FExJViGacFuR3bWRO3wl9Fz7Ut5GtDO0xof
         Ql7n/Z/nHkFwi6YS1yDM2/B5N6bMG7nhTC+cBqnguAdyFm8UTxwTj/rkPadjYew1EPvc
         DkbtgEm9Icr7ibObmFT0Xa5QaAjr1PZ3MN+j3DMqD31tpWfvjXJoTPcjcsYfdSBs1gNE
         ro81CqAqv02CxgtRCffjsF0nGJ2cz8KLaTc4rsLZTqLQqGw4TMeyIVOOhriYJwv9r3ya
         OIczXm6YfdYt6koUQWWU5HTQf/jA3oh0IudXxpAgflh0vSpq4AUfTj49ZUZrj+lGhAP0
         Lf/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sWTuF+Lv7F4QfGwHyCrGNRZEpglJGlp66bEUilxWapQ=;
        b=rHKjq/aa8x/SkFEPg26h934EWJJLorEGlpC3kfSQjn6Qb9L74UiKjVOoJlkd1SiB2y
         6g5nkD5WmMa56vXUA7KmjRRcJk+e+z0gligDpbLXVzAOjaiTKkL9ObHLP5xvPGCn67cM
         8dwsjfvWWP4BeOWp72NcrofAW4Uj7lzk0NCTaVeGzdsnfflU8pZtkhnz/f8tTV4xpcZ/
         zyBfpooFtPMpYOIXl7dSW/nQxf7MsrrqLaQsHjlZNmMTARU7HpUfv27hMAvpbCSR3ppV
         y3cM2961XTychyEgKXLhPMtXA1gz/9BiF4m6t7dIr2BW9cqfXarTXcnQkOsc0aw+dkN+
         1JyA==
X-Gm-Message-State: APjAAAVC6v4BjKPh/4z/9MMMFFBtVP/M949hIESTIr9O1NdeVt9tSX/e
        GOZPptCAv72Hhh8r/7x0jVoyM9D8wTE=
X-Google-Smtp-Source: APXvYqwyhhbZzqzm94n/t1v0zICTnYYBr0b1W/QLAHw1xdEEMwBxk0leg1l54JVthmoYR9bVLDwbNA==
X-Received: by 2002:a17:90a:db52:: with SMTP id u18mr15392747pjx.107.1561752161714;
        Fri, 28 Jun 2019 13:02:41 -0700 (PDT)
Received: from shekhar.domain.name ([117.199.29.227])
        by smtp.gmail.com with ESMTPSA id m101sm2650323pjb.7.2019.06.28.13.02.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 13:02:41 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v10]tests: py: fix python3
Date:   Sat, 29 Jun 2019 01:32:29 +0530
Message-Id: <20190628200229.3217-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This converts the nft-test.py file to run on both py2 and py3.

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
The version history of this patch is:
v1:conversion to py3 by changing the print statements.
v2:add the '__future__' package for compatibility with py2 and py3.
v3:solves the 'version' problem in argparse by adding a new argument.
v4:uses .format() method to make print statements clearer.
v5:updated the shebang and corrected the sequence of import statements.
v6:resent the same with small changes
v7:resent with small changes
v9:replaced os module with tempfile and replaced cmp(a,b)
    with ((a>b)-(a<b)).
v10:replacements from v9 changed to what eric had suggested in his
    patch. (replacement of cmp() function)

---
 tests/py/nft-test.py | 67 ++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 09d00dba..f3b17ead 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python
 #
 # (C) 2014 by Ana Rey Botello <anarey@gmail.com>
 #
@@ -13,12 +13,15 @@
 # Thanks to the Outreach Program for Women (OPW) for sponsoring this test
 # infrastructure.
 
+from __future__ import print_function
 import sys
 import os
 import argparse
 import signal
 import json
 import traceback
+import tempfile
+
 
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
@@ -486,12 +489,11 @@ def set_check_element(rule1, rule2):
     '''
     Check if element exists in anonymous sets.
     '''
-    ret = -1
     pos1 = rule1.find("{")
     pos2 = rule2.find("{")
 
-    if (cmp(rule1[:pos1], rule2[:pos2]) != 0):
-        return ret;
+    if (rule1[:pos1] != rule2[:pos2]):
+        return False
 
     end1 = rule1.find("}")
     end2 = rule2.find("}")
@@ -501,13 +503,12 @@ def set_check_element(rule1, rule2):
         list2 = (rule2[pos2 + 1:end2].replace(" ", "")).split(",")
         list1.sort()
         list2.sort()
-        if cmp(list1, list2) == 0:
-            ret = 0
+        if list1 != list2:
+            return False
 
-    if ret != 0:
-        return ret
+        return rule1[end1:] == rule2[end2:]
 
-    return cmp(rule1[end1:], rule2[end2:])
+    return False
 
 
 def obj_add(o, test_result, filename, lineno):
@@ -770,7 +771,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
             unit_tests += 1
             table_flush(table, filename, lineno)
 
-            payload_log = os.tmpfile()
+            payload_log = tempfile.TemporaryFile(mode="w+")
 
             # Add rule and check return code
             cmd = "add rule %s %s %s" % (table, chain, rule[0])
@@ -840,8 +841,8 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
             if rule_output.rstrip() != teoric_exit.rstrip():
                 if rule[0].find("{") != -1:  # anonymous sets
-                    if set_check_element(teoric_exit.rstrip(),
-                                         rule_output.rstrip()) != 0:
+                    if not set_check_element(teoric_exit.rstrip(),
+                                         rule_output.rstrip()):
                         warning += 1
                         retest_output = True
                         print_differences_warning(filename, lineno,
@@ -910,7 +911,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
                               gotf.name, 1)
 
             table_flush(table, filename, lineno)
-            payload_log = os.tmpfile()
+            payload_log = tempfile.TemporaryFile(mode="w+")
 
             # Add rule in JSON format
             cmd = json.dumps({ "nftables": [{ "add": { "rule": {
@@ -1016,9 +1017,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
     :param debug: temporarily set these debug flags
     '''
     global log_file
-    print >> log_file, "command: %s" % cmd
+    print("command: {}".format(cmd), file=log_file)
     if debug_option:
-        print cmd
+        print(cmd)
 
     if debug:
         debug_old = nftables.get_debug()
@@ -1212,7 +1213,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
         sys.stdout.flush()
 
         if signal_received == 1:
-            print "\nSignal received. Cleaning up and Exitting..."
+            print("\nSignal received. Cleaning up and Exitting...")
             cleanup_on_exit()
             sys.exit(0)
 
@@ -1319,13 +1320,13 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
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
 
     f.close()
     del table_list[:]
@@ -1336,7 +1337,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
 
 def main():
-    parser = argparse.ArgumentParser(description='Run nft tests', version='1.0')
+    parser = argparse.ArgumentParser(description='Run nft tests')
 
     parser.add_argument('filenames', nargs='*', metavar='path/to/file.t',
                         help='Run only these tests')
@@ -1359,6 +1360,10 @@ def main():
                         dest='enable_schema',
                         help='verify json input/output against schema')
 
+    parser.add_argument('-v', '--version', action='version',
+                        version='1.0',
+                        help='Print the version information')
+
     args = parser.parse_args()
     global debug_option, need_fix_option, enable_json_option, enable_json_schema
     debug_option = args.debug
@@ -1372,15 +1377,15 @@ def main():
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
@@ -1434,19 +1439,15 @@ def main():
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
+                print("%d test files, %d files passed, %d unit tests, " % (test_files, files_ok, tests))
+                print("%d total executed, %d error, %d warning" % (run_total, errors,warnings))
             else:
-                print "%d test files, %d files passed, %d unit tests, " \
-                      "%d error, %d warning" \
-                      % (test_files, files_ok, tests, errors, warnings)
-
+                print("%d test files, %d files passed, %d unit tests, " % (test_files, files_ok, tests))
+                print("%d error, %d warning" % (errors, warnings))
 
 if __name__ == '__main__':
     main()
-- 
2.17.1

