From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v3 5/6] tests: py: Add suport for stateful objects in
 python tests
Date: Thu, 26 Jan 2017 15:18:25 -0200
Message-ID: <20170126171825.GA7984@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33536 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdAZRSc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 12:18:32 -0500
Received: by mail-qt0-f196.google.com with SMTP id n13so39889137qtc.0
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 09:18:31 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to write pytests using the new stateful objects.

To add an object use the symbol '%', followed by the name, type and
specifications (currently used in quota):

%cnt1 type counter;ok # Adds the counter cnt1 to all tables

%qt1 type quota over 25 mbytes;ok # Adds the quota qt1 to all tables

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v3: Created in v3.

 tests/py/nft-test.py | 131 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 62b7942..2500921 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -27,6 +27,7 @@ log_file = None
 table_list = []
 chain_list = []
 all_set = dict()
+obj_list = []
 signal_received = 0
 
 
@@ -83,6 +84,20 @@ class Set:
         return self.__dict__ == other.__dict__
 
 
+class Obj:
+    """Class that represents an object"""
+
+    def __init__(self, table, family, name, type, spcf):
+        self.table = table
+        self.family = family
+        self.name = name
+        self.type = type
+        self.spcf = spcf
+
+    def __eq__(self, other):
+        return self.__dict__ == other.__dict__
+
+
 def print_msg(reason, filename=None, lineno=None, color=None, errstr=None):
     '''
     Prints a message with nice colors, indicating file and line number.
@@ -472,6 +487,91 @@ def set_check_element(rule1, rule2):
 
     return cmp(rule1[end1:], rule2[end2:])
 
+
+def obj_add(o, test_result, filename, lineno):
+    '''
+    Adds an object.
+    '''
+    if not table_list:
+        reason = "Missing table to add rule"
+        print_error(reason, filename, lineno)
+        return -1
+
+    for table in table_list:
+        o.table = table.name
+        o.family = table.family
+        obj_handle = o.type + " " + o.name
+        if _obj_exist(o, filename, lineno):
+            reason = "The " + obj_handle + " already exists in " + table.name
+            print_error(reason, filename, lineno)
+            return -1
+
+        table_handle = " " + table.family + " " + table.name + " "
+
+        cmd = NFT_BIN + " add " + o.type + table_handle + o.name + " " + o.spcf
+        ret = execute_cmd(cmd, filename, lineno)
+
+        if (ret == 0 and test_result == "fail") or \
+                (ret != 0 and test_result == "ok"):
+            reason = cmd + ": " + "I cannot add the " + obj_handle
+            print_error(reason, filename, lineno)
+            return -1
+
+        if not _obj_exist(o, filename, lineno):
+            reason = "I have just added the " + obj_handle + \
+                     " to the table " + table.name + " but it does not exist"
+            print_error(reason, filename, lineno)
+            return -1
+
+
+def obj_delete(table, filename=None, lineno=None):
+    '''
+    Deletes object.
+    '''
+    for o in obj_list:
+        obj_handle = o.type + " " + o.name
+        # Check if exists the obj
+        if not obj_exist(o, table, filename, lineno):
+            reason = "The " + obj_handle + " does not exist, I cannot delete it"
+            print_error(reason, filename, lineno)
+            return -1
+
+        # We delete the object.
+        table_info = " " + table.family + " " + table.name + " "
+        cmd = NFT_BIN + " delete " + o.type + table_info + " " + o.name
+        ret = execute_cmd(cmd, filename, lineno)
+
+        # Check if the object still exists after I deleted it.
+        if ret != 0 or obj_exist(o, table, filename, lineno):
+            reason = "Cannot remove the " + obj_handle
+            print_error(reason, filename, lineno)
+            return -1
+
+    return 0
+
+
+def obj_exist(o, table, filename, lineno):
+    '''
+    Check if the object exists.
+    '''
+    table_handle = " " + table.family + " " + table.name + " "
+    cmd = NFT_BIN + " list -nnn " + o.type + table_handle + o.name
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+
+def _obj_exist(o, filename, lineno):
+    '''
+    Check if the object exists.
+    '''
+    table_handle = " " + o.family + " " + o.table + " "
+    cmd = NFT_BIN + " list -nnn " + o.type + table_handle + o.name
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+
 def output_clean(pre_output, chain):
     pos_chain = pre_output.find(chain.name)
     if pos_chain == -1:
@@ -684,6 +784,8 @@ def cleanup_on_exit():
             chain_delete(chain, table, "", "")
         if all_set:
             set_delete(table)
+        if obj_list:
+            obj_delete(table)
         table_delete(table)
 
 
@@ -775,6 +877,26 @@ def set_element_process(element_line, filename, lineno):
     return set_add_elements(set_element, set_name, rule_state, filename, lineno)
 
 
+def obj_process(obj_line, filename, lineno):
+    test_result = obj_line[1]
+
+    tokens = obj_line[0].split(" ")
+    obj_name = tokens[0]
+    obj_type = tokens[2]
+    obj_spcf = ""
+
+    if len(tokens) > 3:
+        obj_spcf = " ".join(tokens[3:])
+
+    o = Obj("", "", obj_name, obj_type, obj_spcf)
+
+    ret = obj_add(o, test_result, filename, lineno)
+    if ret == 0:
+        obj_list.append(o)
+
+    return ret
+
+
 def payload_find_expected(payload_log, rule):
     '''
     Find the netlink payload that should be generated by given rule in
@@ -862,6 +984,15 @@ def run_test_file(filename, force_all_family_option, specific_file):
             passed += 1
             continue
 
+        if line[0] == "%":  # Adds this object
+            obj_line = line.rstrip()[1:].split(";")
+            ret = obj_process(obj_line, filename, lineno)
+            tests += 1
+            if ret == -1:
+                continue
+            passed += 1
+            continue
+
         # Rule
         rule = line.split(';')  # rule[1] Ok or FAIL
         if len(rule) == 1 or len(rule) > 3 or rule[1].rstrip() \
-- 
2.7.4

