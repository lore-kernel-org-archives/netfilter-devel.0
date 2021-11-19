Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8205C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA37D6152B
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhKSPcT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPcT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 10:32:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AB3C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 07:29:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo5pE-0005Rp-27; Fri, 19 Nov 2021 16:29:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/8] tests: py: add test cases for md5sig, fastopen and mptcp mnemonics
Date:   Fri, 19 Nov 2021 16:28:44 +0100
Message-Id: <20211119152847.18118-6-fw@strlen.de>
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
 tests/py/any/tcpopt.t         |  4 ++++
 tests/py/any/tcpopt.t.json    | 45 +++++++++++++++++++++++++++++++++++
 tests/py/any/tcpopt.t.payload | 14 +++++++++++
 3 files changed, 63 insertions(+)

diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index d3586eae8399..343c76e49a6e 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -46,3 +46,7 @@ tcp option window exists;ok
 tcp option window missing;ok
 
 tcp option maxseg size set 1360;ok
+
+tcp option md5sig exists;ok
+tcp option fastopen exists;ok
+tcp option mptcp exists;ok
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index 5468accb16b4..5c63fd6b2a56 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -487,3 +487,48 @@
         }
     }
 ]
+
+# tcp option md5sig exists
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "name": "md5sig"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# tcp option fastopen exists
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "name": "fastopen"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
+
+# tcp option mptcp exists
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "name": "mptcp"
+                }
+            },
+            "op": "==",
+            "right": true
+        }
+    }
+]
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index d88bcd433a10..7ad19183d4e7 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -153,3 +153,17 @@ inet
   [ immediate reg 1 0x00005005 ]
   [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
 
+# tcp option md5sig exists
+inet
+  [ exthdr load tcpopt 1b @ 19 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option fastopen exists
+inet
+  [ exthdr load tcpopt 1b @ 34 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option mptcp exists
+inet
+  [ exthdr load tcpopt 1b @ 30 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
-- 
2.32.0

