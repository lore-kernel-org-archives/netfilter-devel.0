Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7FEC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D465561B1B
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhKSPcc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPcc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 10:32:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E27C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 07:29:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo5pR-0005Su-59; Fri, 19 Nov 2021 16:29:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 8/8] tests: py: add tcp subtype match test cases
Date:   Fri, 19 Nov 2021 16:28:47 +0100
Message-Id: <20211119152847.18118-9-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119152847.18118-1-fw@strlen.de>
References: <20211119152847.18118-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/tcpopt.t         |  4 +++
 tests/py/any/tcpopt.t.json    | 53 +++++++++++++++++++++++++++++++++++
 tests/py/any/tcpopt.t.payload | 21 ++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index 343c76e49a6e..3d4be2a274df 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -50,3 +50,7 @@ tcp option maxseg size set 1360;ok
 tcp option md5sig exists;ok
 tcp option fastopen exists;ok
 tcp option mptcp exists;ok
+
+tcp option mptcp subtype 0;ok
+tcp option mptcp subtype 1;ok
+tcp option mptcp subtype { 0, 2};ok
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index 5c63fd6b2a56..5cc6f8f42446 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -532,3 +532,56 @@
         }
     }
 ]
+
+# tcp option mptcp subtype 0
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "field": "subtype",
+                    "name": "mptcp"
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    }
+]
+
+# tcp option mptcp subtype 1
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "field": "subtype",
+                    "name": "mptcp"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# tcp option mptcp subtype { 0, 2}
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "field": "subtype",
+                    "name": "mptcp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    0,
+                    2
+                ]
+            }
+        }
+   }
+]
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 7ad19183d4e7..121cc97fac09 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -167,3 +167,24 @@ inet
 inet
   [ exthdr load tcpopt 1b @ 30 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
+
+# tcp option mptcp subtype 0
+inet
+  [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# tcp option mptcp subtype 1
+inet
+  [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000010 ]
+
+# tcp option mptcp subtype { 0, 2}
+__set%d test-inet 3 size 2
+__set%d test-inet 0
+	element 00000000  : 0 [end]	element 00000020  : 0 [end]
+inet
+  [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
-- 
2.32.0

