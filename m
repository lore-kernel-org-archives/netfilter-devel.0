From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 2/6] tests/py: fix style
Date: Mon,  4 Jan 2016 11:43:52 +0100
Message-ID: <1451904236-4481-2-git-send-email-pablombg@gmail.com>
References: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33233 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbcADKoj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 05:44:39 -0500
Received: by mail-wm0-f54.google.com with SMTP id f206so167945539wmf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 02:44:38 -0800 (PST)
In-Reply-To: <1451904236-4481-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

- Adjust lines to 120 columns style
- Add two lines of separation between functions
- Remove redundant parentheses and semicolons
- Apply other minor style fixes

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 tests/py/nft-test.py | 218 +++++++++++++++++++++------------------------------
 1 file changed, 89 insertions(+), 129 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index cfea1b1..3a2082b 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -44,33 +44,35 @@ class Colors:
         RED = ''
         ENDC = ''
 
+
 def print_msg(reason, filename=None, lineno=None, color=None, errstr=None):
     '''
     Prints a message with nice colors, indicating file and line number.
     '''
     if filename and lineno:
-        print (filename + ": " + color + "ERROR:" +
-               Colors.ENDC + " line %d: %s" % (lineno + 1, reason))
+        print filename + ": " + color + "ERROR:" + Colors.ENDC + " line %d: %s" % (lineno + 1, reason)
     else:
-        print (color + "ERROR:" + Colors.ENDC + " %s" % (reason))
+        print color + "ERROR:" + Colors.ENDC + " %s" % reason
+
 
 def print_error(reason, filename=None, lineno=None):
     print_msg(reason, filename, lineno, Colors.RED, "ERROR:")
 
+
 def print_warning(reason, filename=None, lineno=None):
     print_msg(reason, filename, lineno, Colors.YELLOW, "WARNING:")
 
 
 def print_differences_warning(filename, lineno, rule1, rule2, cmd):
     reason = "'" + rule1 + "' mismatches '" + rule2 + "'"
-    print filename + ": " + Colors.YELLOW + "WARNING: " + Colors.ENDC + \
-        "line: " + str(lineno + 1) + ": '" + cmd + "': " + reason
+    print filename + ": " + Colors.YELLOW + "WARNING: " + Colors.ENDC + "line: " + str(lineno + 1) + ": '" + cmd + \
+          "': " + reason
 
 
 def print_differences_error(filename, lineno, cmd):
     reason = "Listing is broken."
-    print filename + ": " + Colors.RED + "ERROR: " + Colors.ENDC + \
-        "line: " + str(lineno + 1) + ": '" + cmd + "': " + reason
+    print filename + ": " + Colors.RED + "ERROR: " + Colors.ENDC + "line: " + str(lineno + 1) + ": '" + cmd + "': " + \
+          reason
 
 
 def table_exist(table, filename, lineno):
@@ -97,7 +99,7 @@ def table_create(table, filename, lineno):
     '''
     Adds a table.
     '''
-    ## We check if table exists.
+    # We check if table exists.
     if table_exist(table, filename, lineno):
         reason = "Table " + table[1] + " already exists"
         print_error(reason, filename, lineno)
@@ -105,7 +107,7 @@ def table_create(table, filename, lineno):
 
     table_list.append(table)
 
-    ## We add a new table
+    # We add a new table
     cmd = NFT_BIN + " add table " + table[0] + " " + table[1]
     ret = execute_cmd(cmd, filename, lineno)
 
@@ -115,11 +117,10 @@ def table_create(table, filename, lineno):
         table_list.remove(table)
         return -1
 
-    ## We check if table was added correctly.
+    # We check if table was added correctly.
     if not table_exist(table, filename, lineno):
         table_list.remove(table)
-        reason = "I have just added the table " + table[1] + \
-            " but it does not exist. Giving up!"
+        reason = "I have just added the table " + table[1] + " but it does not exist. Giving up!"
         print_error(reason, filename, lineno)
         return -1
 
@@ -133,22 +134,19 @@ def table_delete(table, filename=None, lineno=None):
     table_info = " " + table[0] + " " + table[1] + " "
 
     if not table_exist(table, filename, lineno):
