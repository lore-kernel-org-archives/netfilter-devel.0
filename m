From: Ana Rey Botello <ana@soleta.eu>
Subject: [nft v2 2/2] tests: regression: Add counters support
Date: Mon, 26 Jan 2015 20:43:32 +0100
Message-ID: <ed618d875791ba89bc32fcaa840b8a4fb6879da2.1422299750.git.ana@soleta.eu>
References: <cover.1422299627.git.ana@soleta.eu>
Cc: Ana Rey <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:47442 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbbAZTm6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:42:58 -0500
In-Reply-To: <cover.1422299627.git.ana@soleta.eu>
In-Reply-To: <cover.1422299750.git.ana@soleta.eu>
References: <cover.1422299750.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ana Rey <ana@soleta.eu>

This adds the accounter support into this regression test and the test
file ip/counter.c.

Signed-off-by: Ana Rey Botello <ana@soleta.eu>
---
 tests/regression/ip/counter.t |   15 ++++++
 tests/regression/nft-test.py  |  110 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)
 create mode 100644 tests/regression/ip/counter.t

diff --git a/tests/regression/ip/counter.t b/tests/regression/ip/counter.t
new file mode 100644
index 0000000..783b433
--- /dev/null
+++ b/tests/regression/ip/counter.t
@@ -0,0 +1,15 @@
+*ip;test-ip4
+*inet;test-inet
+:input;type filter hook input priority 0
+
+> counter1;ok
+> counter2;ok
+> counter3;ok
+
+ip daddr 192.168.0.1 counter name counter1;ok;ip daddr 192.168.0.1 counter counter1
+ip daddr 192.168.0.2 counter name counter1;ok;ip daddr 192.168.0.2 counter counter1
+
+ip daddr 192.168.0.1 counter name counter2;ok;ip daddr 192.168.0.1 counter counter2
+ip daddr 192.168.0.2 counter name counter3;ok;ip daddr 192.168.0.2 counter counter3
+
+ip daddr 192.168.0.2 counter name not-counter;fail
diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 7e5b475..ab95c27 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -27,6 +27,7 @@ log_file = None
 table_list = []
 chain_list = []
 all_set = dict()
+all_counter = dict()
 signal_received = 0
 
 
@@ -404,6 +405,81 @@ def set_check_element(rule1, rule2):
     return ret
 
 
+def counter_add(counter_info, table_list, filename, lineno):
+    '''
+    Adds an counter.
+    '''
+
+    if not table_list:
+        reason = "Missing table to add rule"
+        print_error(reason, filename, lineno)
+        return -1
+
+    for table in table_list:
+        if counter_exist(counter_info[0], table, filename, lineno):
+            reason = "This counter " + counter_info + " exists in " + \
+                table[1] + ". I cannot add it again"
+            print_error(reason, filename, lineno)
+            return -1
+
+        table_info = " " + table[0] + " " + table[1] + " "
+        counter_text = " " + counter_info[0]
+        cmd = "nft add counter" + table_info + counter_text
+        ret = execute_cmd(cmd, filename, lineno)
+
+        if (ret == 0 and counter_info[1].rstrip() == "fail") or \
+           (ret != 0 and counter_info[1].rstrip() == "ok"):
+                reason = cmd + ": " + "I cannot add the counter " + \
+                         counter_info[0]
+                print_error(reason, filename, lineno)
+                return -1
+
+        if not counter_exist(counter_info[0], table, filename, lineno):
+            reason = "I have just added the counter " + counter_info[0] + \
+                " to the table " + table[1] + " but it does not exist"
+            print_error(reason, filename, lineno)
+            return -1
+
+    return 0
+
+
+def counter_delete(all_counter, table, filename=None, lineno=None):
+    '''
+    Deletes counter and its content.
+    '''
+
+    for counter_name in all_counter.keys():
+        # Check if exists the counter
+        if not counter_exist(counter_name, table, filename, lineno):
+            reason = "The counter " + counter_name + \
+                " does not exist, I cannot delete it"
+            print_error(reason, filename, lineno)
+            return -1
+
+        # We delete the counter.
+        table_info = " " + table[0] + " " + table[1] + " "
+        cmd = "nft delete counter " + table_info + " " + counter_name
+        ret = execute_cmd(cmd, filename, lineno)
+        # Check if the counter still exists after I deleted it.
+        if ret != 0 or counter_exist(counter_name, table, filename, lineno):
+            reason = "Cannot remove the counter " + counter_name
+            print_error(reason, filename, lineno)
+            return -1
+
+    return 0
+
+
+def counter_exist(counter_name, table, filename, lineno):
+    '''
+    Check if the counter exists.
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+    cmd = "nft list counter" + table_info + counter_name
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+
 def output_clean(pre_output, chain):
     pos_chain = pre_output[0].find(chain)
     if pos_chain == -1:
@@ -527,6 +603,8 @@ def cleanup_on_exit():
             ret = chain_delete(chain, table, "", "")
         if all_set:
             ret = set_delete(all_set, table)
+        if all_counter:
+            ret = counter_delete(all_counter, table)
         ret = table_delete(table)
 
 
@@ -619,6 +697,19 @@ def set_element_process(element_line, filename, lineno):
                             table_list, filename, lineno)
 
 
+def counter_process(counter_line, filename, lineno):
+    counter_info = []
+    counter_name = counter_line.split(";")[0]
+    counter_info.append(counter_name)
+    counter_state = counter_line.split(";")[1]  # ok or fail
+    counter_info.append(counter_state)
+    ret = counter_add(counter_info, table_list, filename, lineno)
+    if ret == 0:
+        all_counter[counter_name] = set()
+
+    return ret
+
+
 def run_test_file(filename, force_all_family_option, specific_file):
     '''
     Runs a test file
@@ -674,6 +765,16 @@ def run_test_file(filename, force_all_family_option, specific_file):
             passed += 1
             continue
 
+        if line[0] == ">":  # Adds this counter
+            counter_line = line[1:].strip()
+            ret = counter_process(counter_line, filename, lineno)
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
@@ -729,6 +830,14 @@ def run_test_file(filename, force_all_family_option, specific_file):
                 reason = "There is a problem when we delete a set"
                 print_error(reason, filename, lineno)
 
+        # We delete counter.
+        if all_counter:
+            ret = counter_delete(all_counter, table, filename, lineno)
+            if ret != 0:
+                total_test_passed = False
+                reason = "There is a problem when we delete an counter"
+                print_error(reason, filename, lineno)
+
         # We delete tables.
         ret = table_delete(table, filename, lineno)
 
@@ -749,6 +858,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
     del table_list[:]
     del chain_list[:]
     all_set.clear()
+    all_counter.clear()
 
     return [tests, passed, total_warning, total_error, total_unit_run]
 
-- 
1.7.10.4

