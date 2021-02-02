Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A033BC433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 22:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6555164F53
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 22:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhBBWSa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 17:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbhBBWSQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 17:18:16 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F58DC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2021 14:17:35 -0800 (PST)
Received: from localhost ([::1]:37048 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1l73zJ-0003fv-HP; Tue, 02 Feb 2021 23:17:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] json: Do not abbreviate reject statement object
Date:   Tue,  2 Feb 2021 23:17:24 +0100
Message-Id: <20210202221724.17264-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to reduce output size, also this way output is more predictable.

While being at it, drop some pointless chunks from
tests/py/bridge/reject.t.json.output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c                           |   8 --
 tests/py/bridge/reject.t.json.output | 130 ++++++---------------------
 tests/py/inet/reject.t.json.output   |  15 ++--
 tests/py/ip/reject.t.json.output     |   7 +-
 tests/py/ip6/reject.t.json.output    |   7 +-
 5 files changed, 47 insertions(+), 120 deletions(-)

diff --git a/src/json.c b/src/json.c
index 8371714147de8..0ccbbe8a75d2d 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1380,24 +1380,16 @@ json_t *reject_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 		type = "tcp reset";
 		break;
 	case NFT_REJECT_ICMPX_UNREACH:
-		if (stmt->reject.icmp_code == NFT_REJECT_ICMPX_PORT_UNREACH)
-			break;
 		type = "icmpx";
 		jexpr = expr_print_json(stmt->reject.expr, octx);
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
 		switch (stmt->reject.family) {
 		case NFPROTO_IPV4:
-			if (!stmt->reject.verbose_print &&
-			    stmt->reject.icmp_code == ICMP_PORT_UNREACH)
-				break;
 			type = "icmp";
 			jexpr = expr_print_json(stmt->reject.expr, octx);
 			break;
 		case NFPROTO_IPV6:
-			if (!stmt->reject.verbose_print &&
-			    stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
-				break;
 			type = "icmpv6";
 			jexpr = expr_print_json(stmt->reject.expr, octx);
 			break;
diff --git a/tests/py/bridge/reject.t.json.output b/tests/py/bridge/reject.t.json.output
index 4f83f80374b9a..e01a63af5a354 100644
--- a/tests/py/bridge/reject.t.json.output
+++ b/tests/py/bridge/reject.t.json.output
@@ -1,103 +1,3 @@
-# reject with icmp type host-unreachable
-[
-    {
-        "reject": {
-            "expr": "host-unreachable",
-            "type": "icmp"
-        }
-    }
-]
-
-# reject with icmp type net-unreachable
-[
-    {
-        "reject": {
-            "expr": "net-unreachable",
-            "type": "icmp"
-        }
-    }
-]
-
-# reject with icmp type prot-unreachable
-[
-    {
-        "reject": {
-            "expr": "prot-unreachable",
-            "type": "icmp"
-        }
-    }
-]
-
-# reject with icmp type net-prohibited
-[
-    {
-        "reject": {
-            "expr": "net-prohibited",
-            "type": "icmp"
-        }
-    }
-]
-
-# reject with icmp type host-prohibited
-[
-    {
-        "reject": {
-            "expr": "host-prohibited",
-            "type": "icmp"
-        }
-    }
-]
-
-# reject with icmp type admin-prohibited
-[
-    {
-        "reject": {
-            "expr": "admin-prohibited",
-            "type": "icmp"
-        }
-    }
-]
-
-# reject with icmpv6 type no-route
-[
-    {
-        "reject": {
-            "expr": "no-route",
-            "type": "icmpv6"
-        }
-    }
-]
-
-# reject with icmpv6 type admin-prohibited
-[
-    {
-        "reject": {
-            "expr": "admin-prohibited",
-            "type": "icmpv6"
-        }
-    }
-]
-
-# reject with icmpv6 type addr-unreachable
-[
-    {
-        "reject": {
-            "expr": "addr-unreachable",
-            "type": "icmpv6"
-        }
-    }
-]
-
-# reject with icmpv6 type port-unreachable
-[
-    {
-         "reject": {
-            "expr": "port-unreachable",
-            "type": "icmpv6"
-        }
-    }
-]
-
 # mark 12345 ip protocol tcp reject with tcp reset
 [
     {
@@ -130,10 +30,13 @@
     }
 ]
 
-# reject with icmpx type port-unreachable
+# reject
 [
     {
-        "reject": null
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpx"
+        }
     }
 ]
 
@@ -156,3 +59,26 @@
         }
     }
 ]
+
+# ether type vlan reject
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "ether"
+                }
+            },
+            "op": "==",
+            "right": "vlan"
+        }
+    },
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpx"
+        }
+    }
+]
+
diff --git a/tests/py/inet/reject.t.json.output b/tests/py/inet/reject.t.json.output
index 6e18b96bd807d..043617a721ea4 100644
--- a/tests/py/inet/reject.t.json.output
+++ b/tests/py/inet/reject.t.json.output
@@ -25,30 +25,33 @@
     }
 ]
 
-# meta nfproto ipv4 reject
+# reject
 [
     {
         "reject": {
             "expr": "port-unreachable",
-            "type": "icmp"
+            "type": "icmpx"
         }
     }
 ]
 
-# meta nfproto ipv6 reject
+# meta nfproto ipv4 reject
 [
     {
         "reject": {
             "expr": "port-unreachable",
-            "type": "icmpv6"
+            "type": "icmp"
         }
     }
 ]
 
-# reject with icmpx type port-unreachable
+# meta nfproto ipv6 reject
 [
     {
-        "reject": null
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpv6"
+        }
     }
 ]
 
diff --git a/tests/py/ip/reject.t.json.output b/tests/py/ip/reject.t.json.output
index b2529dd75fb51..3917413dcfbe4 100644
--- a/tests/py/ip/reject.t.json.output
+++ b/tests/py/ip/reject.t.json.output
@@ -1,7 +1,10 @@
-# reject with icmp type port-unreachable
+# reject
 [
     {
-        "reject": null
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmp"
+        }
     }
 ]
 
diff --git a/tests/py/ip6/reject.t.json.output b/tests/py/ip6/reject.t.json.output
index 4e2058feceed6..04f12f56e9765 100644
--- a/tests/py/ip6/reject.t.json.output
+++ b/tests/py/ip6/reject.t.json.output
@@ -1,7 +1,10 @@
-# reject with icmpv6 type port-unreachable
+# reject
 [
     {
-        "reject": null
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpv6"
+        }
     }
 ]
 
-- 
2.28.0

