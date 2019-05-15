Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0E1C04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 07:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA46E20862
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 07:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tBblgZSU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfEOHH7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 03:07:59 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:35983 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOHH7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 03:07:59 -0400
Received: by mail-pg1-f180.google.com with SMTP id a3so891152pgb.3
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 00:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YfN7qizP6QzykTGxixJJBf41xj15qbkgZNtm0L/GHMY=;
        b=tBblgZSUpYcMmwAT/TQwYHUWeTViC4vS8KZd6mPCkUgP8FdtkUvrdgGIz7Lt/UzMIW
         viCNGgVb2/+F7Lk6lJ3+Ue0BNNdDrRJhlgmoipdt8/o7EP7cwkWvmuyvQRTRvBTXMQag
         J1K9f4xLnai/CNwpamA8FKiLUs0znH5WWurmBzZ/RAkxbbdIcZnAyZHhX2UNn8Recsf9
         BvU3hPjLAHEEjyEmwe88KGmzJTe1VnkkSwqb/Dk8Nd1IrbmraGLx5wVHOq2ESYfkRh9l
         NeG1Hl9Xb7wiDHgq/ZwDtzaJYjIcE0oqevim81JHOdp0r5HVIgZlF66hsJjYVDCJvxob
         5afg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YfN7qizP6QzykTGxixJJBf41xj15qbkgZNtm0L/GHMY=;
        b=QeIDwKFvUACtS3+tCqPHhjRh2u2zsa/h89dgp8wuIe2d7tX1BOa5yWw4UsSpuGndHq
         RlHJ/6Tcunj1jWdpwe5eFa6aRQtVs9yW1deezPo5A5EmTlajPOo/0CIXVlHjlUZLJ92t
         PG3B37ffHsGBd4NVsQh754EDZ2VudnM8K61S75yMjR0Jv05qOmdCqAZBTkyA7zpR1bCx
         0ACG8vlkXYpUyHpKNYAiY2xAzHeuqdOc/GnKjgNDV/hx08OLuW+BmabpSRauRaL+1UJq
         A4Y4n8uKmgajimELizGd6zQja7pLp/rbd1jeG9Objvh1kWIB9kveK8PC1uZBC0wqXN6w
         Yizw==
X-Gm-Message-State: APjAAAXvzSAA37qxSwLhALAlf4BarsqlnN2uUgw4B1cCy5m/0g+Bb3o3
        udz7FT9dEpJ8gmFMVodg5fPhoCtiwjs=
X-Google-Smtp-Source: APXvYqzv7P1twU6lhVM7ol+6P1xAy1ehzEpgBbvlQHFgIhD6Yy5GcdKznjY4Alfs1RBBnuhRHCLkUQ==
X-Received: by 2002:a62:7d8e:: with SMTP id y136mr23459126pfc.224.1557904077840;
        Wed, 15 May 2019 00:07:57 -0700 (PDT)
Received: from localhost.localdomain ([14.139.224.146])
        by smtp.gmail.com with ESMTPSA id z9sm2479652pfj.58.2019.05.15.00.07.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 00:07:57 -0700 (PDT)
From:   Shekhar Sharma <shekhar250198@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Shekhar Sharma <shekhar250198@gmail.com>
Subject: [PATCH nft] tests: py: fix python3.
Date:   Wed, 15 May 2019 12:37:44 +0530
Message-Id: <20190515070744.47828-1-shekhar250198@gmail.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This changes all the python2 files to python3.
Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
---
 py/nftables.py              |  2 +-
 tests/json_echo/run-test.py | 40 ++++++++++++++++++-------------------
 tests/py/nft-test.py        | 32 ++++++++++++++---------------
 3 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/py/nftables.py b/py/nftables.py
index 33cd2dfd..6503aedd 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -297,7 +297,7 @@ class Nftables:
         val = self.nft_ctx_output_get_debug(self.__ctx)
 
         names = []
-        for n,v in self.debug_flags.items():
+        for n,v in linst(self.debug_flags.items()):
             if val & v:
                 names.append(n)
                 val &= ~v
diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
index 0132b139..330034a0 100755
--- a/tests/json_echo/run-test.py
+++ b/tests/json_echo/run-test.py
@@ -13,8 +13,8 @@ from nftables import Nftables
 os.chdir(TESTS_PATH + "/../..")
 
 if not os.path.exists('src/.libs/libnftables.so'):
-    print "The nftables library does not exist. " \
-          "You need to build the project."
+    print("The nftables library does not exist. " \
+          "You need to build the project.")
     sys.exit(1)
 
 nftables = Nftables(sofile = 'src/.libs/libnftables.so')
