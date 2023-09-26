Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE88E7E644
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 15:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbjIZPZQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 11:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjIZPZP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 11:25:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 235D711F
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 08:25:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] tests: py: add map support
Date:   Tue, 26 Sep 2023 17:24:58 +0200
Message-Id: <20230926152500.30571-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add basic map support to this infrastructure, eg.

  !map1 ipv4_addr : mark;ok

Adding elements to map is still not supported.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/nft-test.py | 70 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index b66a33c21f66..9a25503d1f38 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -86,11 +86,12 @@ class Table:
 class Set:
     """Class that represents a set"""
 
-    def __init__(self, family, table, name, type, timeout, flags):
+    def __init__(self, family, table, name, type, data, timeout, flags):
         self.family = family
         self.table = table
         self.name = name
         self.type = type
+        self.data = data
         self.timeout = timeout
         self.flags = flags
 
@@ -366,7 +367,11 @@ def set_add(s, test_result, filename, lineno):
         if flags != "":
             flags = "flags %s; " % flags
 
-        cmd = "add set %s %s { type %s;%s %s}" % (table, s.name, s.type, s.timeout, flags)
+        if s.data == "":
+                cmd = "add set %s %s { type %s;%s %s}" % (table, s.name, s.type, s.timeout, flags)
+        else:
+                cmd = "add map %s %s { type %s : %s;%s %s}" % (table, s.name, s.type, s.data, s.timeout, flags)
+
         ret = execute_cmd(cmd, filename, lineno)
 
         if (ret == 0 and test_result == "fail") or \
@@ -384,6 +389,44 @@ def set_add(s, test_result, filename, lineno):
     return 0
 
 
+def map_add(s, test_result, filename, lineno):
+    '''
+    Adds a map
+    '''
+    if not table_list:
+        reason = "Missing table to add rule"
+        print_error(reason, filename, lineno)
+        return -1
+
+    for table in table_list:
+        s.table = table.name
+        s.family = table.family
+        if _map_exist(s, filename, lineno):
+            reason = "Map %s already exists in %s" % (s.name, table)
+            print_error(reason, filename, lineno)
+            return -1
+
+        flags = s.flags
+        if flags != "":
+            flags = "flags %s; " % flags
+
+        cmd = "add map %s %s { type %s : %s;%s %s}" % (table, s.name, s.type, s.data, s.timeout, flags)
+
+        ret = execute_cmd(cmd, filename, lineno)
+
+        if (ret == 0 and test_result == "fail") or \
+                (ret != 0 and test_result == "ok"):
+            reason = "%s: I cannot add the set %s" % (cmd, s.name)
+            print_error(reason, filename, lineno)
+            return -1
+
+        if not _map_exist(s, filename, lineno):
+            reason = "I have just added the set %s to " \
+                     "the table %s but it does not exist" % (s.name, table)
+            print_error(reason, filename, lineno)
+            return -1
+
+
 def set_add_elements(set_element, set_name, state, filename, lineno):
     '''
     Adds elements to the set.
@@ -490,6 +533,16 @@ def _set_exist(s, filename, lineno):
     return True if (ret == 0) else False
 
 
+def _map_exist(s, filename, lineno):
+    '''
+    Check if the map exists.
+    '''
+    cmd = "list map %s %s %s" % (s.family, s.table, s.name)
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+
 def set_check_element(rule1, rule2):
     '''
     Check if element exists in anonymous sets.
@@ -1092,6 +1145,7 @@ def set_process(set_line, filename, lineno):
     tokens = set_line[0].split(" ")
     set_name = tokens[0]
     set_type = tokens[2]
+    set_data = ""
     set_flags = ""
 
     i = 3
@@ -1099,6 +1153,10 @@ def set_process(set_line, filename, lineno):
         set_type += " . " + tokens[i+1]
         i += 2
 
+    while len(tokens) > i and tokens[i] == ":":
+        set_data = tokens[i+1]
+        i += 2
+
     if len(tokens) == i+2 and tokens[i] == "timeout":
         timeout = "timeout " + tokens[i+1] + ";"
         i += 2
@@ -1108,9 +1166,13 @@ def set_process(set_line, filename, lineno):
     elif len(tokens) != i:
         print_error(set_name + " bad flag: " + tokens[i], filename, lineno)
 
-    s = Set("", "", set_name, set_type, timeout, set_flags)
+    s = Set("", "", set_name, set_type, set_data, timeout, set_flags)
+
+    if set_data == "":
+        ret = set_add(s, test_result, filename, lineno)
+    else:
+        ret = map_add(s, test_result, filename, lineno)
 
-    ret = set_add(s, test_result, filename, lineno)
     if ret == 0:
         all_set[set_name] = set()
 
-- 
2.30.2

