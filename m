Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CC4C31E4B
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 14:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4538221537
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 14:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzSJ+9PV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfFNOcB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 10:32:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34190 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfFNOcA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 10:32:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id p10so1675661pgn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 07:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=frBYPXR21JLYd4K4OHvu630SahVY3RV9GuLAlVj6lKQ=;
        b=SzSJ+9PVQC+dVcxR0wnUZt+Jg/eC1WSqVBuFcb80gDz6D0juD473Pdw2EHUcN0Fyzt
         gvzHQJHe091Z5SkZO/Lz0h2duaJXgTJwDWuuuPV3Lp7qcYI60ty/YnMShCq9zZbuii0q
         UNBzZTzcoTfbp+0tjIioNVGHW7rxWrY3UMklXodNSSBiOImjKYpvDY0Vgk1pNt72BMWv
         v6y5x5B5ik3Mc19TLQZ633J3RMDi0t8rhr1FzSjurA44b4gYaMAItCvcrn53zzQLIA9U
         aw2QxXwtardaVy8UCi/zJ/AyzhpIK5AXeeLhYg+7YV7J65pj/IUCk2Qbnh/+PUWm+kmo
         4Y0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=frBYPXR21JLYd4K4OHvu630SahVY3RV9GuLAlVj6lKQ=;
        b=Hye3oJOOKbQfgi8P1zzMYa0gb9r4CzQuO6gvR8dX5bM4R8a5HjQowPXL+SRebAsATG
         vAi7liA6VZbfaw0UOSnKIOGsvK9MPV9JqR2AuMCPzJDMLcSySAglnf+g1Udpn7ZjRokC
         Ktr5C0YtOOBhOVLdxOLH++Kg61Jz6pWNeBPGE7M6ssSX3jiTwQ9NZtqbjp6xVJgQDVjT
         jWtUD8PsZ/LY7aXXv+u83Fb8U90Le5zMmjXMH3ZmQ2qkT9RYXPbpj0zQ6xsytsFm1hEn
         773SGjY7oVL0EykZyajv12YCah7i4cJ5wKcxeduvukE92hY3Hur85m3EXMRUornFs+RO
         spQw==
X-Gm-Message-State: APjAAAXYL4qZ3H9gG/TyTgZWjAeT4wgM5iC/NazmQnuUZzp9hmuYWjNa
        8f7iu/uv8uPUBNOrVO16A5RNnPYliOY=
X-Google-Smtp-Source: APXvYqzRgXBmDGQ5fkvpar5cvjedmQxKXrYYYC34QKtOOzC+t3z25h9WJZCpAgiTYpei6RCYn0+Dbg==
X-Received: by 2002:a63:5023:: with SMTP id e35mr35014866pgb.194.1560522719444;
        Fri, 14 Jun 2019 07:31:59 -0700 (PDT)
Received: from shekhar.domain.name ([59.91.149.38])
        by smtp.gmail.com with ESMTPSA id s12sm2910557pfe.143.2019.06.14.07.31.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 07:31:59 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v7 1/2]tests:py: conversion to  python3
Date:   Fri, 14 Jun 2019 20:01:44 +0530
Message-Id: <20190614143144.10482-1-shekhar250198@gmail.com>
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
v7:resent with small changes

 tests/py/nft-test.py | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 09d00dba..f80517e6 100755
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
@@ -1434,19 +1439,16 @@ def main():
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
-            else:
-                print "%d test files, %d files passed, %d unit tests, " \
-                      "%d error, %d warning" \
-                      % (test_files, files_ok, tests, errors, warnings)
+                print("{} test files, {} files passed, {} unit tests, ".format(test_files,files_ok,tests))
+                print("{} total executed, {} error, {} warning".format(run_total, errors, warnings))
 
+            else:
+                print("{} test files, {} files passed, {} unit tests, ".format(test_files,files_ok,tests))
+                print("{} error, {} warning".format(errors, warnings))
 
 if __name__ == '__main__':
     main()
-- 
2.17.1

