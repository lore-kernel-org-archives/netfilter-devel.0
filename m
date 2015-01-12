From: ana@soleta.eu
Subject: [nft 2/2] tests: regression: Accounter support
Date: Mon, 12 Jan 2015 11:55:54 +0100
Message-ID: <bacb980be5880837bf3ceb02b5d5975f85e12d13.1421059193.git.ana@soleta.eu>
References: <cover.1421059192.git.ana@soleta.eu>
Cc: Ana Rey <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:46823 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbbALLEC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:04:02 -0500
In-Reply-To: <cover.1421059192.git.ana@soleta.eu>
In-Reply-To: <cover.1421059192.git.ana@soleta.eu>
References: <cover.1421059192.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ana Rey <ana@soleta.eu>

This adds the accounter support into this regression test and the test
file ip/acct.c.

Signed-off-by: Ana Rey Botello <ana@soleta.eu>
---
 tests/regression/ip/acct.t   |   17 +++++++
 tests/regression/nft-test.py |  112 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+)
 create mode 100644 tests/regression/ip/acct.t

diff --git a/tests/regression/ip/acct.t b/tests/regression/ip/acct.t
new file mode 100644
index 0000000..2193da2
--- /dev/null
+++ b/tests/regression/ip/acct.t
@@ -0,0 +1,17 @@
+*ip;test-ip4
+*inet;test-inet
+:input;type filter hook input priority 0
+
+> acct1;ok
+> acct2;ok
+> acct3;ok
+
+ip daddr 192.168.0.1 acct acct1;ok
+ip daddr 192.168.0.1 acct acct1;ok
+ip daddr 192.168.0.2 acct acct1;ok
+
+ip daddr 192.168.0.1 acct acct2;ok
+ip daddr 192.168.0.1 acct acct2;ok
+ip daddr 192.168.0.2 acct acct3;ok
+
+ip daddr 192.168.0.2 acct not-acct;fail
diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 7e5b475..4b2b1cb 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -27,6 +27,7 @@ log_file = None
 table_list = []
 chain_list = []
 all_set = dict()
+all_acct = dict()
 signal_received = 0
 
 
@@ -403,6 +404,83 @@ def set_check_element(rule1, rule2):
             ret = 0
     return ret
 
+##
+def acct_add(acct_info, table_list, filename, lineno):
+    '''
+    Adds an acct.
+    '''
+
+    if not table_list:
+        reason = "Missing table to add rule"
+        print_error(reason, filename, lineno)
+        return -1
+
+    for table in table_list:
+        if acct_exist(acct_info[0], table, filename, lineno):
+            reason = "This acct " + acct_info + " exists in " + table[1] + \
+                ". I cannot add it again"
+            print_error(reason, filename, lineno)
+            return -1
+
+        table_info = " " + table[0] + " " + table[1] + " "
+        acct_text = " " + acct_info[0]
+        cmd = "nft add acct" + table_info + acct_text
+        ret = execute_cmd(cmd, filename, lineno)
+
+        if (ret == 0 and acct_info[1].rstrip() == "fail") or \
+           (ret != 0 and acct_info[1].rstrip() == "ok"):
+                reason = cmd + ": " + "I cannot add the acct " + acct_info[0]
+                print_error(reason, filename, lineno)
+                return -1
+
+        if not acct_exist(acct_info[0], table, filename, lineno):
+            reason = "I have just added the acct " + acct_info[0] + \
+                " to the table " + table[1] + " but it does not exist"
+            print_error(reason, filename, lineno)
+            return -1
+
+    return 0
+
+
+def acct_delete(all_acct, table, filename=None, lineno=None):
+    '''
+    Deletes acct and its content.
+    '''
+
+    for acct_name in all_acct.keys():
+        # Check if exists the acct
+        if not acct_exist(acct_name, table, filename, lineno):
+            reason = "The acct " + acct_name + \
+                " does not exist, I cannot delete it"
+            print_error(reason, filename, lineno)
+            return -1
+
+        # We delete the acct.
+        table_info = " " + table[0] + " " + table[1] + " "
+        cmd = "nft delete acct " + table_info + " " + acct_name
+        ret = execute_cmd(cmd, filename, lineno)
+        # Check if the acct still exists after I deleted it.
+        if ret != 0 or acct_exist(acct_name, table, filename, lineno):
+            reason = "Cannot remove the acct " + acct_name
+            print_error(reason, filename, lineno)
+            return -1
+
+    return 0
+
+
+def acct_exist(acct_name, table, filename, lineno):
+    '''
+    Check if the acct exists.
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+    cmd = "nft list acct" + table_info + acct_name
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+##
+
+
 
 def output_clean(pre_output, chain):
     pos_chain = pre_output[0].find(chain)
@@ -527,6 +605,8 @@ def cleanup_on_exit():
             ret = chain_delete(chain, table, "", "")
         if all_set:
             ret = set_delete(all_set, table)
+        if all_acct:
+            ret = acct_delete(all_acct, table)
         ret = table_delete(table)
 
 
@@ -619,6 +699,19 @@ def set_element_process(element_line, filename, lineno):
                             table_list, filename, lineno)
 
 
+def acct_process(acct_line, filename, lineno):
+    acct_info = []
+    acct_name = acct_line.split(";")[0]
+    acct_info.append(acct_name)
+    acct_state = acct_line.split(";")[1] # ok or fail
+    acct_info.append(acct_state)
+    ret = acct_add(acct_info, table_list, filename, lineno)
+    if ret == 0:
+        all_acct[acct_name] = set()
+
+    return ret
+
+
 def run_test_file(filename, force_all_family_option, specific_file):
     '''
     Runs a test file
@@ -674,6 +767,16 @@ def run_test_file(filename, force_all_family_option, specific_file):
             passed += 1
             continue
 
+        if line[0] == ">":  # Adds this acct
+            acct_line = line[1:].strip()
+            ret = acct_process(acct_line, filename, lineno)
+            tests += 1
+            if ret == -1:
+                total_test_passed = False
+                continue
+            passed += 1
+            continue
+
         if line[0] == "?":  # Adds elements in a set
             element_line = line.rstrip()[1:].split(";")
             ret = set_element_process(element_line, filename, lineno)
@@ -729,6 +832,14 @@ def run_test_file(filename, force_all_family_option, specific_file):
                 reason = "There is a problem when we delete a set"
                 print_error(reason, filename, lineno)
 
+        # We delete acct.
+        if all_acct:
+            ret = acct_delete(all_acct, table, filename, lineno)
+            if ret != 0:
+                total_test_passed = False
+                reason = "There is a problem when we delete an acct"
+                print_error(reason, filename, lineno)
+
         # We delete tables.
         ret = table_delete(table, filename, lineno)
 
@@ -749,6 +860,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
     del table_list[:]
     del chain_list[:]
     all_set.clear()
+    all_acct.clear()
 
     return [tests, passed, total_warning, total_error, total_unit_run]
 
-- 
1.7.10.4

