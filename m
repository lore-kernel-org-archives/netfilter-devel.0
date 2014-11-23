From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [nft-tests 1/2] tests: regression: don't use -nnn for non-list commands
Date: Sun, 23 Nov 2014 22:22:47 +0100
Message-ID: <1416777768-1577-1-git-send-email-pablo@netfilter.org>
Cc: anarey@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45300 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbaKWVUs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Nov 2014 16:20:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not useful, they just bloat the nft-tests.py output.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/nft-test.py |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index 00c33f3..e1aec89 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -305,7 +305,7 @@ def set_add_elements(set_element, set_name, set_all, state, table_list,
                 element = element + ", " + e
 
         set_text = set_name + " { " + element + " }"
-        cmd = "nft add element -nnn" + table_info + set_text
+        cmd = "nft add element" + table_info + set_text
         ret = execute_cmd(cmd, filename, lineno)
 
         if (state == "fail" and ret == 0) or (state == "ok" and ret != 0):
@@ -331,7 +331,7 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 
     for element in set_element:
         set_text = set_name + " {" + element + "}"
-        cmd = "nft delete element -nnn" + table_info + set_text
+        cmd = "nft delete element" + table_info + set_text
         ret = execute_cmd(cmd, filename, lineno)
         if ret != 0:
             reason = "I cannot delete an element" + element + \
@@ -447,7 +447,7 @@ def rule_add(rule, table_list, chain_list, filename, lineno,
             unit_tests += 1
             table_flush(table, filename, lineno)
             table_info = " " + table[0] + " " + table[1] + " "
-            cmd = "nft add rule -nnn" + table_info + chain + " " + rule[0]
+            cmd = "nft add rule" + table_info + chain + " " + rule[0]
 
             ret = execute_cmd(cmd, filename, lineno)
 
-- 
1.7.10.4