-        reason = "Table " + table[1] + \
-            " does not exist but I added it before."
+        reason = "Table " + table[1] + " does not exist but I added it before."
         print_error(reason, filename, lineno)
         return -1
 
     cmd = NFT_BIN + " delete table" + table_info
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
-        reason = cmd + ": " \
-            "I cannot delete table '" + table[1] + "'. Giving up! "
+        reason = cmd + ": " + "I cannot delete table '" + table[1] + "'. Giving up! "
         print_error(reason, filename, lineno)
         return -1
 
     if table_exist(table, filename, lineno):
-        reason = "I have just deleted the table " + table[1] + \
-            " but the table still exists."
+        reason = "I have just deleted the table " + table[1] + " but the table still exists."
         print_error(reason, filename, lineno)
         return -1
 
@@ -159,7 +157,6 @@ def chain_exist(chain, table, filename, lineno):
     '''
     Checks a chain
     '''
-
     table_info = " " + table[0] + " " + table[1] + " "
     cmd = NFT_BIN + " list -nnn chain" + table_info + chain
     ret = execute_cmd(cmd, filename, lineno)
@@ -171,12 +168,10 @@ def chain_create(chain, chain_type, chain_list, table, filename, lineno):
     '''
     Adds a chain
     '''
-
     table_info = " " + table[0] + " " + table[1] + " "
 
     if chain_exist(chain, table, filename, lineno):
-        reason = "This chain '" + chain + "' exists in " + table[1] + "." + \
-            "I cannot create two chains with same name."
+        reason = "This chain '" + chain + "' exists in " + table[1] + ". I cannot create two chains with same name."
         print_error(reason, filename, lineno)
         return -1
 
@@ -191,28 +186,25 @@ def chain_create(chain, chain_type, chain_list, table, filename, lineno):
         print_error(reason, filename, lineno)
         return -1
 
-    if not chain in chain_list:
+    if chain not in chain_list:
         chain_list.append(chain)
 
     if not chain_exist(chain, table, filename, lineno):
-        reason = "I have added the chain '" + chain + \
-            "' but it does not exist in " + table[1]
+        reason = "I have added the chain '" + chain + "' but it does not exist in " + table[1]
         print_error(reason, filename, lineno)
         return -1
 
     return 0
 
 
-def chain_delete(chain, table,  filename=None, lineno=None):
+def chain_delete(chain, table, filename=None, lineno=None):
     '''
     Flushes and deletes a chain.
     '''
-
     table_info = " " + table[0] + " " + table[1] + " "
 
     if not chain_exist(chain, table, filename, lineno):
-        reason = "The chain " + chain + " does not exists in " + table[1] + \
-            ". I cannot delete it."
+        reason = "The chain " + chain + " does not exists in " + table[1] + ". I cannot delete it."
         print_error(reason, filename, lineno)
         return -1
 
@@ -231,8 +223,7 @@ def chain_delete(chain, table,  filename=None, lineno=None):
         return -1
 
     if chain_exist(chain, table, filename, lineno):
-        reason = "The chain " + chain + " exists in " + table[1] + \
-            ". I cannot delete this chain"
+        reason = "The chain " + chain + " exists in " + table[1] + ". I cannot delete this chain"
         print_error(reason, filename, lineno)
         return -1
 
@@ -243,7 +234,6 @@ def set_add(set_info, table_list, filename, lineno):
     '''
     Adds a set.
     '''
-
     if not table_list:
         reason = "Missing table to add rule"
         print_error(reason, filename, lineno)
@@ -251,8 +241,7 @@ def set_add(set_info, table_list, filename, lineno):
 
     for table in table_list:
         if set_exist(set_info[0], table, filename, lineno):
-            reason = "This set " + set_info + " exists in " + table[1] + \
-                ". I cannot add it again"
+            reason = "This set " + set_info + " exists in " + table[1] + ". I cannot add it again"
             print_error(reason, filename, lineno)
             return -1
 
