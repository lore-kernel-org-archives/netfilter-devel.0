From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] tests: xlate: print total no. of testfiles, tests and tests passed
Date: Thu, 19 Oct 2017 18:10:02 +0530
Message-ID: <20171019124002.11066-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:47322 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdJSMkh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 08:40:37 -0400
Received: by mail-pf0-f195.google.com with SMTP id z11so6505280pfk.4
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2017 05:40:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print errors and total no of tests and tests passed for testfile argument.
Print total no. of testfiles, total no. of tests and total no. of tests
passed for "all" argument.
For e.g. :
sudo ./xlate-test.py --all (adds this line in end with whole output)
64 test file, 246 tests, 242 tests passed

sudo ./xlate-test.py libxt_ipcomp.txlate
1 test file, 2 tests, 2 tests passed

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v2:
 -Change log message 
 -Remove changes for testfile argument

 xlate-test.py | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 43c4be19..97b3a903 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -9,7 +9,6 @@ from subprocess import Popen, PIPE
 
 keywords = ("iptables-translate", "ip6tables-translate")
 
-
 if sys.stdout.isatty():
     colors = {"magenta": "\033[95m", "green": "\033[92m", "yellow": "\033[93m",
               "red": "\033[91m", "end": "\033[0m"}
@@ -35,11 +34,14 @@ def green(string):
 
 def run_test(name, payload):
     test_passed = True
+    tests = 0
+    passed = 0
     result = []
     result.append(yellow("## " + name.replace(".txlate", "")))
 
     for line in payload:
         if line.startswith(keywords):
+            tests += 1
             process = Popen(shlex.split(line), stdout=PIPE, stderr=PIPE)
             (output, error) = process.communicate()
             if process.returncode == 0:
@@ -52,9 +54,12 @@ def run_test(name, payload):
                     result.append(magenta("res: ") + translation + "\n")
                     test_passed = False
                 elif args.all:
+                    passed += 1
                     result.append(green("Ok"))
                     result.append(magenta("src: ") + line.rstrip(" \n"))
                     result.append(magenta("res: ") + translation + "\n")
+                elif args.test:
+                    passed += 1
             else:
                 test_passed = False
                 result.append(red("Error: ") + "iptables-translate failure")
@@ -62,14 +67,25 @@ def run_test(name, payload):
 
     if not test_passed or args.all:
         print("\n".join(result))
+    if args.test:
+        print("1 test file, %d tests, %d tests passed" % (tests, passed))
+    else:
+        return tests, passed
 
 
 def load_test_files():
+    test_files = 0
+    total_tests = 0
+    total_passed = 0
     for test in sorted(os.listdir("extensions")):
         if test.endswith(".txlate"):
             with open("extensions/" + test, "r") as payload:
-                run_test(test, payload)
-
+                tests, passed = run_test(test, payload)
+                test_files += 1
+                total_tests += tests
+                total_passed += passed
+    if args.all:
+        print("%d test file, %d tests, %d tests passed" % (test_files, total_tests, total_passed))
 
 def main():
     if os.getuid() != 0:
-- 
2.11.0

