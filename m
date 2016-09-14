From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] tests: py: add more test cases for queue expr
Date: Thu, 15 Sep 2016 00:02:09 +0800
Message-ID: <1473868929-54533-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:58876 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756501AbcINQCk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Sep 2016 12:02:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

It's necessary to cover more test cases, for example, large queue
range 1-65535, error queue number 65536.

Also add a space before tailing square brackets, this is updated to
keep consistent with other expr.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 tests/py/any/queue.t         |  3 +++
 tests/py/any/queue.t.payload | 20 ++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/tests/py/any/queue.t b/tests/py/any/queue.t
index a1aefa1..75c071d 100644
--- a/tests/py/any/queue.t
+++ b/tests/py/any/queue.t
@@ -8,7 +8,10 @@
 
 queue;ok;queue num 0
 queue num 2;ok
+queue num 65535;ok
+queue num 65536;fail
 queue num 2-3;ok
+queue num 1-65535;ok
 - queue num {3, 4, 6};ok
 queue num 4-5 fanout bypass;ok;queue num 4-5 bypass,fanout
 queue num 4-5 fanout;ok
diff --git a/tests/py/any/queue.t.payload b/tests/py/any/queue.t.payload
index 43a6650..78d939c 100644
--- a/tests/py/any/queue.t.payload
+++ b/tests/py/any/queue.t.payload
@@ -1,24 +1,32 @@
 # queue
 ip test-ip4 output
-  [ queue num 0]
+  [ queue num 0 ]
 
 # queue num 2
 ip test-ip4 output
-  [ queue num 2]
+  [ queue num 2 ]
+
+# queue num 65535
+ip test-ip4 output
+  [ queue num 65535 ]
 
 # queue num 2-3
 ip test-ip4 output
-  [ queue num 2-3]
+  [ queue num 2-3 ]
+
+# queue num 1-65535
+ip test-ip4 output
+  [ queue num 1-65535 ]
 
 # queue num 4-5 fanout bypass
 ip test-ip4 output
-  [ queue num 4-5 bypass fanout]
+  [ queue num 4-5 bypass fanout ]
 
 # queue num 4-5 fanout
 ip test-ip4 output
-  [ queue num 4-5 fanout]
+  [ queue num 4-5 fanout ]
 
 # queue num 4-5 bypass
 ip test-ip4 output
-  [ queue num 4-5 bypass]
+  [ queue num 4-5 bypass ]
 
-- 
2.5.5


