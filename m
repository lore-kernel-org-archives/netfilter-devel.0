From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests: py: Add option --all to nft-test.py
Date: Fri, 13 Oct 2017 02:25:13 +0530
Message-ID: <20171012205513.23216-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:47407 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdJLU5n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2017 16:57:43 -0400
Received: by mail-pf0-f196.google.com with SMTP id z11so6621518pfk.4
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Oct 2017 13:57:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add option --all to take all tests from files, place them in a temp
file and then run all tests in one go printing all errors and warnings.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/py/nft-test.py | 161 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 97 insertions(+), 64 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 9ad9771..f2165ba 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -18,6 +18,7 @@ import os
 import subprocess
 import argparse
 import signal
+import glob
 
 NFT_BIN = os.getenv('NFT', "src/nft")
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
@@ -157,27 +158,26 @@ def table_create(table, filename, lineno):
     if table_exist(table, filename, lineno):
         reason = "Table " + table.name + " already exists"
         print_error(reason, filename, lineno)
-        return -1
-
-    table_list.append(table)
+    else:
+        table_list.append(table)
 
-    # We add a new table
-    cmd = NFT_BIN + " add table " + table.family + " " + table.name
-    ret = execute_cmd(cmd, filename, lineno)
+        # We add a new table
+        cmd = NFT_BIN + " add table " + table.family + " " + table.name
+        ret = execute_cmd(cmd, filename, lineno)
 
-    if ret != 0:
-        reason = "Cannot add table " + table.name
-        print_error(reason, filename, lineno)
-        table_list.remove(table)
-        return -1
+        if ret != 0:
+            reason = "Cannot add table " + table.name
+            print_error(reason, filename, lineno)
+            table_list.remove(table)
+            return -1
 
-    # We check if table was added correctly.
-    if not table_exist(table, filename, lineno):
-        table_list.remove(table)
-        reason = "I have just added the table " + table.name + \
-                 " but it does not exist. Giving up!"
-        print_error(reason, filename, lineno)
-        return -1
+        # We check if table was added correctly.
+        if not table_exist(table, filename, lineno):
+            table_list.remove(table)
+            reason = "I have just added the table " + table.name + \
+                     " but it does not exist. Giving up!"
+            print_error(reason, filename, lineno)
+            return -1
 
     for table_chain in table.chains:
         chain = chain_get_by_name(table_chain)
@@ -201,21 +201,21 @@ def table_delete(table, filename=None, lineno=None):
         reason = "Table " + table.name + \
                  " does not exist but I added it before."
         print_error(reason, filename, lineno)
-        return -1
 
-    cmd = NFT_BIN + " delete table" + table_info
-    ret = execute_cmd(cmd, filename, lineno)
-    if ret != 0:
-        reason = cmd + ": " + "I cannot delete table '" + table.name + \
-                 "'. Giving up! "
-        print_error(reason, filename, lineno)
-        return -1
+    else:
+        cmd = NFT_BIN + " delete table" + table_info
+        ret = execute_cmd(cmd, filename, lineno)
+        if ret != 0:
+            reason = cmd + ": " + "I cannot delete table '" + table.name + \
+                     "'. Giving up! "
+            print_error(reason, filename, lineno)
+            return -1
 
-    if table_exist(table, filename, lineno):
-        reason = "I have just deleted the table " + table.name + \
-                 " but the table still exists."
-        print_error(reason, filename, lineno)
-        return -1
+        if table_exist(table, filename, lineno):
+            reason = "I have just deleted the table " + table.name + \
+                     " but the table still exists."
+            print_error(reason, filename, lineno)
+            return -1
 
     return 0
 
@@ -241,22 +241,22 @@ def chain_create(chain, table, filename):
         reason = "This chain '" + chain.name + "' exists in " + table.name + \
                  ". I cannot create two chains with same name."
         print_error(reason, filename, chain.lineno)
-        return -1
 
-    cmd = NFT_BIN + " add chain" + table_info + chain.name + \
+    else:
+        cmd = NFT_BIN + " add chain" + table_info + chain.name + \
           "\{ " + chain.config + "\; \}"
 
-    ret = execute_cmd(cmd, filename, chain.lineno)
-    if ret != 0:
-        reason = "I cannot create the chain '" + chain.name
-        print_error(reason, filename, chain.lineno)
-        return -1
+        ret = execute_cmd(cmd, filename, chain.lineno)
+        if ret != 0:
+            reason = "I cannot create the chain '" + chain.name
+            print_error(reason, filename, chain.lineno)
+            return -1
 
-    if not chain_exist(chain, table, filename):
-        reason = "I have added the chain '" + chain.name + \
-                 "' but it does not exist in " + table.name
-        print_error(reason, filename, chain.lineno)
-        return -1
+            if not chain_exist(chain, table, filename):
+                reason = "I have added the chain '" + chain.name + \
+                         "' but it does not exist in " + table.name
+                print_error(reason, filename, chain.lineno)
+                return -1
 
     return 0
 
