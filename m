Return-Path: <SRS0=ECng=UI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037FFC28EBD
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jun 2019 18:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B88B720679
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jun 2019 18:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eTk3vbW+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfFISRz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jun 2019 14:17:55 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39856 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbfFISRy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jun 2019 14:17:54 -0400
Received: by mail-pg1-f193.google.com with SMTP id 196so3795208pgc.6
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Jun 2019 11:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eWBkCgfosJBT8DrYgOPc7WUy+oMqO8xBidR0yMNKVO8=;
        b=eTk3vbW+KJ27B7QgCSenlTSpmGtYjSswcrrhNycjU8Rvc3qkiiEVauQggnAT73Efqy
         2mAWriGDg6mO/bS74FXVBOvA9h2ZQIoTHuwG2SKcbo1H7VbaOUkruUuYfvjZD4PrdrmT
         gr4QaexbffOz2M1wKh4hNKyWbg7MjI8dg6sPXNx38xdFb36KrhAGBYIrEG9MigAkufcH
         cd/3RspeWhlhX1ZyClEs0eNDCWl/1VOyxFmBng4O2vZvYklqK5Svgdv/46s9KQ6lBbaO
         /7dKqCkmsCLOWmeJ3bF4SjNS48KtrnUSpbS8Pc/TCsLtqLiojh3L7PHl8y+RDKJhO6B3
         AZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eWBkCgfosJBT8DrYgOPc7WUy+oMqO8xBidR0yMNKVO8=;
        b=RUMsHCqwJPGGgWGQnM2/q3G07XHvrr4rqw4i5dTSwCvTXgTpK1ftIl5eBaQoKZ7/ML
         RE/FLGZjqHqpMaAXNd74fl8wcZtghNl2f31omehv8Zg5XWpsLAqgknryjq7HgrS3BQzA
         qMZVQic8p9Q08qckqtlCphS+6qZO7CmB3XvQ0rE2wL6osk/o+k2bVI8uE5bsti5GSIXs
         lypEQwVNbt7h17qWFhvUAIIgLuTpYNSqneVXNeabxkJ3aAcOjZfe2/sS3JWnMh5453Uq
         xcpc9vhEVc8vZpoBzl1F0mFd/iL8GekwODafqlM1+vbJ2oPuKYKhgkYLh+KvgpJGXT0M
         kcPw==
X-Gm-Message-State: APjAAAVs09HoPDFWofICatQY9KElL8tw0J7eYXeZkjqwZTU3k+dqYByL
        FeplP1DoZQSAa6nXfviihEHvwSEzizI=
X-Google-Smtp-Source: APXvYqwHJOST4bS0PHVSJhIB31DUBNaEZnoGP2a53WCngnmc1CmReC//UcCZPgBUyNAfz6+7VY0jMg==
X-Received: by 2002:a62:fb18:: with SMTP id x24mr69919488pfm.76.1560104273621;
        Sun, 09 Jun 2019 11:17:53 -0700 (PDT)
Received: from shekhar.domain.name ([117.200.145.68])
        by smtp.gmail.com with ESMTPSA id w190sm8041188pgw.51.2019.06.09.11.17.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 11:17:53 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v6 1/2]tests: py: conversion to python3
Date:   Sun,  9 Jun 2019 23:47:38 +0530
Message-Id: <20190609181738.10074-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch converts the 'nft-test.py' file to run on both python 2 and python3.

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
The version hystory of this patch is:
v1:conversion to py3 by changing the print statements.
v2:add the '__future__' package for compatibility with py2 and py3.
v3:solves the 'version' problem in argparse by adding a new argument.
v4:uses .format() method to make print statements clearer.
v5:updated the shebang and corrected the sequence of import statements.
v6:resent the same with small changes

 tests/py/nft-test.py | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 09d00dba..4e18ae54 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/python
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
@@ -1016,9 +1017,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
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
@@ -1358,6 +1359,10 @@ def main():
     parser.add_argument('-s', '--schema', action='store_true',
                         dest='enable_schema',
                         help='verify json input/output against schema')
+	
+    parser.add_argument('-v', '--version', action='version',
+                        version='1.0',
+                        help='print the version information')
 
     args = parser.parse_args()
     global debug_option, need_fix_option, enable_json_option, enable_json_schema
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
@@ -1434,18 +1439,15 @@ def main():
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

