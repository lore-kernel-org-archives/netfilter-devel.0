Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5675C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 21:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82D5964EBF
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 21:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhBAVuw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 16:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhBAVuv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 16:50:51 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842A4C061573
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 13:50:11 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l6h5G-0004H4-4C; Mon, 01 Feb 2021 22:50:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] tests: add icmp/6 test where dependency should be left alone
Date:   Mon,  1 Feb 2021 22:50:03 +0100
Message-Id: <20210201215005.26612-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These tests fail: nft should leave the type as-is.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/icmp.t                |  2 ++
 tests/py/ip/icmp.t.json           | 28 ++++++++++++++++++++++++++++
 tests/py/ip/icmp.t.payload.ip     |  6 ++++++
 tests/py/ip6/icmpv6.t             |  2 ++
 tests/py/ip6/icmpv6.t.json        | 28 ++++++++++++++++++++++++++++
 tests/py/ip6/icmpv6.t.payload.ip6 |  7 +++++++
 6 files changed, 73 insertions(+)

diff --git a/tests/py/ip/icmp.t b/tests/py/ip/icmp.t
index c22b55eb1e3f..11f3662e2b02 100644
--- a/tests/py/ip/icmp.t
+++ b/tests/py/ip/icmp.t
@@ -86,3 +86,5 @@ icmp gateway != { 33-55};ok
 icmp gateway != 34;ok
 icmp gateway != { 333, 334};ok
 
+icmp code 1 icmp type 2;ok;icmp type 2 icmp code host-unreachable
+icmp code != 1 icmp type 2 icmp mtu 5;fail
diff --git a/tests/py/ip/icmp.t.json b/tests/py/ip/icmp.t.json
index 9691f0727f5e..12b53b0fe2cc 100644
--- a/tests/py/ip/icmp.t.json
+++ b/tests/py/ip/icmp.t.json
@@ -1843,3 +1843,31 @@
         }
     }
 ]
+
+# icmp code 1 icmp type 2
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "code",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": "host-unreachable"
+        }
+    }
+]
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index d75d12a06125..97464a08379e 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -787,3 +787,9 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
   [ immediate reg 0 accept ]
 
+# icmp code 1 icmp type 2
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000102 ]
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index 8b411a8bf439..d07c34bd939d 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -92,3 +92,5 @@ icmpv6 max-delay {33, 55, 67, 88};ok
 icmpv6 max-delay != {33, 55, 67, 88};ok
 icmpv6 max-delay {33-55};ok
 icmpv6 max-delay != {33-55};ok
+
+icmpv6 type parameter-problem icmpv6 code no-route;ok
diff --git a/tests/py/ip6/icmpv6.t.json b/tests/py/ip6/icmpv6.t.json
index ffc4931c4e0c..e2b25a65444f 100644
--- a/tests/py/ip6/icmpv6.t.json
+++ b/tests/py/ip6/icmpv6.t.json
@@ -1315,3 +1315,31 @@
         }
     }
 ]
+
+# icmpv6 type parameter-problem icmpv6 code no-route
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "parameter-problem"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "code",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": "no-route"
+        }
+    }
+]
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 171b7eade6d3..448779d16922 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -682,3 +682,10 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# icmpv6 type parameter-problem icmpv6 code no-route
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000004 ]
+
-- 
2.26.2

