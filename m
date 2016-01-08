From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft v2 1/6] tests/py: remove unused variables
Date: Fri,  8 Jan 2016 21:51:49 +0100
Message-ID: <1452286314-17406-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36439 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492AbcAHUwg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 15:52:36 -0500
Received: by mail-wm0-f68.google.com with SMTP id l65so17543310wmf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Jan 2016 12:52:36 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only that. The script had a lot of unused variables.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
Changes in v2:
    Remove forgotten line    
    
 tests/py/nft-test.py | 38 ++++++++------------------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index e68087f..77df7f6 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -19,7 +19,6 @@ import subprocess
 import argparse
 import signal
 
-TERMINAL_PATH = os.getcwd()
 NFT_BIN = "src/nft"
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
@@ -68,7 +67,7 @@ def print_differences_warning(filename, lineno, rule1, rule2, cmd):
         "line: " + str(lineno + 1) + ": '" + cmd + "': " + reason
 
 
-def print_differences_error(filename, lineno, output, cmd):
+def print_differences_error(filename, lineno, cmd):
     reason = "Listing is broken."
     print filename + ": " + Colors.RED + "ERROR: " + Colors.ENDC + \
         "line: " + str(lineno + 1) + ": '" + cmd + "': " + reason
@@ -89,7 +88,7 @@ def table_flush(table, filename, lineno):
     Flush a table.
     '''
     cmd = NFT_BIN + " flush table " + str(table[0]) + " " + str(table[1])
-    ret = execute_cmd(cmd, filename, lineno)
+    execute_cmd(cmd, filename, lineno)
 
     return cmd
 
@@ -453,8 +452,6 @@ def payload_check_set_elems(want, got):
 def payload_check(payload_buffer, file, cmd):
 
     file.seek(0, 0)
-
-    ret = False
     i = 0
 
     for lineno, want_line in enumerate(payload_buffer):
@@ -511,7 +508,6 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
             unit_tests += 1
             table_flush(table, filename, lineno)
             table_info = " " + table[0] + " " + table[1] + " "
-            cmd = NFT_BIN + " add rule" + table_info + chain + " " + rule[0]
 
             payload_log = os.tmpfile();
 
@@ -583,7 +579,7 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
                             if len(rule_output) <= 0:
                                 error += 1
                                 print_differences_error(filename, lineno,
-                                                        rule_output, cmd)
+                                                        cmd)
                                 if not force_all_family_option:
                                     return [ret, warning, error, unit_tests]
 
@@ -605,10 +601,10 @@ def preexec():
 def cleanup_on_exit():
     for table in table_list:
         for chain in chain_list:
-            ret = chain_delete(chain, table, "", "")
+            chain_delete(chain, table, "", "")
         if all_set:
-            ret = set_delete(all_set, table)
-        ret = table_delete(table)
+            set_delete(all_set, table)
+        table_delete(table)
 
 
 def signal_handler(signal, frame):
@@ -711,7 +707,6 @@ def payload_find_expected(payload_log, rule):
     :param rule: nft rule we are going to add
     '''
     found = 0
-    pos = 0
     payload_buffer = []
 
     while True:
@@ -740,16 +735,9 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
     :param filename: name of the file with the test rules
     '''
-
-    if specific_file:
-        filename_path = os.path.join(TERMINAL_PATH, filename)
-    else:
-        filename_path = os.path.join(TESTS_PATH, filename)
-
+    filename_path = os.path.join(TESTS_PATH, filename)
     f = open(filename_path)
     tests = passed = total_unit_run = total_warning = total_error = 0
-    table = ""
-    total_test_passed = True
 
     for lineno, line in enumerate(f):
         if signal_received == 1:
@@ -767,7 +755,6 @@ def run_test_file(filename, force_all_family_option, specific_file):
             table_line = line.rstrip()[1:]
             ret = table_process(table_line, filename, lineno)
             if (ret != 0):
-                total_test_passed = False
                 break
             continue
 
@@ -775,7 +762,6 @@ def run_test_file(filename, force_all_family_option, specific_file):
             chain_line = line.rstrip()[1:].split(";")
             ret = chain_process(chain_line, filename, lineno)
             if ret != 0:
-                total_test_passed = False
                 break
             continue
 
@@ -784,7 +770,6 @@ def run_test_file(filename, force_all_family_option, specific_file):
             ret = set_process(set_line, filename, lineno)
             tests += 1
             if ret == -1:
-                total_test_passed = False
                 continue
             passed += 1
             continue
@@ -794,7 +779,6 @@ def run_test_file(filename, force_all_family_option, specific_file):
             ret = set_element_process(element_line, filename, lineno)
             tests += 1
             if ret == -1:
-                total_test_passed = False
                 continue
 
             passed += 1
@@ -825,7 +809,6 @@ def run_test_file(filename, force_all_family_option, specific_file):
         total_unit_run += result[3]
 
         if ret != 0:
-            total_test_passed = False
             continue
 
         if warning == 0:  # All ok.
@@ -837,21 +820,16 @@ def run_test_file(filename, force_all_family_option, specific_file):
         for chain in chain_list:
             ret = chain_delete(chain, table, filename, lineno)
             if ret != 0:
-                total_test_passed = False
 
         # We delete sets.
         if all_set:
             ret = set_delete(all_set, table, filename, lineno)
             if ret != 0:
-                total_test_passed = False
                 reason = "There is a problem when we delete a set"
                 print_error(reason, filename, lineno)
 
         # We delete tables.
-        ret = table_delete(table, filename, lineno)
-
-        if ret != 0:
-            total_test_passed = False
+        table_delete(table, filename, lineno)
 
     if specific_file:
         if force_all_family_option:
-- 
2.7.0

