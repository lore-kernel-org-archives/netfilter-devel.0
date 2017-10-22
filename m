From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v3] tests: xlate: print output in same way as nft-test.py
Date: Sun, 22 Oct 2017 18:19:09 +0530
Message-ID: <20171022124909.597-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:54728 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbdJVMtf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Oct 2017 08:49:35 -0400
Received: by mail-pf0-f196.google.com with SMTP id n89so15174614pfk.11
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Oct 2017 05:49:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print errors and total no. of tests, tests passed, failed and errors for
testfile argument
Remove option "--all"
Print file names for which all tests are passed with OK
For e.g -
sudo ./xlate-test.py
generic.txlate: OK
libip6t_DNAT.txlate: OK
...
libxt_TCPMSS.txlate: Fail
src: iptables-translate -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j
TCPMSS --clamp-mss-to-pmtu
exp: nft add rule ip filter FORWARD tcp flags & (syn|rst) == syn counter
tcp option maxseg size set rt mtu
res: nft # -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS
--clamp-mss-to-pmtu
...
libxt_connlabel.txlate: Error: iptables-translate failure
iptables-translate v1.6.1: Couldn't load match `connlabel':No such file
or directory
...
64 test files, 246 tests, 242 tests passed, 2 tests failed, 2 errors

sudo ./xlate-test.py extensions/libxt_iprange.txlate
1 test file, 5 tests, 5 tests passed, 0 tests failed, 0 errors

sudo ./xlate-test.py extensions/libxt_connlabel.txlate
extensions/libxt_connlabel.txlate: Error: iptables-translate failure
iptables-translate v1.6.1: Couldn't load match `connlabel':No such file
or directory
...
1 test file, 2 tests, 0 tests passed, 0 tests failed, 2 errors

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v3:
 -Change subject and log message
 -Remove option "all" and other changes
Changes in v2:
 -Change log message
 -Remove changes from testfile argument

 xlate-test.py | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index 43c4be19..53b035c7 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -9,7 +9,6 @@ from subprocess import Popen, PIPE
 
 keywords = ("iptables-translate", "ip6tables-translate")
 
-
 if sys.stdout.isatty():
     colors = {"magenta": "\033[95m", "green": "\033[92m", "yellow": "\033[93m",
               "red": "\033[91m", "end": "\033[0m"}
@@ -35,41 +34,56 @@ def green(string):
 
 def run_test(name, payload):
     test_passed = True
+    tests = passed = failed = errors = 0
     result = []
-    result.append(yellow("## " + name.replace(".txlate", "")))
 
     for line in payload:
         if line.startswith(keywords):
+            tests += 1
             process = Popen(shlex.split(line), stdout=PIPE, stderr=PIPE)
             (output, error) = process.communicate()
             if process.returncode == 0:
                 translation = output.decode("utf-8").rstrip(" \n")
                 expected = next(payload).rstrip(" \n")
                 if translation != expected:
-                    result.append(red("Fail"))
+                    test_passed = False
+                    failed += 1
+                    result.append(name + ": " + red("Fail"))
                     result.append(magenta("src: ") + line.rstrip(" \n"))
                     result.append(magenta("exp: ") + expected)
                     result.append(magenta("res: ") + translation + "\n")
                     test_passed = False
-                elif args.all:
-                    result.append(green("Ok"))
-                    result.append(magenta("src: ") + line.rstrip(" \n"))
-                    result.append(magenta("res: ") + translation + "\n")
+                else:
+                    passed += 1
             else:
                 test_passed = False
-                result.append(red("Error: ") + "iptables-translate failure")
+                errors += 1
+                result.append(name + ": " + red("Error: ") + "iptables-translate failure")
                 result.append(error.decode("utf-8"))
-
-    if not test_passed or args.all:
+    if (passed == tests) and not args.test:
+        print(name + ": " + green("OK"))
+    if not test_passed:
         print("\n".join(result))
+    if args.test:
+        print("1 test file, %d tests, %d tests passed, %d tests failed, %d errors" % (tests, passed, failed, errors))
+    else:
+        return tests, passed, failed, errors
 
 
 def load_test_files():
+    test_files = total_tests = total_passed = total_error = total_failed = 0
     for test in sorted(os.listdir("extensions")):
         if test.endswith(".txlate"):
             with open("extensions/" + test, "r") as payload:
-                run_test(test, payload)
+                tests, passed, failed, errors = run_test(test, payload)
+                test_files += 1
+                total_tests += tests
+                total_passed += passed
+                total_failed += failed
+                total_error += errors
+
 
+    print("%d test files, %d tests, %d tests passed, %d tests failed, %d errors" % (test_files, total_tests, total_passed, total_failed, total_error))
 
 def main():
     if os.getuid() != 0:
@@ -78,7 +92,7 @@ def main():
         if not args.test.endswith(".txlate"):
             args.test += ".txlate"
         try:
-            with open("extensions/" + args.test, "r") as payload:
+            with open(args.test, "r") as payload:
                 run_test(args.test, payload)
         except IOError:
             print(red("Error: ") + "test file does not exist")
@@ -87,7 +101,6 @@ def main():
 
 
 parser = argparse.ArgumentParser()
-parser.add_argument("--all", action="store_true", help="show also passed tests")
 parser.add_argument("test", nargs="?", help="run only the specified test file")
 args = parser.parse_args()
 main()
-- 
2.11.0

