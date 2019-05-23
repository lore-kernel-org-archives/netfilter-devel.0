Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B028EC282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 18:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 785192075E
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 18:26:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBgtdeu4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731320AbfEWS0k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 14:26:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36757 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731237AbfEWS0j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 14:26:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id a3so3567003pgb.3
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 11:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hNg4yN5dgryhpqLUK995T0t0u8ISiI0ZvJw7rHNOeYI=;
        b=cBgtdeu4oHsKyl3FwLvCXsc3qTNF1gke6GO4BV4i6KAcfthQOBxVASAvF+5oYvOY19
         rYyPCQ4AshX5nN5zYN3ub0zEZC/jJnvZ5YFGD1mF9y5iF8leEiGMZm3QxfVOchPsrdhc
         t3vFRt2+iaGMhxfy0FM313MdGTScBA8r6y+C5TkZS+vbHsa3S7wHyIHimwvAIAA7a7AU
         ULEQNvf7INWwokuz8rWx73J593ZCn89aJCJm0f0uF3kAd6Ze5LfaDEOsZhgfrGDChrn3
         Ne/hc47rZyinXnB/ADMnMNK2ZA1Ab8EtlCdZ47JVYH0PqUScHY/ZFnml8aU724l7pInO
         wRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hNg4yN5dgryhpqLUK995T0t0u8ISiI0ZvJw7rHNOeYI=;
        b=YsuDKtXugRTPtMnBhRnZ1pZiZRSiUGoForXruhBueJsDX60Q7pu/MRkm75hW72U8YO
         E2+0aqSShEKvcbollgwidB9HFvcJRnWvgLDJfVjyS7zPXyxji8fYMradmqNGGFCiUXQf
         RX3JVkKbD+52sBKR+WfgoFyQszzxMYk1CfJ/akTbXvs00aBTSscK0L+L6W8L2fF1I/eZ
         lLm5IKjNC3jZ1J4VOFfLxT06MQWPX5RWGVpUdo3tkE+2uj73GDvNpw8rapBUpuzyJOVV
         WeY9DCtYLqRWUHR/lhHfPQy7AcWBohQAzglqoxSdG7oWlH1iaKl8bBQN/HM6vfIeCu4V
         W78A==
X-Gm-Message-State: APjAAAUY3XbV7ZOXOgssPEm54UeTJHkTZ9dWmpQljAiGiPDye7uQNBVA
        W2EYpD/daj9+MQmuXCxjxnOHOtdypzY=
X-Google-Smtp-Source: APXvYqxJFKch7oOzANdcSwdPiii5q//z5T17iD6a8er9R9mfr/qOyVXpafKuiXwi/iqD1+OBmsOUdg==
X-Received: by 2002:aa7:980e:: with SMTP id e14mr106644569pfl.142.1558635998632;
        Thu, 23 May 2019 11:26:38 -0700 (PDT)
Received: from localhost.localdomain ([2405:204:e08c:113f:3445:8a22:76d:1471])
        by smtp.gmail.com with ESMTPSA id 135sm126186pfb.97.2019.05.23.11.26.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 11:26:37 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v4] tests: py: fix python3
Date:   Thu, 23 May 2019 23:56:22 +0530
Message-Id: <20190523182622.386876-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This version of the patch converts the file into python3 and also uses
.format() method to make the print statments cleaner.

The version history of this topic is:

v1: conversion to py3 by changing print statements.
v2: adds the '__future__' package for compatibility with py2 and py3.
v3: solves the 'version' problem in argparse by adding a new argument.
v4: uses .format() method to make the print statements cleaner.


Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 tests/py/nft-test.py | 47 ++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 1c0afd0e..ab26d08d 100755
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
@@ -436,7 +437,7 @@ def set_delete(table, filename=None, lineno=None):
     '''
     Deletes set and its content.
     '''
-    for set_name in all_set.keys():
+    for set_name in list(all_set.keys()):
         # Check if exists the set
         if not set_exist(set_name, table, filename, lineno):
             reason = "The set %s does not exist, " \
@@ -1002,9 +1003,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
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
@@ -1198,7 +1199,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
         sys.stdout.flush()
 
         if signal_received == 1:
-            print "\nSignal received. Cleaning up and Exitting..."
+            print("\nSignal received. Cleaning up and Exitting...")
             cleanup_on_exit()
             sys.exit(0)
 
@@ -1305,13 +1306,13 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
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
@@ -1322,7 +1323,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
 
 def main():
-    parser = argparse.ArgumentParser(description='Run nft tests', version='1.0')
+    parser = argparse.ArgumentParser(description='Run nft tests')
 
     parser.add_argument('filenames', nargs='*', metavar='path/to/file.t',
                         help='Run only these tests')
@@ -1341,6 +1342,10 @@ def main():
                         dest='enable_json',
                         help='test JSON functionality as well')
 
+    parser.add_argument('-v', '--version', action='version',
+                        version= '1.0',
+                        help='prints the version info.')
+
     args = parser.parse_args()
     global debug_option, need_fix_option, enable_json_option
     debug_option = args.debug
@@ -1353,15 +1358,15 @@ def main():
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
@@ -1411,18 +1416,18 @@ def main():
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
+                print("{} test files, {} files passed, {} unit tests, " \
+                      "{} total executed, {} error, {} warning"\
+                      .format(test_files, files_ok, tests, run_total, errors,
+                         warnings))
             else:
-                print "%d test files, %d files passed, %d unit tests, " \
-                      "%d error, %d warning" \
-                      % (test_files, files_ok, tests, errors, warnings)
+                print("{} test files, {} files passed, {} unit tests, " \
+                      "{} error, {} warning"\
+                      .format(test_files, files_ok, tests, errors, warnings))
 
 
 if __name__ == '__main__':
-- 
2.21.0.windows.1

