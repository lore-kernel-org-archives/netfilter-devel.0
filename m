Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556B6C31E5B
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 17:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 172542166E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 17:58:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LA3FPiob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfFSR57 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 13:57:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35806 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSR57 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 13:57:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id s27so98172pgl.2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 10:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6Mz04QzeBxhLV9R+A+6B3mvgMM5yacV0ye2mzvZBYbY=;
        b=LA3FPiobyjXk5KdqsKIactDB+vFPbNjDdr04KNak3d1yzo6PRn7fBM02ZdltyoZiFp
         2yFJP0uDpWm+XoVdxZdR9DfMf35+cH9sdJwNnV6TtmZa2ZCx3bmUnJHTFWrm77fsLwMG
         B6a8IkxoEqGCyRpOoISh06YxZEHUpLbxY96ZUparo1Xyfn3HVh77+I3Du3Wfr7+w+Q+5
         MkHfbUAzlBYcwElkEjBX8FYnzosMC3Bnac9g9L+rRCIr5Yf2VHvNZvJbM9CxJ24niTEI
         k8eDIEpb/IwWVFNNdzdHdXOacdIlOz0x/KEfzfJ5JuXkZ7azs9h0DbXMp9X7BAneG/Ua
         eNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Mz04QzeBxhLV9R+A+6B3mvgMM5yacV0ye2mzvZBYbY=;
        b=rywj3l8b6y96I3UdF5rDHYeKpu5CrxomOOSRqIvutFZLo5PjYM2ZR+nVT3QNe1N/+H
         Fi6vCcMsOt/NQdg8vDbMsvLFS8TOvHg+h3w2B+ixYwQ5Ekz8kqaNmMBu1rNENWavHd55
         UPeKCrj1ImxA0+vkymeEieeXFRWgvpQ0I4YVqD+qY2uOV66XqN/1OorWk6oLy7Rlpd1K
         s/F5UvK9ZDwkgbzjEmwJI6mrQXQZtyak/R1K0JkUZFybQLdF/zT1MEb4tMWrLX0rXBkF
         gZlSneJe5o/EzjYf9PEIvTaV8CW7W0O2BqjEvZquXCJRfxlIZNGHhFBPpFwEh7qPu0ot
         rNLw==
X-Gm-Message-State: APjAAAX6+HmaMLGIvk71U7y0eKeW8g3VWC9Wx0oddi1+pgPMopwoF60p
        NCP7180w0q1ni0pzPGZxL1aifet3L+o=
X-Google-Smtp-Source: APXvYqyY7shjQ+HrQLjQqZsrAgOfM++kLzLy4OjdvMspee35u++545goKx/cMUV8MGGjP25Ycl/5vQ==
X-Received: by 2002:a62:8f91:: with SMTP id n139mr5251231pfd.48.1560967072093;
        Wed, 19 Jun 2019 10:57:52 -0700 (PDT)
Received: from shekhar.domain.name ([117.200.146.33])
        by smtp.gmail.com with ESMTPSA id k13sm18312362pgq.45.2019.06.19.10.57.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 10:57:51 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v9]tests: py: fix pyhton3
Date:   Wed, 19 Jun 2019 23:27:41 +0530
Message-Id: <20190619175741.22411-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch changes the file to run on both python2 and python3.

The tempfile module has been imported and used.
Although the previous replacement of cmp() by eric works, 
I have replaced cmp(a,b) by ((a>b)-(a<b)) which works correctly.

Thanks!


Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
The version hystory of this patch is:
v1:conversion to py3 by changing the print statements.
v2:add the '__future__' package for compatibility with py2 and py3.
v3:solves the 'version' problem in argparse by adding a new argument.
v4:uses .format() method to make print statements clearer.
v5:updated the shebang and corrected the sequence of import statements.
v6:resent the same with small changes
v7:resent with small changes
v9: replaced os module with tempfile and replaced cmp(a,b)
    with ((a>b)-(a<b)).


 tests/py/nft-test.py | 55 +++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 09d00dba..7ebcc8f1 100755
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
@@ -490,7 +493,7 @@ def set_check_element(rule1, rule2):
     pos1 = rule1.find("{")
     pos2 = rule2.find("{")
 
-    if (cmp(rule1[:pos1], rule2[:pos2]) != 0):
+    if (((rule1[:pos1] > rule2[:pos2]) - (rule1[:pos1] < rule2[:pos2])) != 0):
         return ret;
 
     end1 = rule1.find("}")
@@ -501,13 +504,13 @@ def set_check_element(rule1, rule2):
         list2 = (rule2[pos2 + 1:end2].replace(" ", "")).split(",")
         list1.sort()
         list2.sort()
-        if cmp(list1, list2) == 0:
+        if ((list1 > list2) - (list1 < list2)  == 0):
             ret = 0
 
     if ret != 0:
         return ret
 
-    return cmp(rule1[end1:], rule2[end2:])
+    return ((rule1[end1:] > rule2[end2:]) - (rule1[end1:] < rule2[end2:]))
 
 
 def obj_add(o, test_result, filename, lineno):
@@ -770,7 +773,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
             unit_tests += 1
             table_flush(table, filename, lineno)
 
-            payload_log = os.tmpfile()
+            payload_log = tempfile.TemporaryFile(mode="w+")
 
             # Add rule and check return code
             cmd = "add rule %s %s %s" % (table, chain, rule[0])
@@ -910,7 +913,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
                               gotf.name, 1)
 
             table_flush(table, filename, lineno)
-            payload_log = os.tmpfile()
+            payload_log = tempfile.TemporaryFile(mode="w+")
 
             # Add rule in JSON format
             cmd = json.dumps({ "nftables": [{ "add": { "rule": {
@@ -1016,9 +1019,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
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
@@ -1212,7 +1215,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
         sys.stdout.flush()
 
         if signal_received == 1:
-            print "\nSignal received. Cleaning up and Exitting..."
+            print("\nSignal received. Cleaning up and Exitting...")
             cleanup_on_exit()
             sys.exit(0)
 
@@ -1319,13 +1322,13 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
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
@@ -1336,7 +1339,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
 
 def main():
-    parser = argparse.ArgumentParser(description='Run nft tests', version='1.0')
+    parser = argparse.ArgumentParser(description='Run nft tests')
 
     parser.add_argument('filenames', nargs='*', metavar='path/to/file.t',
                         help='Run only these tests')
@@ -1359,6 +1362,10 @@ def main():
                         dest='enable_schema',
                         help='verify json input/output against schema')
 
+    parser.add_argument('-v', '--version', action='version',
+                        version='1.0',
+                        help='Print the version information')
+
     args = parser.parse_args()
     global debug_option, need_fix_option, enable_json_option, enable_json_schema
     debug_option = args.debug
@@ -1372,15 +1379,15 @@ def main():
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
@@ -1434,19 +1441,15 @@ def main():
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