@@ -261,27 +250,23 @@ def set_add(set_info, table_list, filename, lineno):
         cmd = NFT_BIN + " add set" + table_info + set_text
         ret = execute_cmd(cmd, filename, lineno)
 
-        if (ret == 0 and set_info[2].rstrip() == "fail") or \
-           (ret != 0 and set_info[2].rstrip() == "ok"):
-                reason = cmd + ": " + "I cannot add the set " + set_info[0]
-                print_error(reason, filename, lineno)
-                return -1
+        if (ret == 0 and set_info[2].rstrip() == "fail") or (ret != 0 and set_info[2].rstrip() == "ok"):
+            reason = cmd + ": " + "I cannot add the set " + set_info[0]
+            print_error(reason, filename, lineno)
+            return -1
 
         if not set_exist(set_info[0], table, filename, lineno):
-            reason = "I have just added the set " + set_info[0] + \
-                " to the table " + table[1] + " but it does not exist"
+            reason = "I have just added the set " + set_info[0] + " to the table " + table[1] + " but it does not exist"
             print_error(reason, filename, lineno)
             return -1
 
     return 0
 
 
-def set_add_elements(set_element, set_name, set_all, state, table_list,
-                     filename, lineno):
+def set_add_elements(set_element, set_name, set_all, state, table_list, filename, lineno):
     '''
     Adds elements to the set.
     '''
-
     if not table_list:
         reason = "Missing table to add rules"
         print_error(reason, filename, lineno)
