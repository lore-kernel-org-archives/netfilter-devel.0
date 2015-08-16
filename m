From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 01/12] tests: use the src/nft binary instead of $PATH one
Date: Sun, 16 Aug 2015 21:05:44 +0200
Message-ID: <1439751955-31190-2-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34741 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbbHPTGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:07 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... so one doesn't need to install new binary into $PATH (or
change PATH... ) during development.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/regression/nft-test.py | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 26fc2ec..c3d2aae 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -20,6 +20,7 @@ import argparse
 import signal
 
 TERMINAL_PATH = os.getcwd()
+NFT_BIN = TERMINAL_PATH + "/src/nft"
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
 LOGFILE = "/tmp/nftables-test.log"
@@ -77,7 +78,7 @@ def table_exist(table, filename, lineno):
     '''
     Exists a table.
     '''
-    cmd = "nft list -nnn table " + table[0] + " " + table[1]
+    cmd = NFT_BIN + " list -nnn table " + table[0] + " " + table[1]
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -87,7 +88,7 @@ def table_flush(table, filename, lineno):
     '''
     Flush a table.
     '''
-    cmd = "nft flush table " + str(table[0]) + " " + str(table[1])
+    cmd = NFT_BIN + " flush table " + str(table[0]) + " " + str(table[1])
     ret = execute_cmd(cmd, filename, lineno)
 
     return cmd
@@ -106,7 +107,7 @@ def table_create(table, filename, lineno):
     table_list.append(table)
 
     ## We add a new table
-    cmd = "nft add table " + table[0] + " " + table[1]
+    cmd = NFT_BIN + " add table " + table[0] + " " + table[1]
     ret = execute_cmd(cmd, filename, lineno)
 
     if ret != 0:
@@ -138,7 +139,7 @@ def table_delete(table, filename=None, lineno=None):
         print_error(reason, filename, lineno)
         return -1
 
-    cmd = "nft delete table" + table_info
+    cmd = NFT_BIN + " delete table" + table_info
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = cmd + ": " \
@@ -161,7 +162,7 @@ def chain_exist(chain, table, filename, lineno):
     '''
 
     table_info = " " + table[0] + " " + table[1] + " "
-    cmd = "nft list -nnn chain" + table_info + chain
+    cmd = NFT_BIN + " list -nnn chain" + table_info + chain
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -181,9 +182,9 @@ def chain_create(chain, chain_type, chain_list, table, filename, lineno):
         return -1
 
     if chain_type:
-        cmd = "nft add chain" + table_info + chain + "\{ " + chain_type + "\; \}"
+        cmd = NFT_BIN + " add chain" + table_info + chain + "\{ " + chain_type + "\; \}"
     else:
-        cmd = "nft add chain" + table_info + chain
+        cmd = NFT_BIN + " add chain" + table_info + chain
 
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
@@ -216,14 +217,14 @@ def chain_delete(chain, table,  filename=None, lineno=None):
         print_error(reason, filename, lineno)
         return -1
 
-    cmd = "nft flush chain" + table_info + chain
+    cmd = NFT_BIN + " flush chain" + table_info + chain
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = "I cannot flush this chain " + chain
         print_error(reason, filename, lineno)
         return -1
 
-    cmd = "nft delete chain" + table_info + chain
+    cmd = NFT_BIN + " delete chain" + table_info + chain
     ret = execute_cmd(cmd, filename, lineno)
     if ret != 0:
         reason = cmd + "I cannot delete this chain. DD"
@@ -258,7 +259,7 @@ def set_add(set_info, table_list, filename, lineno):
 
         table_info = " " + table[0] + " " + table[1] + " "
         set_text = " " + set_info[0] + " { type " + set_info[1] + " \;}"
-        cmd = "nft add set" + table_info + set_text
+        cmd = NFT_BIN + " add set" + table_info + set_text
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and set_info[2].rstrip() == "fail") or \
@@ -306,7 +307,7 @@ def set_add_elements(set_element, set_name, set_all, state, table_list,
                 element = element + ", " + e
 
         set_text = set_name + " { " + element + " }"
-        cmd = "nft add element" + table_info + set_text
+        cmd = NFT_BIN + " add element" + table_info + set_text
         ret = execute_cmd(cmd, filename, lineno)
 
         if (state == "fail" and ret == 0) or (state == "ok" and ret != 0):
@@ -332,7 +333,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 
     for element in set_element:
         set_text = set_name + " {" + element + "}"
-        cmd = "nft delete element" + table_info + set_text
+        cmd = NFT_BIN + " delete element" + table_info + set_text
         ret = execute_cmd(cmd, filename, lineno)
         if ret != 0:
             reason = "I cannot delete an element" + element + \
@@ -362,7 +363,7 @@ def set_delete(all_set, table, filename=None, lineno=None):
 
         # We delete the set.
         table_info = " " + table[0] + " " + table[1] + " "
-        cmd = "nft delete set " + table_info + " " + set_name
+        cmd = NFT_BIN + " delete set " + table_info + " " + set_name
         ret = execute_cmd(cmd, filename, lineno)
 
         # Check if the set still exists after I deleted it.
@@ -379,7 +380,7 @@ def set_exist(set_name, table, filename, lineno):
     Check if the set exists.
     '''
     table_info = " " + table[0] + " " + table[1] + " "
-    cmd = "nft list -nnn set" + table_info + set_name
+    cmd = NFT_BIN + " list -nnn set" + table_info + set_name
     ret = execute_cmd(cmd, filename, lineno)
 
     return True if (ret == 0) else False
@@ -487,11 +488,11 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
             unit_tests += 1
             table_flush(table, filename, lineno)
             table_info = " " + table[0] + " " + table[1] + " "
-            cmd = "nft add rule" + table_info + chain + " " + rule[0]
+            cmd = NFT_BIN + " add rule" + table_info + chain + " " + rule[0]
 
             payload_log = os.tmpfile();
 
-            cmd = "nft add rule --debug=netlink" + table_info + chain + " " + rule[0]
+            cmd = NFT_BIN + " add rule --debug=netlink" + table_info + chain + " " + rule[0]
             ret = execute_cmd(cmd, filename, lineno, payload_log)
 
             state = rule[1].rstrip()
@@ -527,7 +528,7 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
                     print_warning("Wrote payload for rule %s" % rule[0], gotf.name, 1)
 
             # Check output of nft
-                process = subprocess.Popen(['nft', '-nnn', 'list', 'table'] + table,
+                process = subprocess.Popen([NFT_BIN, '-nnn', 'list', 'table'] + table,
                                            shell=False, stdout=subprocess.PIPE,
                                            preexec_fn=preexec)
                 pre_output = process.communicate()
-- 
2.0.5

