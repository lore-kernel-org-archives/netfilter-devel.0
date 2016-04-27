From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3 nft] tests/py: explicitly indication of set type and flags from test definitions
Date: Wed, 27 Apr 2016 15:07:14 +0200
Message-ID: <1461762435-12411-2-git-send-email-pablo@netfilter.org>
References: <1461762435-12411-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60995 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbcD0NHc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 09:07:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6CA48E862E
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 15:07:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5ACDDCA107
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 15:07:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C36FF64460
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2016 15:07:24 +0200 (CEST)
In-Reply-To: <1461762435-12411-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds explicit set type in test definitions, as well as flags.

This has triggered a rework that starts by introducing a Set class to
make this whole code more extensible and maintainable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/sets.t   | 12 ++++----
 tests/py/ip6/sets.t  | 10 +++----
 tests/py/nft-test.py | 78 ++++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 68 insertions(+), 32 deletions(-)

diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index db50b00..2b4e7e1 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -5,12 +5,12 @@
 *inet;test-inet;input
 *netdev;test-netdev;ingress
 
-!set_ipv4_add ipv4_addr;ok
-!set_inet inet_proto;ok
-!set_inet_serv inet_service;ok
-!set_time time;ok
+!w type ipv4_addr;ok
+!x type inet_proto;ok
+!y type inet_service;ok
+!z type time;ok
 
-!set1 ipv4_addr;ok
+!set1 type ipv4_addr;ok
 ?set1 192.168.3.4;ok
 
 ?set1 192.168.3.4;fail
@@ -21,7 +21,7 @@
 ?set1 1234:1234:1234:1234:1234:1234:1234:1234;fail
 ?set2 192.168.3.4;fail
 
-!set2 ipv4_addr;ok
+!set2 type ipv4_addr;ok
 ?set2 192.168.3.4;ok
 ?set2 192.168.3.5 192.168.3.6;ok
 ?set2 192.168.3.5 192.168.3.6;fail
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index 4bfa614..765b971 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -5,13 +5,13 @@
 *inet;test-inet;input
 *netdev;test-netdev;ingress
 
-!set_ipv6_add1 ipv6_addr;ok
-!set_inet1 inet_proto;ok
-!set_inet inet_service;ok
-!set_time time;ok
+!w type ipv6_addr;ok
+!x type inet_proto;ok
+!y type inet_service;ok
+!z type time;ok
 
 ?set2 192.168.3.4;fail
-!set2 ipv6_addr;ok
+!set2 type ipv6_addr;ok
 ?set2 1234:1234::1234:1234:1234:1234:1234;ok
 ?set2 1234:1234::1234:1234:1234:1234:1234;fail
 ?set2 1234::1234:1234:1234;ok
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 1256a33..bba91be 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -69,6 +69,20 @@ class Table:
         return self.__dict__ == other.__dict__
 
 
+class Set:
+    """Class that represents a set"""
+
+    def __init__(self, family, table, name, type, flags):
+        self.family = family
+        self.table = table
+        self.name = name
+        self.type = type
+        self.flags = flags
+
+    def __eq__(self, other):
+        return self.__dict__ == other.__dict__
+
+
 def print_msg(reason, filename=None, lineno=None, color=None, errstr=None):
     '''
     Prints a message with nice colors, indicating file and line number.
@@ -277,7 +291,7 @@ def chain_get_by_name(name):
     return chain
 
 
-def set_add(set_info, filename, lineno):
+def set_add(s, test_result, filename, lineno):
     '''
     Adds a set.
     '''
@@ -287,25 +301,30 @@ def set_add(set_info, filename, lineno):
         return -1
 
     for table in table_list:
-        if set_exist(set_info[0], table, filename, lineno):
-            reason = "This set " + set_info + " exists in " + table.name + \
-                     ". I cannot add it again"
+        s.table = table.name
+        s.family = table.family
+        if _set_exist(s, filename, lineno):
+            reason = "Set " + s.name + " already exists in " + table.name
             print_error(reason, filename, lineno)
             return -1
 
-        table_info = " " + table.family + " " + table.name + " "
-        set_text = " " + set_info[0] + " { type " + set_info[1] + " \;}"
-        cmd = NFT_BIN + " add set" + table_info + set_text
+        table_handle = " " + table.family + " " + table.name + " "
+        if s.flags == "":
+            set_cmd = " " + s.name + " { type " + s.type + "\;}"
+        else:
+            set_cmd = " " + s.name + " { type " + s.type + "\; flags " + s.flags + "\; }"
+
+        cmd = NFT_BIN + " add set" + table_handle + set_cmd
         ret = execute_cmd(cmd, filename, lineno)
 
-        if (ret == 0 and set_info[2].rstrip() == "fail") or \
-                (ret != 0 and set_info[2].rstrip() == "ok"):
-            reason = cmd + ": " + "I cannot add the set " + set_info[0]
+        if (ret == 0 and test_result == "fail") or \
+                (ret != 0 and test_result == "ok"):
+            reason = cmd + ": " + "I cannot add the set " + s.name
             print_error(reason, filename, lineno)
             return -1
 
-        if not set_exist(set_info[0], table, filename, lineno):
-            reason = "I have just added the set " + set_info[0] + \
+        if not _set_exist(s, filename, lineno):
+            reason = "I have just added the set " + s.name + \
                      " to the table " + table.name + " but it does not exist"
             print_error(reason, filename, lineno)
             return -1
@@ -419,6 +438,17 @@ def set_exist(set_name, table, filename, lineno):
     return True if (ret == 0) else False
 
 
+def _set_exist(s, filename, lineno):
+    '''
+    Check if the set exists.
+    '''
+    table_handle = " " + s.family + " " + s.table + " "
+    cmd = NFT_BIN + " list -nnn set" + table_handle + s.name
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+
 def set_check_element(rule1, rule2):
     '''
     Check if element exists in anonymous sets.
@@ -717,14 +747,20 @@ def chain_process(chain_line, lineno):
 
 
 def set_process(set_line, filename, lineno):
-    set_info = []
-    set_name = "".join(set_line[0].rstrip()[1:])
-    set_info.append(set_name)
-    set_type = set_line[1].split(";")[0]
-    set_state = set_line[1].split(";")[1]  # ok or fail
-    set_info.append(set_type)
-    set_info.append(set_state)
-    ret = set_add(set_info, filename, lineno)
+    test_result = set_line[1]
+
+    tokens = set_line[0].split(" ")
+    set_name = tokens[0]
+    set_type = tokens[2]
+
+    if len(tokens) == 5 and tokens[3] == "flags":
+        set_flags = tokens[4]
+    else:
+        set_flags = ""
+
+    s = Set("", "", set_name, set_type, set_flags)
+
+    ret = set_add(s, test_result, filename, lineno)
     if ret == 0:
         all_set[set_name] = set()
 
@@ -808,7 +844,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
             continue
 
         if line[0] == "!":  # Adds this set
-            set_line = line.rstrip()[0:].split(" ")
+            set_line = line.rstrip()[1:].split(";")
             ret = set_process(set_line, filename, lineno)
             tests += 1
             if ret == -1:
-- 
2.1.4