@@ -79,12 +79,12 @@ add_quota = { "add": {
 # helper functions
 
 def exit_err(msg):
-    print "Error: %s" % msg
+    print("Error: %s" % msg)
     sys.exit(1)
 
 def exit_dump(e, obj):
-    print "FAIL: %s" % e
-    print "Output was:"
+    print("FAIL: %s" % e)
+    print("Output was:")
     json.dumps(out, sort_keys = True, indent = 4, separators = (',', ': '))
     sys.exit(1)
 
@@ -118,12 +118,12 @@ def get_handle(output, search):
             else:
                 data = item
 
-            k = search.keys()[0]
+            k = list(search.keys())[0]
 
             if not k in data:
                 continue
             found = True
-            for key in search[k].keys():
+            for key in list(search[k].keys()):
                 if key == "handle":
                     continue
                 if not key in data[k] or search[k][key] != data[k][key]:
@@ -140,7 +140,7 @@ def get_handle(output, search):
 
 do_flush()
 
-print "Adding table t"
+print("Adding table t")
 out = do_command(add_table)
 handle = get_handle(out, add_table["add"])
 
@@ -152,7 +152,7 @@ if handle != handle_cmp:
 
 add_table["add"]["table"]["handle"] = handle
 
-print "Adding chain c"
+print("Adding chain c")
 out = do_command(add_chain)
 handle = get_handle(out, add_chain["add"])
 
@@ -164,7 +164,7 @@ if handle != handle_cmp:
 
 add_chain["add"]["chain"]["handle"] = handle
 
-print "Adding set s"
+print("Adding set s")
 out = do_command(add_set)
 handle = get_handle(out, add_set["add"])
 
@@ -176,7 +176,7 @@ if handle != handle_cmp:
 
 add_set["add"]["set"]["handle"] = handle
 
-print "Adding rule"
+print("Adding rule")
 out = do_command(add_rule)
 handle = get_handle(out, add_rule["add"])
 
@@ -188,7 +188,7 @@ if handle != handle_cmp:
 
 add_rule["add"]["rule"]["handle"] = handle
 
-print "Adding counter"
+print("Adding counter")
 out = do_command(add_counter)
 handle = get_handle(out, add_counter["add"])
 
@@ -200,7 +200,7 @@ if handle != handle_cmp:
 
 add_counter["add"]["counter"]["handle"] = handle
 
-print "Adding quota"
+print("Adding quota")
 out = do_command(add_quota)
 handle = get_handle(out, add_quota["add"])
 
@@ -222,37 +222,37 @@ add_set["add"]["set"]["name"] = "s2"
 add_counter["add"]["counter"]["name"] = "c2"
 add_quota["add"]["quota"]["name"] = "q2"
 
-print "Adding table t2"
+print("Adding table t2")
 out = do_command(add_table)
 handle = get_handle(out, add_table["add"])
 if handle == add_table["add"]["table"]["handle"]:
    exit_err("handle not changed in re-added table!")
 
-print "Adding chain c2"
+print("Adding chain c2")
 out = do_command(add_chain)
 handle = get_handle(out, add_chain["add"])
 if handle == add_chain["add"]["chain"]["handle"]:
    exit_err("handle not changed in re-added chain!")
 
-print "Adding set s2"
+print("Adding set s2")
 out = do_command(add_set)
 handle = get_handle(out, add_set["add"])
 if handle == add_set["add"]["set"]["handle"]:
    exit_err("handle not changed in re-added set!")
 
-print "Adding rule again"
+print("Adding rule again")
 out = do_command(add_rule)
 handle = get_handle(out, add_rule["add"])
 if handle == add_rule["add"]["rule"]["handle"]:
    exit_err("handle not changed in re-added rule!")
 
-print "Adding counter c2"
+print("Adding counter c2")
 out = do_command(add_counter)
 handle = get_handle(out, add_counter["add"])
 if handle == add_counter["add"]["counter"]["handle"]:
    exit_err("handle not changed in re-added counter!")
 
-print "Adding quota q2"
+print("Adding quota q2")
 out = do_command(add_quota)
 handle = get_handle(out, add_quota["add"])
 if handle == add_quota["add"]["quota"]["handle"]:
@@ -269,7 +269,7 @@ add_quota["add"]["quota"]["name"] = "q"
 
 do_flush()
 
-print "doing multi add"
+print("doing multi add")
 # XXX: Add table separately, otherwise this triggers cache bug
 out = do_command(add_table)
 thandle = get_handle(out, add_table["add"])
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 1c0afd0e..35c5d0e5 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
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
 
@@ -1305,13 +1305,13 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
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
@@ -1353,15 +1353,15 @@ def main():
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
@@ -1411,18 +1411,18 @@ def main():
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