@@ -289,10 +274,8 @@ def set_add_elements(set_element, set_name, set_all, state, table_list,
 
     for table in table_list:
         # Check if set exists.
-        if (not set_exist(set_name, table, filename, lineno) or
-           not set_name in set_all) and state == "ok":
-            reason = "I cannot add an element to the set " + set_name + \
-                " since it does not exist."
+        if (not set_exist(set_name, table, filename, lineno) or set_name not in set_all) and state == "ok":
+            reason = "I cannot add an element to the set " + set_name + " since it does not exist."
             print_error(reason, filename, lineno)
             return -1
 
@@ -310,21 +293,20 @@ def set_add_elements(set_element, set_name, set_all, state, table_list,
         ret = execute_cmd(cmd, filename, lineno)
 
         if (state == "fail" and ret == 0) or (state == "ok" and ret != 0):
-                test_state = "This rule should have failed."
-                reason = cmd + ": " + test_state
-                print_error(reason, filename, lineno)
-                return -1
+            test_state = "This rule should have failed."
+            reason = cmd + ": " + test_state
+            print_error(reason, filename, lineno)
+            return -1
 
         # Add element into a all_set.
-        if (ret == 0 and state == "ok"):
+        if ret == 0 and state == "ok":
             for e in set_element:
                 set_all[set_name].add(e)
 
     return 0
 
 
-def set_delete_elements(set_element, set_name, table, filename=None,
-                        lineno=None):
+def set_delete_elements(set_element, set_name, table, filename=None, lineno=None):
     '''
     Deletes elements in a set.
     '''
@@ -335,8 +317,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
         cmd = NFT_BIN + " delete element" + table_info + set_text
         ret = execute_cmd(cmd, filename, lineno)
         if ret != 0:
-            reason = "I cannot delete an element" + element + \
-                " from the set '" + set_name
+            reason = "I cannot delete an element" + element + " from the set '" + set_name
             print_error(reason, filename, lineno)
             return -1
 
@@ -347,18 +328,15 @@ def set_delete(all_set, table, filename=None, lineno=None):
     '''
     Deletes set and its content.
     '''
-
     for set_name in all_set.keys():
         # Check if exists the set
         if not set_exist(set_name, table, filename, lineno):
-            reason = "The set " + set_name + \
-                " does not exist, I cannot delete it"
+            reason = "The set " + set_name + " does not exist, I cannot delete it"
             print_error(reason, filename, lineno)
             return -1
 
         # We delete all elements in the set
-        set_delete_elements(all_set[set_name], set_name, table, filename,
-                            lineno)
+        set_delete_elements(all_set[set_name], set_name, table, filename, lineno)
 
         # We delete the set.
         table_info = " " + table[0] + " " + table[1] + " "
@@ -395,12 +373,12 @@ def set_check_element(rule1, rule2):
     end1 = rule1.find("}")
     end2 = rule2.find("}")
 
-    if ((pos1 != -1) and (pos2 != -1) and (end1 != -1) and (end2 != -1)):
+    if (pos1 != -1) and (pos2 != -1) and (end1 != -1) and (end2 != -1):
         list1 = (rule1[pos1 + 1:end1].replace(" ", "")).split(",")
         list2 = (rule2[pos2 + 1:end2].replace(" ", "")).split(",")
         list1.sort()
         list2.sort()
-        if (cmp(list1, list2) == 0):
+        if cmp(list1, list2) == 0:
             ret = 0
     return ret
 
@@ -423,6 +401,7 @@ def output_clean(pre_output, chain):
         return ""
     return rule
 
+
 def payload_check_elems_to_set(elems):
     newset = set()
 
@@ -436,8 +415,8 @@ def payload_check_elems_to_set(elems):
 
     return newset
 
-def payload_check_set_elems(want, got):
 
+def payload_check_set_elems(want, got):
     if want.find('element') < 0 or want.find('[end]') < 0:
         return 0
 
@@ -449,8 +428,8 @@ def payload_check_set_elems(want, got):
 
     return set_want == set_got
 
-def payload_check(payload_buffer, file, cmd):
 
+def payload_check(payload_buffer, file, cmd):
     file.seek(0, 0)
     i = 0
 
@@ -469,13 +448,13 @@ def payload_check(payload_buffer, file, cmd):
         if payload_check_set_elems(want_line, line):
             continue
 
-        print_differences_warning(file.name, lineno, want_line.strip(), line.strip(), cmd);
+        print_differences_warning(file.name, lineno, want_line.strip(), line.strip(), cmd)
         return 0
 
     return i > 0
 
-def rule_add(rule, table_list, chain_list, filename, lineno,
-             force_all_family_option, filename_path):
+
+def rule_add(rule, table_list, chain_list, filename, lineno, force_all_family_option, filename_path):
     '''
     Adds a rule
     '''
@@ -492,25 +471,24 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
     for table in table_list:
         try:
             payload_log = open("%s.payload.%s" % (filename_path, table[0]))
-        except (IOError):
+        except IOError:
             payload_log = open("%s.payload" % filename_path)
 
         if rule[1].strip() == "ok":
             try:
                 payload_expected.index(rule[0])
-            except (ValueError):
+            except ValueError:
                 payload_expected = payload_find_expected(payload_log, rule[0])
 
-                if payload_expected == []:
+                if not payload_expected:
                     print_error("did not find payload information for rule '%s'" % rule[0], payload_log.name, 1)
 
         for chain in chain_list:
             unit_tests += 1
             table_flush(table, filename, lineno)
             table_info = " " + table[0] + " " + table[1] + " "
-            NFT_BIN + " add rule" + table_info + chain + " " + rule[0]
 
-            payload_log = os.tmpfile();
+            payload_log = os.tmpfile()
 
             cmd = NFT_BIN + " add rule --debug=netlink" + table_info + chain + " " + rule[0]
             ret = execute_cmd(cmd, filename, lineno, payload_log)
@@ -528,12 +506,12 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
                 if not force_all_family_option:
                     return [ret, warning, error, unit_tests]
 
-            if (state == "fail" and ret != 0):
+            if state == "fail" and ret != 0:
                 ret = 0
                 continue
 
             if ret == 0:
-            # Check for matching payload
+                # Check for matching payload
                 if state == "ok" and not payload_check(payload_expected, payload_log, cmd):
                     error += 1
                     gotf = open("%s.payload.got" % filename_path, 'a')
@@ -547,10 +525,9 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
                     gotf.close()
                     print_warning("Wrote payload for rule %s" % rule[0], gotf.name, 1)
 
-            # Check output of nft
-                process = subprocess.Popen([NFT_BIN, '-nnn', 'list', 'table'] + table,
-                                           shell=False, stdout=subprocess.PIPE,
-                                           preexec_fn=preexec)
+                # Check output of nft
+                process = subprocess.Popen([NFT_BIN, '-nnn', 'list', 'table'] + table, shell=False,
+                                           stdout=subprocess.PIPE, preexec_fn=preexec)
                 pre_output = process.communicate()
                 output = pre_output[0].split(";")
                 if len(output) < 2:
@@ -562,32 +539,27 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
                         return [ret, warning, error, unit_tests]
                 else:
                     rule_output = output_clean(pre_output, chain)
-                    if (len(rule) == 3):
+                    if len(rule) == 3:
                         teoric_exit = rule[2]
                     else:
                         teoric_exit = rule[0]
 
-                    if (rule_output.rstrip() != teoric_exit.rstrip()):
-                        if (rule[0].find("{") != -1):  # anonymous sets
-                            if (set_check_element(teoric_exit, rule_output) != 0):
+                    if rule_output.rstrip() != teoric_exit.rstrip():
+                        if rule[0].find("{") != -1:  # anonymous sets
+                            if set_check_element(teoric_exit, rule_output) != 0:
                                 warning += 1
-                                print_differences_warning(filename, lineno,
-                                                          rule[0], rule_output,
-                                                          cmd)
+                                print_differences_warning(filename, lineno, rule[0], rule_output, cmd)
                                 if not force_all_family_option:
                                     return [ret, warning, error, unit_tests]
                         else:
                             if len(rule_output) <= 0:
                                 error += 1
-                                print_differences_error(filename, lineno,
-                                                        cmd)
+                                print_differences_error(filename, lineno, cmd)
                                 if not force_all_family_option:
                                     return [ret, warning, error, unit_tests]
 
                             warning += 1
-                            print_differences_warning(filename, lineno,
-                                                      teoric_exit.rstrip(), rule_output,
-                                                      cmd)
+                            print_differences_warning(filename, lineno, teoric_exit.rstrip(), rule_output, cmd)
 
                             if not force_all_family_option:
                                 return [ret, warning, error, unit_tests]
@@ -613,7 +585,7 @@ def signal_handler(signal, frame):
     signal_received = 1
 
 
-def execute_cmd(cmd, filename, lineno, stdout_log = False):
+def execute_cmd(cmd, filename, lineno, stdout_log=False):
     '''
     Executes a command, checks for segfaults and returns the command exit
     code.
@@ -643,18 +615,16 @@ def execute_cmd(cmd, filename, lineno, stdout_log = False):
 
 
 def print_result(filename, tests, warning, error):
-    return str(filename) + ": " + str(tests) + " unit tests, " + \
-        str(error) + " error, " + str(warning) + " warning"
+    return str(filename) + ": " + str(tests) + " unit tests, " + str(error) + " error, " + str(warning) + " warning"
 
 
 def print_result_all(filename, tests, warning, error, unit_tests):
-        return str(filename) + ": " + str(tests) + " unit tests, " +\
-            str(unit_tests) + " total test executed, " + \
-            str(error) + " error, " + \
-            str(warning) + " warning"
+    return str(filename) + ": " + str(tests) + " unit tests, " + str(unit_tests) + " total test executed, " + \
+           str(error) + " error, " + str(warning) + " warning"
 
 
 def table_process(table_line, filename, lineno):
+    table_info = []
     if ";" in table_line:
         table_info = table_line.split(";")
     else:
@@ -670,11 +640,10 @@ def chain_process(chain_line, filename, lineno):
     for table in table_list:
         if len(chain_line) > 1:
             chain_type = chain_line[1]
-        ret = chain_create(chain_name, chain_type, chain_list, table,
-                            filename, lineno)
+        ret = chain_create(chain_name, chain_type, chain_list, table, filename, lineno)
         if ret != 0:
             return -1
-    return ret
+    return 0
 
 
 def set_process(set_line, filename, lineno):
@@ -697,8 +666,8 @@ def set_element_process(element_line, filename, lineno):
     set_name = element_line[0].split(" ")[0]
     set_element = element_line[0].split(" ")
     set_element.remove(set_name)
-    return set_add_elements(set_element, set_name, all_set, rule_state,
-                            table_list, filename, lineno)
+    return set_add_elements(set_element, set_name, all_set, rule_state, table_list, filename, lineno)
+
 
 def payload_find_expected(payload_log, rule):
     '''
@@ -730,6 +699,7 @@ def payload_find_expected(payload_log, rule):
     payload_log.seek(0, 0)
     return payload_buffer
 
+
 def run_test_file(filename, force_all_family_option, specific_file):
     '''
     Runs a test file
@@ -755,7 +725,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
         if line[0] == '*':  # Table
             table_line = line.rstrip()[1:]
             ret = table_process(table_line, filename, lineno)
-            if (ret != 0):
+            if ret != 0:
                 break
             continue
 
@@ -800,8 +770,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
         elif need_fix_option:
             continue
 
-        result = rule_add(rule, table_list, chain_list, filename, lineno,
-                          force_all_family_option, filename_path)
+        result = rule_add(rule, table_list, chain_list, filename, lineno, force_all_family_option, filename_path)
         tests += 1
         ret = result[0]
         warning = result[1]
@@ -819,8 +788,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
     for table in table_list:
         # We delete chains
         for chain in chain_list:
-            ret = chain_delete(chain, table, filename, lineno)
-            if ret != 0:
+            chain_delete(chain, table, filename, lineno)
 
         # We delete sets.
         if all_set:
@@ -834,12 +802,11 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
     if specific_file:
         if force_all_family_option:
-            print print_result_all(filename, tests, total_warning, total_error,
-                                   total_unit_run)
+            print print_result_all(filename, tests, total_warning, total_error, total_unit_run)
         else:
             print print_result(filename, tests, total_warning, total_error)
     else:
-        if (tests == passed and tests > 0):
+        if tests == passed and tests > 0:
             print filename + ": " + Colors.GREEN + "OK" + Colors.ENDC
 
     f.close()
@@ -851,23 +818,15 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
 
 def main():
-    parser = argparse.ArgumentParser(description='Run nft tests',
-                                     version='1.0')
+    parser = argparse.ArgumentParser(description='Run nft tests', version='1.0')
 
-    parser.add_argument('filename', nargs='?',
-                        metavar='path/to/file.t',
-                        help='Run only this test')
+    parser.add_argument('filename', nargs='?', metavar='path/to/file.t', help='Run only this test')
 
-    parser.add_argument('-d', '--debug', action='store_true',
-                        dest='debug',
-                        help='enable debugging mode')
+    parser.add_argument('-d', '--debug', action='store_true', dest='debug', help='enable debugging mode')
 
-    parser.add_argument('-e', '--need-fix', action='store_true',
-                        dest='need_fix_line',
-                        help='run rules that need a fix')
+    parser.add_argument('-e', '--need-fix', action='store_true', dest='need_fix_line', help='run rules that need a fix')
 
-    parser.add_argument('-f', '--force-family', action='store_true',
-                        dest='force_all_family',
+    parser.add_argument('-f', '--force-family', action='store_true', dest='force_all_family',
                         help='keep testing all families on error')
 
     args = parser.parse_args()
@@ -937,11 +896,12 @@ def main():
     else:
         if not specific_file:
             if force_all_family_option:
-                print ("%d test files, %d files passed, %d unit tests, %d total executed, %d error, %d warning" %
-                      (test_files, files_ok, tests, run_total, errors, warnings))
+                print "%d test files, %d files passed, %d unit tests, %d total executed, %d error, %d warning" \
+                      % (test_files, files_ok, tests, run_total, errors, warnings)
             else:
-                print ("%d test files, %d files passed, %d unit tests, %d error, %d warning" %
-                      (test_files, files_ok, tests, errors, warnings))
+                print "%d test files, %d files passed, %d unit tests, %d error, %d warning" \
+                      % (test_files, files_ok, tests, errors, warnings)
+
 
 if __name__ == '__main__':
     main()
-- 
2.6.4