@@ -271,27 +271,27 @@ def chain_delete(chain, table, filename=None, lineno=None):
         reason = "The chain " + chain.name + " does not exists in " + \
                  table.name + ". I cannot delete it."
         print_error(reason, filename, lineno)
-        return -1
 
-    cmd = NFT_BIN + " flush chain" + table_info + chain.name
-    ret = execute_cmd(cmd, filename, lineno)
-    if ret != 0:
-        reason = "I cannot flush this chain " + chain.name
-        print_error(reason, filename, lineno)
-        return -1
+    else:
+        cmd = NFT_BIN + " flush chain" + table_info + chain.name
+        ret = execute_cmd(cmd, filename, lineno)
+        if ret != 0:
+            reason = "I cannot flush this chain " + chain.name
+            print_error(reason, filename, lineno)
+            return -1
 
-    cmd = NFT_BIN + " delete chain" + table_info + chain.name
-    ret = execute_cmd(cmd, filename, lineno)
-    if ret != 0:
-        reason = cmd + "I cannot delete this chain. DD"
-        print_error(reason, filename, lineno)
-        return -1
+        cmd = NFT_BIN + " delete chain" + table_info + chain.name
+        ret = execute_cmd(cmd, filename, lineno)
+        if ret != 0:
+            reason = cmd + "I cannot delete this chain. DD"
+            print_error(reason, filename, lineno)
+            return -1
 
-    if chain_exist(chain, table, filename):
-        reason = "The chain " + chain.name + " exists in " + table.name + \
-                 ". I cannot delete this chain"
-        print_error(reason, filename, lineno)
-        return -1
+        if chain_exist(chain, table, filename):
+            reason = "The chain " + chain.name + " exists in " + table.name + \
+                     ". I cannot delete this chain"
+            print_error(reason, filename, lineno)
+            return -1
 
     return 0
 
@@ -949,14 +949,17 @@ def payload_find_expected(payload_log, rule):
     return payload_buffer
 
 
-def run_test_file(filename, force_all_family_option, specific_file):
+def run_test_file(filename, force_all_family_option, specific_file, filename_path = ''):
     '''
     Runs a test file
 
     :param filename: name of the file with the test rules
+    :param filename_path: if filename path is explicitly defined
     '''
-    filename_path = os.path.join(TESTS_PATH, filename)
+    if (filename_path == ""):
+        filename_path = os.path.join(TESTS_PATH, filename)
     f = open(filename_path)
+
     tests = passed = total_unit_run = total_warning = total_error = 0
 
     for lineno, line in enumerate(f):
@@ -974,6 +977,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
             continue
 
         if line[0] == '*':  # Table
+
             table_line = line.rstrip()[1:]
             ret = table_process(table_line, filename, lineno)
             if ret != 0:
@@ -1102,12 +1106,18 @@ def main():
                         dest='force_all_family',
                         help='keep testing all families on error')
 
+    parser.add_argument('--all', action='store_true',
+                        dest='test_all_files',
+                        help='test all files in one go')
+
     args = parser.parse_args()
     global debug_option, need_fix_option
     debug_option = args.debug
     need_fix_option = args.need_fix_line
     force_all_family_option = args.force_all_family
+    test_all_files_option = args.test_all_files
     specific_file = False
+    filename_path = ""
 
     signal.signal(signal.SIGINT, signal_handler)
     signal.signal(signal.SIGTERM, signal_handler)
@@ -1136,6 +1146,27 @@ def main():
     if args.filename:
         file_list = [args.filename]
         specific_file = True
+    elif test_all_files_option:
+
+        with open('/tmp/newfile', 'wb') as tmp_test:
+            for directory in TESTS_DIRECTORY:
+                os.chdir(os.path.join(TESTS_PATH, directory))
+                for files in glob.glob("*.t"):
+                    with open(files) as tmp_tests:
+                        lines = tmp_tests.readlines()
+                        tmp_test.writelines(lines)
+        filename_path = '/tmp/newfile'
+        specific_file = True
+        file_list = ['/tmp/newfile']
+        with open('/tmp/newfile.payload', 'wb') as tmp_payload:
+            for directory in TESTS_DIRECTORY:
+                os.chdir(os.path.join(TESTS_PATH, directory))
+                for files in glob.glob("*.payload"):
+                    with open(files) as payloads:
+                        lines = payloads.readlines()
+                        tmp_payload.writelines(lines)
+
+
     else:
         for directory in TESTS_DIRECTORY:
             path = os.path.join(TESTS_PATH, directory)
@@ -1144,8 +1175,10 @@ def main():
                     if f.endswith(".t"):
                         file_list.append(os.path.join(directory, f))
 
+
+    os.chdir(TESTS_PATH + "/../..")
     for filename in file_list:
-        result = run_test_file(filename, force_all_family_option, specific_file)
+        result = run_test_file(filename, force_all_family_option, specific_file, filename_path)
         file_tests = result[0]
         file_passed = result[1]
         file_warnings = result[2]
-- 
2.11.0

