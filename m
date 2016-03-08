From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/4] nft-test: don't zap remainder of rule after handling a set
Date: Wed,  9 Mar 2016 00:09:47 +0100
Message-ID: <1457478588-12592-3-git-send-email-fw@strlen.de>
References: <1457478588-12592-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39526 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbcCHXQ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 18:16:57 -0500
In-Reply-To: <1457478588-12592-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't delete the part after the set, i.e. given

 chain input {
     type filter hook input priority 0; policy accept;
     vlan id { 1, 2, 4, 100, 4095} vlan pcp 1-3
 }

don't remove the vlan pcp 1-3 part.

This exposes following bug:

bridge/vlan.t: WARNING: line: 32:
'nft add rule --debug=netlink bridge test-bridge input vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3': 'vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3' mismatches 'vlan id { 4, 1, 2, 4095, 100} vlan pcp 0-0'

We do not shift the range, so on reverse translation we get a 0-0 output.
The bug will be fixes in a followup commit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/tcp.t  |  2 +-
 tests/py/nft-test.py | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index f99035e..9618e53 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -37,7 +37,7 @@ tcp sport 1024 tcp dport 22;ok
 tcp sport 1024 tcp dport 22 tcp sequence 0;ok
 
 tcp sequence 0 tcp sport 1024 tcp dport 22;ok;tcp sport 1024 tcp dport 22 tcp sequence 0
-tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22;ok
+tcp sequence 0 tcp sport { 1024, 1022} tcp dport 22;ok;tcp sport { 1022, 1024} tcp dport 22 tcp sequence 0
 
 tcp sequence 22;ok
 tcp sequence != 233;ok
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 9dc2b95..1256a33 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -436,21 +436,27 @@ def set_check_element(rule1, rule2):
         list2.sort()
         if cmp(list1, list2) == 0:
             ret = 0
-    return ret
 
+    if ret != 0:
+        return ret
+
+    return cmp(rule1[end1:], rule2[end2:])
 
 def output_clean(pre_output, chain):
-    pos_chain = pre_output[0].find(chain.name)
+    pos_chain = pre_output.find(chain.name)
     if pos_chain == -1:
         return ""
-    output_intermediate = pre_output[0][pos_chain:]
+    output_intermediate = pre_output[pos_chain:]
     brace_start = output_intermediate.find("{")
     brace_end = output_intermediate.find("}")
     pre_rule = output_intermediate[brace_start:brace_end]
     if pre_rule[1:].find("{") > -1:  # this rule has a set.
         set = pre_rule[1:].replace("\t", "").replace("\n", "").strip()
         set = set.split(";")[2].strip() + "}"
-        return set
+        remainder = output_clean(chain.name + " {;;" + output_intermediate[brace_end+1:], chain)
+        if len(remainder) <= 0:
+            return set
+        return set + " " + remainder
     else:
         rule = pre_rule.split(";")[2].replace("\t", "").replace("\n", "").\
             strip()
@@ -604,7 +610,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
                     if not force_all_family_option:
                         return [ret, warning, error, unit_tests]
                 else:
-                    rule_output = output_clean(pre_output, chain)
+                    rule_output = output_clean(pre_output[0], chain)
                     if len(rule) == 3:
                         teoric_exit = rule[2]
                     else:
@@ -612,7 +618,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
 
                     if rule_output.rstrip() != teoric_exit.rstrip():
                         if rule[0].find("{") != -1:  # anonymous sets
-                            if set_check_element(teoric_exit, rule_output) != 0:
+                            if set_check_element(teoric_exit.rstrip(), rule_output.rstrip()) != 0:
                                 warning += 1
                                 print_differences_warning(filename, lineno,
                                                           rule[0], rule_output,
-- 
2.4.10

