Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED942C04AAF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 20:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B350D20848
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 20:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UkW3XvCR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfERUJB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 16:09:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35693 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfERUJB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 16:09:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id t87so5306147pfa.2
        for <netfilter-devel@vger.kernel.org>; Sat, 18 May 2019 13:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W1iFZM04wX5heGEr3bVxBgB/g/8qX5oSiTRCRMgpO3A=;
        b=UkW3XvCR8tXBSPXTjNKoU6eYDsejcWH2TlLy/MA+hY5u4E9Q9qouFyAo12F98Un3Tz
         9w4U5Q+rDgvJCe6sn24uujiY2U6BzuW3BFjVFGA65qq5XpA/SKCN3vppw/gJ2kye/Z9D
         AAP7T+HpDcdaJw+hfGzLdgSShfZVjwhr+cjnJoiZxUB93I0DVlBbSBEmjPFMuPcyDF+I
         TIKhGjL3QdHrQWEiMp/29bnBpiRl9cqxzUZ17tDA50SFoospLczAPyMD/XJ4X4GqctVC
         nWwQuZ7ryD9cre5Ity3yAzAYSQa1pmmT7fOk1T5ZsKmX1iqIw/ATQR0oUH6RSSuLGy/L
         bR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W1iFZM04wX5heGEr3bVxBgB/g/8qX5oSiTRCRMgpO3A=;
        b=Uc0za1GJYHjhGQuCbAtmOQFHjge9VooQkRImcNuwcd33ztdLYMJmozxRu8Tk3ELhfB
         1bWlnX2qxWjZecnzfKXSrIZq9RHhbi4sogMkuI/SX0fFzf6C3dzCX/ieaenIArbnQY+Z
         AnlKb2XcHjLaxD+qh3XSGiXkNEnhUPfxCAI+I6QCp8t/Pv3kiGCzxBI6cIvXlsknJlhY
         EhUe6Ywfs6Aj+ygvGjC7utRgDojKPF/BAM4Jpe5b+8iKkv+wqLo8jS4neXQHk4z6ZDOG
         naITJS1WvvWfa+Z1gARzYHTrZES1iVFiSF1lgcazviI+HoUkipmnVfrnW20Q1/Nsqn5m
         slMA==
X-Gm-Message-State: APjAAAVlC3pkunoO3/3SUXTmowiS7XGldoRLbvS2z+6UZIg8gvscMb//
        xIMUeOndW4W7+sbi96ymqmPFaUwkee8=
X-Google-Smtp-Source: APXvYqxii+Y3Hjym6mv7t5g3iIPyeOjT9PVwI6OGj+lDL/F9NcRhr4Q0WOFmr571teVLkXspIZWwbQ==
X-Received: by 2002:aa7:8243:: with SMTP id e3mr70134413pfn.213.1558210139873;
        Sat, 18 May 2019 13:08:59 -0700 (PDT)
Received: from localhost.localdomain ([2409:4043:231e:7434:5c05:f7b:6150:5e06])
        by smtp.gmail.com with ESMTPSA id k192sm12372708pga.20.2019.05.18.13.08.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 13:08:59 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft v2] tests: py: fix python3.
Date:   Sun, 19 May 2019 01:38:41 +0530
Message-Id: <20190518200841.67944-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The '__future__' package has been added to nft-test.py in this patch. 
The file runs in python 2 but when I try to run it in python 3, there is a error in argparse.ArgumentParser() in line 1325 with an option '-version' , 
I suspect that '-version' is not valid in python 3 but I am not sure.

Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 tests/py/nft-test.py | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 1c0afd0e..6c122374 100755
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
@@ -22,8 +24,6 @@ import json
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
 
-from nftables import Nftables
-
 TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
 LOGFILE = "/tmp/nftables-test.log"
 log_file = None
@@ -436,7 +436,7 @@ def set_delete(table, filename=None, lineno=None):
     '''
     Deletes set and its content.
     '''
-    for set_name in all_set.keys():
+    for set_name in list(all_set.keys()):
         # Check if exists the set
         if not set_exist(set_name, table, filename, lineno):
             reason = "The set %s does not exist, " \
@@ -1002,9 +1002,9 @@ def execute_cmd(cmd, filename, lineno, stdout_log=False, debug=False):
     :param debug: temporarily set these debug flags
     '''
     global log_file
-    print >> log_file, "command: %s" % cmd
+    print("command: %s" % cmd, file= log_file)
     if debug_option:
-        print cmd
+        print(cmd)
 
     if debug:
         debug_old = nftables.get_debug()
@@ -1198,7 +1198,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
         sys.stdout.flush()
 
         if signal_received == 1:
-            print "\nSignal received. Cleaning up and Exitting..."
+            print("\nSignal received. Cleaning up and Exitting...")
             cleanup_on_exit()
             sys.exit(0)
 
@@ -1281,6 +1281,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
         total_unit_run += result[3]
 
         if ret != 0:
+
             continue
 
         if warning == 0:  # All ok.
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
@@ -1353,15 +1354,15 @@ def main():
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
@@ -1411,18 +1412,18 @@ def main():
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

