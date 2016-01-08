From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft v2 5/6] tests/py: modify supported test file syntax
Date: Fri,  8 Jan 2016 21:51:53 +0100
Message-ID: <1452286314-17406-5-git-send-email-pablombg@gmail.com>
References: <1452286314-17406-1-git-send-email-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36496 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbcAHUwo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 15:52:44 -0500
Received: by mail-wm0-f68.google.com with SMTP id l65so17543652wmf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Jan 2016 12:52:43 -0800 (PST)
In-Reply-To: <1452286314-17406-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Until now, the syntax to represent tables and chains in test files was:

*ip;test-ip4
*ip6;test-ip6
*inet;test-inet
:input;type filter hook input priority 0

Where lines starting with * are tables and lines starting with : are
chains.

This commit change the test script to deal with new syntax:

:input;type filter hook input priority 0
*ip;test-ip4;input
*ip6;test-ip6;input
*inet;test-inet;input

Now the chains should be included before tables. Also, lines defining
tables have a new third part (delimited by semicolon) where the chains
needed by the table are declared. If table needs to include more than
one chain, those must be separated by commas:

:input;type filter hook input priority 0
:forward;type filter hook forward priority 0
:output;type filter hook output priority 0
*arp;test-arp;input,forward,output

This new syntax allow to include in the same test file chains not
supported by all families of tables tested.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
Changes in v2:
    Resolve change conflicts

 tests/py/nft-test.py | 51 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 6b03915..0924e60 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -48,9 +48,10 @@ class Colors:
 class Chain:
     """Class that represents a chain"""
 
-    def __init__(self, name, config):
+    def __init__(self, name, config, lineno):
         self.name = name
         self.config = config
+        self.lineno = lineno
 
     def __eq__(self, other):
         return self.__dict__ == other.__dict__
@@ -59,9 +60,10 @@ class Chain:
 class Table:
     """Class that represents a table"""
 
-    def __init__(self, family, name):
+    def __init__(self, family, name, chains):
         self.family = family
         self.name = name
+        self.chains = chains
 
     def __eq__(self, other):
         return self.__dict__ == other.__dict__
@@ -148,6 +150,15 @@ def table_create(table, filename, lineno):
         print_error(reason, filename, lineno)
         return -1
 
+    for chain in table.chains:
+        c = next((c for c in chain_list if c.name == chain), None)
+        if c is None:
+            reason = "The chain " + chain + " requested by table " + \
+                     table.name + " does not exist."
+            print_error(reason, filename, lineno)
+        else:
+            chain_create(c, table, filename)
+
     return 0
 
 
@@ -180,45 +191,42 @@ def table_delete(table, filename=None, lineno=None):
     return 0
 
 
-def chain_exist(chain, table, filename, lineno):
+def chain_exist(chain, table, filename):
     '''
     Checks a chain
     '''
     table_info = " " + table.family + " " + table.name + " "
     cmd = NFT_BIN + " list -nnn chain" + table_info + chain.name
-    ret = execute_cmd(cmd, filename, lineno)
+    ret = execute_cmd(cmd, filename, chain.lineno)
 
     return True if (ret == 0) else False
 
 
-def chain_create(chain, table, filename, lineno):
+def chain_create(chain, table, filename):
     '''
     Adds a chain
     '''
     table_info = " " + table.family + " " + table.name + " "
 
-    if chain_exist(chain, table, filename, lineno):
+    if chain_exist(chain, table, filename):
         reason = "This chain '" + chain.name + "' exists in " + table.name + \
                  ". I cannot create two chains with same name."
-        print_error(reason, filename, lineno)
+        print_error(reason, filename, chain.lineno)
         return -1
 
     cmd = NFT_BIN + " add chain" + table_info + chain.name + \
           "\{ " + chain.config + "\; \}"
 
-    ret = execute_cmd(cmd, filename, lineno)
+    ret = execute_cmd(cmd, filename, chain.lineno)
     if ret != 0:
         reason = "I cannot create the chain '" + chain.name
-        print_error(reason, filename, lineno)
+        print_error(reason, filename, chain.lineno)
         return -1
 
-    if chain not in chain_list:
-        chain_list.append(chain)
-
-    if not chain_exist(chain, table, filename, lineno):
+    if not chain_exist(chain, table, filename):
         reason = "I have added the chain '" + chain.name + \
                  "' but it does not exist in " + table.name
-        print_error(reason, filename, lineno)
+        print_error(reason, filename, chain.lineno)
         return -1
 
     return 0
@@ -230,7 +238,7 @@ def chain_delete(chain, table, filename=None, lineno=None):
     '''
     table_info = " " + table.family + " " + table.name + " "
 
-    if not chain_exist(chain, table, filename, lineno):
+    if not chain_exist(chain, table, filename):
         reason = "The chain " + chain.name + " does not exists in " + \
                  table.name + ". I cannot delete it."
         print_error(reason, filename, lineno)
@@ -250,7 +258,7 @@ def chain_delete(chain, table, filename=None, lineno=None):
         print_error(reason, filename, lineno)
         return -1
 
-    if chain_exist(chain, table, filename, lineno):
+    if chain_exist(chain, table, filename):
         reason = "The chain " + chain.name + " exists in " + table.name + \
                  ". I cannot delete this chain"
         print_error(reason, filename, lineno)
@@ -678,18 +686,15 @@ def print_result_all(filename, tests, warning, error, unit_tests):
 
 def table_process(table_line, filename, lineno):
     table_info = table_line.split(";")
-    table = Table(table_info[0], table_info[1])
+    table = Table(table_info[0], table_info[1], table_info[2].split(","))
 
     return table_create(table, filename, lineno)
 
 
-def chain_process(chain_line, filename, lineno):
+def chain_process(chain_line, lineno):
     chain_info = chain_line.split(";")
-    chain = Chain(chain_info[0], chain_info[1])
+    chain_list.append(Chain(chain_info[0], chain_info[1], lineno))
 
-    for table in table_list:
-        if chain_create(chain, table, filename, lineno) != 0:
-            return -1
     return 0
 
 
@@ -779,7 +784,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
 
         if line[0] == ":":  # Chain
             chain_line = line.rstrip()[1:]
-            ret = chain_process(chain_line, filename, lineno)
+            ret = chain_process(chain_line, lineno)
             if ret != 0:
                 break
             continue
-- 
2.7.0

