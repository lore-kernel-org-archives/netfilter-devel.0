Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285C7C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 23:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E028E2075C
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 23:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KAIGGZb9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfE0Xuf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 19:50:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33227 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfE0Xuf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 19:50:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id h17so9813312pgv.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2019 16:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=amxmzOFHoLiop7H8QBqhsWiK4+TE1dNTzMrl3sHsxmA=;
        b=KAIGGZb9OYLImnePWCRYv6Z7LDBURTz551uraKpiS8zOcVTLiwIzBHthMllR28C+iX
         EO1FPVTpFQePi5+lfVzoKL6kuBMDciYcBAh2mIsNyMUZw5J1UjC7Gne+p21f78fYZnPJ
         K6s8yS/05KBqw9pMRzf2PkI5RLRoD8Agg4LR9Usu+8G116oqSpfusO2sBuvgNMRaD1vS
         BzTbjgWVH39zrDSrFy0wljC4wajScQatZQzBg60UV4AOIW2cuWp/8KulgdC4LHo/JJe6
         //XkeXCTvByFuLHfmmztGct97sFVp6/xfyk9JkCBcA5ZiP+lpUfQwy3xB/qd+1oWbzJI
         nrMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=amxmzOFHoLiop7H8QBqhsWiK4+TE1dNTzMrl3sHsxmA=;
        b=a68XAcYBMXr2ClvqU1EPCCxQvw3aDL6PBWXWoBw+BuDb4Ti4J5CBw2fzO6moVBs63v
         HNTzTshgYbvhwNsI3EhUQnyrvVNighWgU5XFnjSfmyHAyzH9aOwnXN+lEozL6z6mMsmG
         XECB/rQZqrcoK/ACX28tE/0xs/B4+phedM0ryR1FDH4eKmtNueinJ/kYJIOn8kxdVmfa
         WvhyqwTMnuNttP2n+J3304eSXGPDmBjuTV1MWZV+7Q5xS+HCvNmkiwKYyjnjPryczw0U
         5uNGN/o5YatIiIYuth81ZuXbkrXJVIur6V4LWvdMLWujzhodMlfoWpDZYE5bmgGqLBZQ
         3N8A==
X-Gm-Message-State: APjAAAWFWtRy1NKG9dVXG00eKpXn4qsqwdufevc3i4Qaenrmut7NCbSC
        NPPHaK0DxWMGgiId6GDR/vk2Uj4p
X-Google-Smtp-Source: APXvYqx2sjForQHYtxTZInEYTULKCP29xytnn2FdtrRRWGzPDJFUPab6cgq8buYD0yNh+hlZ61jcIA==
X-Received: by 2002:a17:90a:ca09:: with SMTP id x9mr1519684pjt.105.1559001034393;
        Mon, 27 May 2019 16:50:34 -0700 (PDT)
Received: from localhost.localdomain ([2409:4043:98d:28c6:c0fb:3264:16ab:2dfa])
        by smtp.gmail.com with ESMTPSA id k3sm12641705pfa.36.2019.05.27.16.50.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 16:50:33 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v5] tests: py: fix python3
Date:   Tue, 28 May 2019 05:20:21 +0530
Message-Id: <20190527235021.6874-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch converts the 'nft-test.py' file to run on both python 2 and python3. 

The version hystory of this patch is:
v1:conversion to py3 by changing the print statements.
v2:add the '__future__' package for compatibility with py2 and py3.
v3:solves the 'version' problem in argparse by adding a new argument.
v4:uses .format() method to make print statements clearer.
v5: updated the shebang and corrected the sequence of import statements.


Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 tests/py/nft-test.py | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 1c0afd0e..fe56340c 100755
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
+    print("command: {}".format(cmd), file = log_file)
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
+                        help='prints the version information')
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
+        print("The nftables library does not exist. "
+              "You need to build the project.")
         return
 
     global nftables
@@ -1411,18 +1416,15 @@ def main():
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
+                print("{} test files, {} files passed, {} unit tests,".format(test_files, files_ok, tests))
+                print("{} total executed, {} error, {} warning".format(run_total, errors, warnings))
             else:
-                print "%d test files, %d files passed, %d unit tests, " \
-                      "%d error, %d warning" \
-                      % (test_files, files_ok, tests, errors, warnings)
+                print("{} test files, {} files passed, {} unit tests".format(test_files, files_ok, tests))
+                print("{} error, {} warning".format(errors, warnings))
 
 
 if __name__ == '__main__':
-- 
2.17.1

