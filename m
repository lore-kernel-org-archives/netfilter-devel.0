From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 3/6] tests/py: simplify use of globals
Date: Mon,  4 Jan 2016 11:43:53 +0100
Message-ID: <1451904236-4481-3-git-send-email-pablombg@gmail.com>
References: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33252 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbcADKok (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 05:44:40 -0500
Received: by mail-wm0-f51.google.com with SMTP id f206so167946206wmf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 02:44:40 -0800 (PST)
In-Reply-To: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The script made a messy use of globals, these was sometimes accessed
directly and passed as parameter in other cases.

Since is not expected having to deal with threads in the script, now the
globals are always accessed directly for the sake of simplicity.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 tests/py/nft-test.py | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 3a2082b..f5d5d84 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -164,7 +164,7 @@ def chain_exist(chain, table, filename, lineno):
     return True if (ret == 0) else False
 
 
-def chain_create(chain, chain_type, chain_list, table, filename, lineno):
+def chain_create(chain, chain_type, table, filename, lineno):
     '''
     Adds a chain
     '''
@@ -230,7 +230,7 @@ def chain_delete(chain, table, filename=None, lineno=None):
     return 0
 
 
-def set_add(set_info, table_list, filename, lineno):
+def set_add(set_info, filename, lineno):
     '''
     Adds a set.
     '''
@@ -263,7 +263,7 @@ def set_add(set_info, table_list, filename, lineno):
     return 0
 
 
-def set_add_elements(set_element, set_name, set_all, state, table_list, filename, lineno):
+def set_add_elements(set_element, set_name, state, filename, lineno):
     '''
     Adds elements to the set.
     '''
@@ -274,7 +274,7 @@ def set_add_elements(set_element, set_name, set_all, state, table_list, filename
 
     for table in table_list:
         # Check if set exists.
-        if (not set_exist(set_name, table, filename, lineno) or set_name not in set_all) and state == "ok":
+        if (not set_exist(set_name, table, filename, lineno) or set_name not in all_set) and state == "ok":
             reason = "I cannot add an element to the set " + set_name + " since it does not exist."
             print_error(reason, filename, lineno)
             return -1
@@ -301,7 +301,7 @@ def set_add_elements(set_element, set_name, set_all, state, table_list, filename
         # Add element into a all_set.
         if ret == 0 and state == "ok":
             for e in set_element:
-                set_all[set_name].add(e)
+                all_set[set_name].add(e)
 
     return 0
 
@@ -324,7 +324,7 @@ def set_delete_elements(set_element, set_name, table, filename=None, lineno=None
     return 0
 
 
-def set_delete(all_set, table, filename=None, lineno=None):
+def set_delete(table, filename=None, lineno=None):
     '''
     Deletes set and its content.
     '''
@@ -454,7 +454,7 @@ def payload_check(payload_buffer, file, cmd):
     return i > 0
 
 
-def rule_add(rule, table_list, chain_list, filename, lineno, force_all_family_option, filename_path):
+def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
     '''
     Adds a rule
     '''
@@ -576,7 +576,7 @@ def cleanup_on_exit():
         for chain in chain_list:
             chain_delete(chain, table, "", "")
         if all_set:
-            set_delete(all_set, table)
+            set_delete(table)
         table_delete(table)
 
 
@@ -640,7 +640,7 @@ def chain_process(chain_line, filename, lineno):
     for table in table_list:
         if len(chain_line) > 1:
             chain_type = chain_line[1]
-        ret = chain_create(chain_name, chain_type, chain_list, table, filename, lineno)
+        ret = chain_create(chain_name, chain_type, table, filename, lineno)
         if ret != 0:
             return -1
     return 0
@@ -654,7 +654,7 @@ def set_process(set_line, filename, lineno):
     set_state = set_line[1].split(";")[1]  # ok or fail
     set_info.append(set_type)
     set_info.append(set_state)
-    ret = set_add(set_info, table_list, filename, lineno)
+    ret = set_add(set_info, filename, lineno)
     if ret == 0:
         all_set[set_name] = set()
 
@@ -666,7 +666,7 @@ def set_element_process(element_line, filename, lineno):
     set_name = element_line[0].split(" ")[0]
     set_element = element_line[0].split(" ")
     set_element.remove(set_name)
-    return set_add_elements(set_element, set_name, all_set, rule_state, table_list, filename, lineno)
+    return set_add_elements(set_element, set_name, rule_state, filename, lineno)
 
 
 def payload_find_expected(payload_log, rule):
@@ -770,7 +770,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
         elif need_fix_option:
             continue
 
-        result = rule_add(rule, table_list, chain_list, filename, lineno, force_all_family_option, filename_path)
+        result = rule_add(rule, filename, lineno, force_all_family_option, filename_path)
         tests += 1
         ret = result[0]
         warning = result[1]
@@ -792,7 +792,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
         # We delete sets.
         if all_set:
-            ret = set_delete(all_set, table, filename, lineno)
+            ret = set_delete(table, filename, lineno)
             if ret != 0:
                 reason = "There is a problem when we delete a set"
                 print_error(reason, filename, lineno)
-- 
2.6.4

