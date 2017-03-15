From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nftables 6/7] tests: add insert-failure test
Date: Wed, 15 Mar 2017 16:01:10 +0100
Message-ID: <20170315150111.18477-7-fw@strlen.de>
References: <20170315150111.18477-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46452 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753100AbdCOPBP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 11:01:15 -0400
In-Reply-To: <20170315150111.18477-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It should not be possible to add a ip6 restricted helper to ip family.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 not part of v1 series.

 tests/py/ip/objects.t |  1 +
 tests/py/nft-test.py  | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tests/py/ip/objects.t b/tests/py/ip/objects.t
index ec8e8fd916d4..742ec6af2572 100644
--- a/tests/py/ip/objects.t
+++ b/tests/py/ip/objects.t
@@ -6,6 +6,7 @@
 %cnt2 type counter;ok
 %qt1 type quota 25 mbytes;ok
 %qt2 type quota over 1 kbytes;ok
+%cthelp2 type ct helper { type \"ftp\" protocol tcp\; l3proto ip6\; };fail
 
 ip saddr 192.168.1.3 counter name "cnt2";ok
 ip saddr 192.168.1.3 counter name "cnt3";fail
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index b22404076edd..8d1df3bc517a 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -517,12 +517,23 @@ def obj_add(o, test_result, filename, lineno):
             print_error(reason, filename, lineno)
             return -1
 
-        if not _obj_exist(o, filename, lineno):
-            reason = "I have just added the " + obj_handle + \
-                     " to the table " + table.name + " but it does not exist"
+        exist = _obj_exist(o, filename, lineno)
+
+        if exist:
+            if test_result == "ok":
+                 return 0
+            reason = "I added the " + obj_handle + \
+                     " to the table " + table.name + " but it should have failed"
             print_error(reason, filename, lineno)
             return -1
 
+        if test_result == "fail":
+            return 0
+
+        reason = "I have just added the " + obj_handle + \
+                 " to the table " + table.name + " but it does not exist"
+        print_error(reason, filename, lineno)
+        return -1
 
 def obj_delete(table, filename=None, lineno=None):
     '''
-- 
2.10.2

