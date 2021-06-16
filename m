Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A8EC48BE8
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 18:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB7FB613DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Jun 2021 18:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhFPSLx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Jun 2021 14:11:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46472 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhFPSLx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Jun 2021 14:11:53 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B653D64252
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Jun 2021 20:08:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] evaluate: unbreak verdict maps with implicit map with interval concatenations
Date:   Wed, 16 Jun 2021 20:09:41 +0200
Message-Id: <20210616180941.78202-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616180941.78202-1-pablo@netfilter.org>
References: <20210616180941.78202-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Verdict maps in combination with interval concatenations are broken, e.g.

 # nft add rule x y tcp dport . ip saddr vmap { 1025-65535 . 192.168.10.2 : accept }

Retrieve the concatenation field length and count from the map->map
expressions that represents the key of the implicit map.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                  |  8 ++++++
 tests/py/ip/ip.t                |  1 +
 tests/py/ip/ip.t.json           | 50 +++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload        |  8 ++++++
 tests/py/ip/ip.t.payload.bridge | 11 ++++++++
 tests/py/ip/ip.t.payload.inet   | 11 ++++++++
 tests/py/ip/ip.t.payload.netdev | 11 ++++++++
 7 files changed, 100 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index d220c8e391ac..77fb24594735 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1564,6 +1564,14 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		ctx->set = NULL;
 		map = *expr;
 		map->mappings->set->flags |= map->mappings->set->init->set_flags;
+
+		if (map->mappings->set->flags & NFT_SET_INTERVAL &&
+		    map->map->etype == EXPR_CONCAT) {
+			memcpy(&map->mappings->set->desc.field_len, &map->map->field_len,
+			       sizeof(map->mappings->set->desc.field_len));
+			map->mappings->set->desc.field_count = map->map->field_count;
+			map->mappings->flags |= NFT_SET_CONCAT;
+		}
 		break;
 	case EXPR_SYMBOL:
 		if (expr_evaluate(ctx, &map->mappings) < 0)
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index b74d465fcbe6..f4a3667ceab5 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -125,3 +125,4 @@ iif "lo" ip dscp set af23;ok
 iif "lo" ip dscp set cs0;ok
 
 ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 };ok
+ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept };ok
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index 32312b152ccf..b1085035a000 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -1635,3 +1635,53 @@
         }
     }
 ]
+
+# ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept }
+[
+    {
+        "vmap": {
+            "data": {
+                "set": [
+                    [
+                        {
+                            "concat": [
+                                {
+                                    "range": [
+                                        "192.168.5.1",
+                                        "192.168.5.128"
+                                    ]
+                                },
+                                {
+                                    "range": [
+                                        "192.168.6.1",
+                                        "192.168.6.128"
+                                    ]
+                                }
+                            ]
+                        },
+                        {
+                            "accept": null
+                        }
+                    ]
+                ]
+            },
+            "key": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip"
+                        }
+                    }
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 4bb177526971..49d1a0fb03e8 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -515,3 +515,11 @@ ip
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __set%d ]
 
+# ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept }
+__map%d test-ip4 8f size 1
+__map%d test-ip4 0
+        element 0105a8c0 0106a8c0  - 8005a8c0 8006a8c0  : accept 0 [end]
+ip
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index c8c1dbadee14..dac8654395f4 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -673,3 +673,14 @@ bridge
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __set%d ]
 
+# ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept }
+__map%d test-bridge 8f size 1
+__map%d test-bridge 0
+        element 0105a8c0 0106a8c0  - 8005a8c0 8006a8c0  : accept 0 [end]
+bridge
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 55304fc9d871..64371650480f 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -673,3 +673,14 @@ inet
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __set%d ]
 
+# ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept }
+__map%d test-inet 8f size 1
+__map%d test-inet 0
+        element 0105a8c0 0106a8c0  - 8005a8c0 8006a8c0  : accept 0 [end]
+inet
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 712cb3756149..65f8c96a9470 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -673,3 +673,14 @@ netdev
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __set%d ]
 
+# ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept }
+__map%d test-netdev 8f size 1
+__map%d test-netdev 0
+        element 0105a8c0 0106a8c0  - 8005a8c0 8006a8c0  : accept 0 [end]
+netdev
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
-- 
2.30.2

