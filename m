From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 1/2] tests: xlate: remove python 3.5 dependency
Date: Wed, 19 Apr 2017 01:19:08 +0200
Message-ID: <1492557549-578-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32909 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937056AbdDSQCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 12:02:04 -0400
Received: by mail-wr0-f196.google.com with SMTP id l28so3808937wre.0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 09:02:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit replaces subprocess.run (introduced in python 3.5) with
subprocess.Popen (supported since the first version of python 3).

Furthermore, the output has been improved when ip[6]tables-translate
exits with non-zero return code.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 xlate-test.py | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 006289f..37760e9 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -4,8 +4,8 @@
 import os
 import sys
 import shlex
-import subprocess
 import argparse
+from subprocess import Popen, PIPE
 
 keywords = ("iptables-translate", "ip6tables-translate")
 
@@ -40,19 +40,25 @@ def run_test(name, payload):
 
     for line in payload:
         if line.startswith(keywords):
-            output = subprocess.run(shlex.split(line), stdout=subprocess.PIPE)
-            translation = output.stdout.decode("utf-8").rstrip(" \n")
-            expected = next(payload).rstrip(" \n")
-            if translation != expected:
-                result.append(red("Fail"))
-                result.append(magenta("src: ") + line.rstrip(" \n"))
-                result.append(magenta("exp: ") + expected)
-                result.append(magenta("res: ") + translation + "\n")
+            process = Popen(shlex.split(line), stdout=PIPE, stderr=PIPE)
+            (output, error) = process.communicate()
+            if process.returncode == 0:
+                translation = output.decode("utf-8").rstrip(" \n")
+                expected = next(payload).rstrip(" \n")
+                if translation != expected:
+                    result.append(red("Fail"))
+                    result.append(magenta("src: ") + line.rstrip(" \n"))
+                    result.append(magenta("exp: ") + expected)
+                    result.append(magenta("res: ") + translation + "\n")
+                    test_passed = False
+                elif args.all:
+                    result.append(green("Ok"))
+                    result.append(magenta("src: ") + line.rstrip(" \n"))
+                    result.append(magenta("res: ") + translation + "\n")
+            else:
                 test_passed = False
-            elif args.all:
-                result.append(green("Ok"))
-                result.append(magenta("src: ") + line.rstrip(" \n"))
-                result.append(magenta("res: ") + translation + "\n")
+                result.append(red("Error: ") + "iptables-translate failure")
+                result.append(error.decode("utf-8"))
 
     if not test_passed or args.all:
         print("\n".join(result))
-- 
2.1.4

