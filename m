From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 4/6] tests/py: convert chains and tables to objects
Date: Mon,  4 Jan 2016 11:43:54 +0100
Message-ID: <1451904236-4481-4-git-send-email-pablombg@gmail.com>
References: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33274 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbcADKom (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 05:44:42 -0500
Received: by mail-wm0-f43.google.com with SMTP id f206so167946989wmf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 02:44:41 -0800 (PST)
In-Reply-To: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now these concepts are represented by objects instead of lists or sparse
parameters.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 tests/py/nft-test.py | 121 +++++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 53 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index f5d5d84..e379a0f 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -45,6 +45,28 @@ class Colors:
         ENDC = ''
 
 
+class Chain:
+    """Class that represents a chain"""
+
+    def __init__(self, name, config):
+        self.name = name
+        self.config = config
+
+    def __eq__(self, other):
+        return self.__dict__ == other.__dict__
+
+
+class Table:
+    """Class that represents a table"""
+
+    def __init__(self, family, name):
+        self.family = family
+        self.name = name
+
+    def __eq__(self, other):
+        return self.__dict__ == other.__dict__
+
+
 def print_msg(reason, filename=None, lineno=None, color=None, errstr=None):
     '''
     Prints a message with nice colors, indicating file and line number.
@@ -79,7 +101,7 @@ def table_exist(table, filename, lineno):
     '''
     Exists a table.
     '''
-    cmd = NFT_BIN + " list -nnn table " + table[0] + " " + table[1]
+    cmd = NFT_BIN + " list -nnn table " + table.family + " " + table.name
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -89,7 +111,7 @@ def table_flush(table, filename, lineno):
     '''
     Flush a table.
     '''
-    cmd = NFT_BIN + " flush table " + str(table[0]) + " " + str(table[1])
+    cmd = NFT_BIN + " flush table " + table.family + " " + table.name
     execute_cmd(cmd, filename, lineno)
 
     return cmd
@@ -101,18 +123,18 @@ def table_create(table, filename, lineno):
     '''
     # We check if table exists.
     if table_exist(table, filename, lineno):
-        reason = "Table " + table[1] + " already exists"
+        reason = "Table " + table.name + " already exists"
         print_error(reason, filename, lineno)
         return -1
 
     table_list.append(table)
 
     # We add a new table
-    cmd = NFT_BIN + " add table " + table[0] + " " + table[1]
+    cmd = NFT_BIN + " add table " + table.family + " " + table.name
     ret = execute_cmd(cmd, filename, lineno)
 
     if ret != 0:
-        reason = "Cannot add table " + table[1]
+        reason = "Cannot add table " + table.name
         print_error(reason, filename, lineno)
         table_list.remove(table)
         return -1
@@ -120,7 +142,7 @@ def table_create(table, filename, lineno):
     # We check if table was added correctly.
     if not table_exist(table, filename, lineno):
         table_list.remove(table)
-        reason = "I have just added the table " + table[1] + " but it does not exist. Giving up!"
+        reason = "I have just added the table " + table.name + " but it does not exist. Giving up!"
         print_error(reason, filename, lineno)
         return -1
 
@@ -131,22 +153,22 @@ def table_delete(table, filename=None, lineno=None):
     '''
     Deletes a table.
     '''
-    table_info = " " + table[0] + " " + table[1] + " "
+    table_info = " " + table.family + " " + table.name + " "
 
     if not table_exist(table, filename, lineno):
-        reason = "Table " + table[1] + " does not exist but I added it before."
+        reason = "Table " + table.name + " does not exist but I added it before."
         print_error(reason, filename, lineno)
         return -1
 
     cmd = NFT_BIN + " delete table" + table_info
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
-        reason = cmd + ": " + "I cannot delete table '" + table[1] + "'. Giving up! "
+        reason = cmd + ": " + "I cannot delete table '" + table.name + "'. Giving up! "
         print_error(reason, filename, lineno)
         return -1
 
     if table_exist(table, filename, lineno):
-        reason = "I have just deleted the table " + table[1] + " but the table still exists."
+        reason = "I have just deleted the table " + table.name + " but the table still exists."
         print_error(reason, filename, lineno)
         return -1
 
@@ -157,32 +179,30 @@ def chain_exist(chain, table, filename, lineno):
     '''
     Checks a chain
     '''
-    table_info = " " + table[0] + " " + table[1] + " "
-    cmd = NFT_BIN + " list -nnn chain" + table_info + chain
+    table_info = " " + table.family + " " + table.name + " "
+    cmd = NFT_BIN + " list -nnn chain" + table_info + chain.name
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
 
 
-def chain_create(chain, chain_type, table, filename, lineno):
+def chain_create(chain, table, filename, lineno):
     '''
     Adds a chain
     '''
-    table_info = " " + table[0] + " " + table[1] + " "
+    table_info = " " + table.family + " " + table.name + " "
 
     if chain_exist(chain, table, filename, lineno):
-        reason = "This chain '" + chain + "' exists in " + table[1] + ". I cannot create two chains with same name."
+        reason = "This chain '" + chain.name + "' exists in " + table.name + \
+                 ". I cannot create two chains with same name."
         print_error(reason, filename, lineno)
         return -1
 
-    if chain_type:
-        cmd = NFT_BIN + " add chain" + table_info + chain + "\{ " + chain_type + "\; \}"
-    else:
-        cmd = NFT_BIN + " add chain" + table_info + chain
+    cmd = NFT_BIN + " add chain" + table_info + chain.name + "\{ " + chain.config + "\; \}"
 
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
-        reason = "I cannot create the chain '" + chain
+        reason = "I cannot create the chain '" + chain.name
         print_error(reason, filename, lineno)
         return -1
 
@@ -190,7 +210,7 @@ def chain_create(chain, chain_type, table, filename, lineno):
         chain_list.append(chain)
 
     if not chain_exist(chain, table, filename, lineno):
-        reason = "I have added the chain '" + chain + "' but it does not exist in " + table[1]
+        reason = "I have added the chain '" + chain.name + "' but it does not exist in " + table.name
         print_error(reason, filename, lineno)
         return -1
 
@@ -201,21 +221,21 @@ def chain_delete(chain, table, filename=None, lineno=None):
     '''
     Flushes and deletes a chain.
     '''
-    table_info = " " + table[0] + " " + table[1] + " "
+    table_info = " " + table.family + " " + table.name + " "
 
     if not chain_exist(chain, table, filename, lineno):
-        reason = "The chain " + chain + " does not exists in " + table[1] + ". I cannot delete it."
+        reason = "The chain " + chain.name + " does not exists in " + table.name + ". I cannot delete it."
         print_error(reason, filename, lineno)
         return -1
 
-    cmd = NFT_BIN + " flush chain" + table_info + chain
+    cmd = NFT_BIN + " flush chain" + table_info + chain.name
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
-        reason = "I cannot flush this chain " + chain
+        reason = "I cannot flush this chain " + chain.name
         print_error(reason, filename, lineno)
         return -1
 
-    cmd = NFT_BIN + " delete chain" + table_info + chain
+    cmd = NFT_BIN + " delete chain" + table_info + chain.name
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = cmd + "I cannot delete this chain. DD"
@@ -223,7 +243,7 @@ def chain_delete(chain, table, filename=None, lineno=None):
         return -1
 
     if chain_exist(chain, table, filename, lineno):
-        reason = "The chain " + chain + " exists in " + table[1] + ". I cannot delete this chain"
+        reason = "The chain " + chain.name + " exists in " + table.name + ". I cannot delete this chain"
         print_error(reason, filename, lineno)
         return -1
 
@@ -241,11 +261,11 @@ def set_add(set_info, filename, lineno):
 
     for table in table_list:
         if set_exist(set_info[0], table, filename, lineno):
-            reason = "This set " + set_info + " exists in " + table[1] + ". I cannot add it again"
+            reason = "This set " + set_info + " exists in " + table.name + ". I cannot add it again"
             print_error(reason, filename, lineno)
             return -1
 
-        table_info = " " + table[0] + " " + table[1] + " "
+        table_info = " " + table.family + " " + table.name + " "
         set_text = " " + set_info[0] + " { type " + set_info[1] + " \;}"
         cmd = NFT_BIN + " add set" + table_info + set_text
         ret = execute_cmd(cmd, filename, lineno)
@@ -256,7 +276,8 @@ def set_add(set_info, filename, lineno):
             return -1
 
         if not set_exist(set_info[0], table, filename, lineno):
-            reason = "I have just added the set " + set_info[0] + " to the table " + table[1] + " but it does not exist"
+            reason = "I have just added the set " + set_info[0] + " to the table " + table.name + \
+                     " but it does not exist"
             print_error(reason, filename, lineno)
             return -1
 
@@ -279,7 +300,7 @@ def set_add_elements(set_element, set_name, state, filename, lineno):
             print_error(reason, filename, lineno)
             return -1
 
-        table_info = " " + table[0] + " " + table[1] + " "
+        table_info = " " + table.family + " " + table.name + " "
 
         element = ""
         for e in set_element:
@@ -310,7 +331,7 @@ def set_delete_elements(set_element, set_name, table, filename=None, lineno=None
     '''
     Deletes elements in a set.
     '''
-    table_info = " " + table[0] + " " + table[1] + " "
+    table_info = " " + table.family + " " + table.name + " "
 
     for element in set_element:
         set_text = set_name + " {" + element + "}"
@@ -339,7 +360,7 @@ def set_delete(table, filename=None, lineno=None):
         set_delete_elements(all_set[set_name], set_name, table, filename, lineno)
 
         # We delete the set.
-        table_info = " " + table[0] + " " + table[1] + " "
+        table_info = " " + table.family + " " + table.name + " "
         cmd = NFT_BIN + " delete set " + table_info + " " + set_name
         ret = execute_cmd(cmd, filename, lineno)
 
@@ -356,7 +377,7 @@ def set_exist(set_name, table, filename, lineno):
     '''
     Check if the set exists.
     '''
-    table_info = " " + table[0] + " " + table[1] + " "
+    table_info = " " + table.family + " " + table.name + " "
     cmd = NFT_BIN + " list -nnn set" + table_info + set_name
     ret = execute_cmd(cmd, filename, lineno)
 
@@ -384,7 +405,7 @@ def set_check_element(rule1, rule2):
 
 
 def output_clean(pre_output, chain):
-    pos_chain = pre_output[0].find(chain)
+    pos_chain = pre_output[0].find(chain.name)
     if pos_chain == -1:
         return ""
     output_intermediate = pre_output[0][pos_chain:]
@@ -470,7 +491,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
     for table in table_list:
         try:
-            payload_log = open("%s.payload.%s" % (filename_path, table[0]))
+            payload_log = open("%s.payload.%s" % (filename_path, table.family))
         except IOError:
             payload_log = open("%s.payload" % filename_path)
 
@@ -486,11 +507,11 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
         for chain in chain_list:
             unit_tests += 1
             table_flush(table, filename, lineno)
-            table_info = " " + table[0] + " " + table[1] + " "
+            table_info = " " + table.family + " " + table.name + " "
 
             payload_log = os.tmpfile()
 
-            cmd = NFT_BIN + " add rule --debug=netlink" + table_info + chain + " " + rule[0]
+            cmd = NFT_BIN + " add rule --debug=netlink" + table_info + chain.name + " " + rule[0]
             ret = execute_cmd(cmd, filename, lineno, payload_log)
 
             state = rule[1].rstrip()
@@ -526,7 +547,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
                     print_warning("Wrote payload for rule %s" % rule[0], gotf.name, 1)
 
                 # Check output of nft
-                process = subprocess.Popen([NFT_BIN, '-nnn', 'list', 'table'] + table, shell=False,
+                process = subprocess.Popen([NFT_BIN, '-nnn', 'list', 'table', table.family, table.name], shell=False,
                                            stdout=subprocess.PIPE, preexec_fn=preexec)
                 pre_output = process.communicate()
                 output = pre_output[0].split(";")
@@ -624,24 +645,18 @@ def print_result_all(filename, tests, warning, error, unit_tests):
 
 
 def table_process(table_line, filename, lineno):
-    table_info = []
-    if ";" in table_line:
-        table_info = table_line.split(";")
-    else:
-        table_info.append("ip")
-        table_info.append(table_line)
+    table_info = table_line.split(";")
+    table = Table(table_info[0], table_info[1])
 
-    return table_create(table_info, filename, lineno)
+    return table_create(table, filename, lineno)
 
 
 def chain_process(chain_line, filename, lineno):
-    chain_name = chain_line[0]
-    chain_type = ""
+    chain_info = chain_line.split(";")
+    chain = Chain(chain_info[0], chain_info[1])
+
     for table in table_list:
-        if len(chain_line) > 1:
-            chain_type = chain_line[1]
-        ret = chain_create(chain_name, chain_type, table, filename, lineno)
-        if ret != 0:
+        if chain_create(chain, table, filename, lineno) != 0:
             return -1
     return 0
 
@@ -730,7 +745,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
             continue
 
         if line[0] == ":":  # Chain
-            chain_line = line.rstrip()[1:].split(";")
+            chain_line = line.rstrip()[1:]
             ret = chain_process(chain_line, filename, lineno)
             if ret != 0:
                 break
-- 
2.6.4

