Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7EEC04AB4
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B64E4204EC
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfESRSu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 13:18:50 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53416 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbfESRSu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 13:18:50 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hSPSQ-0003tb-Ge; Sun, 19 May 2019 19:18:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: kill anon sets with one element
Date:   Sun, 19 May 2019 19:18:38 +0200
Message-Id: <20190519171838.3811-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

convert "ip saddr { 1.1.1.1 }" to "ip saddr 1.1.1.1".
Both do the same, but second form is faster since no single-element
anon set is created.

Fix up the remaining test cases to expect transformations of the form
"meta l4proto { 33-55}" to "meta l4proto 33-55".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                              | 19 ++++++
 tests/py/any/meta.t                         |  8 +--
 tests/py/any/meta.t.json                    | 49 +++++++------
 tests/py/any/meta.t.payload                 | 35 +++-------
 tests/py/ip/igmp.t                          |  6 +-
 tests/py/ip/igmp.t.json                     | 56 +++------------
 tests/py/ip/igmp.t.payload                  | 76 +++------------------
 tests/shell/testcases/nft-f/0016redefines_1 |  2 +-
 8 files changed, 81 insertions(+), 170 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 21d9e146e587..cfdf48c6f5b7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1253,6 +1253,7 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *set = *expr, *i, *next;
+	unsigned int count = 0;
 
 	list_for_each_entry_safe(i, next, &set->expressions, list) {
 		if (list_member_evaluate(ctx, &i) < 0)
@@ -1277,6 +1278,8 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			return expr_error(ctx->msgs, i,
 					  "Set member is not constant");
 
+		count++;
+
 		if (i->etype == EXPR_SET) {
 			/* Merge recursive set definitions */
 			list_splice_tail_init(&i->expressions, &i->list);
@@ -1288,6 +1291,22 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
 			set->set_flags |= NFT_SET_INTERVAL;
 	}
 
+	if (!ctx->set && count == 1) {
+		i = list_first_entry(&set->expressions, struct expr, list);
+		if (i->etype == EXPR_SET_ELEM) {
+			switch (i->key->etype) {
+			case EXPR_RANGE:
+			case EXPR_VALUE:
+				*expr = i->key;
+				i->key = NULL;
+				expr_free(set);
+				return 0;
+			default:
+				break;
+			}
+		}
+	}
+
 	set->set_flags |= NFT_SET_CONSTANT;
 
 	set->dtype = ctx->ectx.dtype;
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 3d3ddad94aa3..8aea664794ad 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -29,7 +29,7 @@ meta l4proto 33-45;ok
 meta l4proto != 33-45;ok
 meta l4proto { 33, 55, 67, 88};ok;meta l4proto { 33, 55, 67, 88}
 meta l4proto != { 33, 55, 67, 88};ok
-meta l4proto != { 33-55};ok
+meta l4proto != { 33-55};ok;meta l4proto != 33-55
 
 meta priority root;ok
 meta priority none;ok
@@ -78,7 +78,7 @@ meta iiftype ppp;ok
 
 meta oif "lo" accept;ok;oif "lo" accept
 meta oif != "lo" accept;ok;oif != "lo" accept
-meta oif {"lo"} accept;ok;oif {"lo"} accept
+meta oif {"lo"} accept;ok;oif "lo" accept
 
 meta oifname "dummy0";ok;oifname "dummy0"
 meta oifname != "dummy0";ok;oifname != "dummy0"
@@ -166,9 +166,9 @@ meta iifgroup != 0;ok;iifgroup != "default"
 meta iifgroup "default";ok;iifgroup "default"
 meta iifgroup != "default";ok;iifgroup != "default"
 meta iifgroup { 11,33};ok;iifgroup { 11,33}
-meta iifgroup {11-33};ok;iifgroup {11-33}
+meta iifgroup {11-33};ok;iifgroup 11-33
 meta iifgroup != { 11,33};ok;iifgroup != { 11,33}
-meta iifgroup != {11-33};ok;iifgroup != {11-33}
+meta iifgroup != {11-33};ok;iifgroup != 11-33
 meta oifgroup 0;ok;oifgroup "default"
 meta oifgroup != 0;ok;oifgroup != "default"
 meta oifgroup "default";ok;oifgroup "default"
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index e4d22fa749b5..b5fc767242fb 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -310,12 +310,15 @@
     {
         "match": {
             "left": {
-                "meta": { "key": "l4proto" }
+                "meta": {
+                    "key": "l4proto"
+                }
             },
             "op": "!=",
             "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
+                "range": [
+                    33,
+                    55
                 ]
             }
         }
@@ -934,14 +937,12 @@
     {
         "match": {
             "left": {
-                "meta": { "key": "oif" }
+                "meta": {
+                    "key": "oif"
+                }
             },
             "op": "==",
-            "right": {
-                "set": [
-                    "lo"
-                ]
-            }
+            "right": "lo"
         }
     },
     {
@@ -1889,33 +1890,38 @@
     }
 ]
 
-# meta iifgroup {11-33}
+# meta iifgroup != { 11,33}
 [
     {
         "match": {
             "left": {
-                "meta": { "key": "iifgroup" }
+                "meta": {
+                    "key": "iifgroup"
+                }
             },
-            "op": "==",
+            "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 11, 33 ] }
+                    11,
+                    33
                 ]
             }
         }
     }
 ]
 
-# meta iifgroup != { 11,33}
+# meta iifgroup {11-33}
 [
     {
         "match": {
             "left": {
-                "meta": { "key": "iifgroup" }
+                "meta": {
+                    "key": "iifgroup"
+                }
             },
-            "op": "!=",
+            "op": "==",
             "right": {
-                "set": [
+                "range": [
                     11,
                     33
                 ]
@@ -1929,12 +1935,15 @@
     {
         "match": {
             "left": {
-                "meta": { "key": "iifgroup" }
+                "meta": {
+                    "key": "iifgroup"
+                }
             },
             "op": "!=",
             "right": {
-                "set": [
-                    { "range": [ 11, 33 ] }
+                "range": [
+                    11,
+                    33
                 ]
             }
         }
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 2fb352430663..9733167cf07b 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -126,13 +126,10 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d 0x1 ]
 
 # meta l4proto != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 2, 1) ]
-  [ lookup reg 1 set __set%d 0x1 ]
+  [ range neq reg 1 0x00000021 0x00000037 ]
 
 # meta mark 0x4
 ip test-ip4 input
@@ -285,12 +282,9 @@ ip test-ip4 input
   [ immediate reg 0 accept ]
 
 # meta oif {"lo"} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000001  : 0 [end]
 ip test-ip4 input
   [ meta load oif => reg 1 ]
-  [ lookup reg 1 set __set%d ]
+  [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
 # meta oifname "dummy0"
@@ -652,12 +646,9 @@ ip test-ip4 input
   [ cmp neq reg 1 0x00000000 ]
 
 # meta iifgroup {"default"}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000000  : 0 [end]
 ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
-  [ lookup reg 1 set __set%d ]
+  [ cmp eq reg 1 0x00000000 ]
 
 # meta iifgroup { 11,33}
 __set%d test-ip4 3
@@ -668,13 +659,11 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d ]
 
 # meta iifgroup {11-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
 ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d ]
+  [ cmp gte reg 1 0x0b000000 ]
+  [ cmp lte reg 1 0x21000000 ]
 
 # meta iifgroup != { 11,33}
 __set%d test-ip4 3
@@ -685,13 +674,10 @@ ip test-ip4 input
   [ lookup reg 1 set __set%d 0x1 ]
 
 # meta iifgroup != {11-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0b000000  : 0 [end]	element 22000000  : 1 [end]
-ip test-ip4 input
+ip test-ip4 input 
   [ meta load iifgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d 0x1 ]
+  [ range neq reg 1 0x0b000000 0x21000000 ]
 
 # meta oifgroup 0
 ip test-ip4 input
@@ -714,12 +700,9 @@ ip test-ip4 input
   [ cmp neq reg 1 0x00000000 ]
 
 # meta oifgroup != {"default"}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000000  : 0 [end]
-ip test-ip4 input
+ip test-ip4 input 
   [ meta load oifgroup => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
+  [ cmp neq reg 1 0x00000000 ]
 
 # meta oifgroup { 11,33}
 __set%d test-ip4 3
diff --git a/tests/py/ip/igmp.t b/tests/py/ip/igmp.t
index 939dcc32b248..7a39348a7f84 100644
--- a/tests/py/ip/igmp.t
+++ b/tests/py/ip/igmp.t
@@ -16,10 +16,8 @@ igmp checksum 12343;ok
 igmp checksum != 12343;ok
 igmp checksum 11-343;ok
 igmp checksum != 11-343;ok
-igmp checksum { 11-343};ok
-igmp checksum != { 11-343};ok
-igmp checksum { 1111, 222, 343};ok
-igmp checksum != { 1111, 222, 343};ok
+igmp checksum { 1111, 222, 343, 11-22 };ok
+igmp checksum != { 1111, 222, 343, 11-22 };ok
 
 igmp mrt 10;ok
 igmp mrt != 10;ok
diff --git a/tests/py/ip/igmp.t.json b/tests/py/ip/igmp.t.json
index 66dd3bb70c5b..722720166375 100644
--- a/tests/py/ip/igmp.t.json
+++ b/tests/py/ip/igmp.t.json
@@ -196,7 +196,7 @@
     }
 ]
 
-# igmp checksum { 11-343}
+# igmp checksum { 1111, 222, 343, 11-22 }
 [
     {
         "match": {
@@ -212,16 +212,19 @@
                     {
                         "range": [
                             11,
-                            343
+                            22
                         ]
-                    }
+                    },
+                    222,
+                    343,
+                    1111
                 ]
             }
         }
     }
 ]
 
-# igmp checksum != { 11-343}
+# igmp checksum != { 1111, 222, 343, 11-22 }
 [
     {
         "match": {
@@ -237,50 +240,9 @@
                     {
                         "range": [
                             11,
-                            343
+                            22
                         ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# igmp checksum { 1111, 222, 343}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "igmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    222,
-                    343,
-                    1111
-                ]
-            }
-        }
-    }
-]
-
-# igmp checksum != { 1111, 222, 343}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "igmp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
+                    },
                     222,
                     343,
                     1111
diff --git a/tests/py/ip/igmp.t.payload b/tests/py/ip/igmp.t.payload
index 1319c3246f0b..b34380650da5 100644
--- a/tests/py/ip/igmp.t.payload
+++ b/tests/py/ip/igmp.t.payload
@@ -62,26 +62,6 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00000b00 0x00005701 ]
 
-# igmp checksum { 11-343}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# igmp checksum != { 11-343}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # igmp checksum { 1111, 222, 343}
 __set%d test-ip4 3 size 3
 __set%d test-ip4 0
@@ -186,26 +166,6 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00000b00 0x00005701 ]
 
-# igmp checksum { 11-343}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# igmp checksum != { 11-343}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # igmp checksum { 1111, 222, 343}
 __set%d test-ip4 3 size 3
 __set%d test-ip4 0
@@ -310,41 +270,21 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00000b00 0x00005701 ]
 
-# igmp checksum { 11-343}
-__set%d test-ip4 7 size 3
+# igmp checksum { 1111, 222, 343, 11-22 }
+__set%d test-ip4 7 size 9
 __set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
+	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00001700  : 1 [end]	element 0000de00  : 0 [end]	element 0000df00  : 1 [end]	element 00005701  : 0 [end]	element 00005801  : 1 [end]	element 00005704  : 0 [end]	element 00005804  : 1 [end]
+ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# igmp checksum != { 11-343}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# igmp checksum { 1111, 222, 343}
-__set%d test-ip4 3 size 3
+# igmp checksum != { 1111, 222, 343, 11-22 }
+__set%d test-ip4 7 size 9
 __set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# igmp checksum != { 1111, 222, 343}
-__set%d test-ip4 3 size 3
-__set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
-ip test-ip4 input 
+	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00001700  : 1 [end]	element 0000de00  : 0 [end]	element 0000df00  : 1 [end]	element 00005701  : 0 [end]	element 00005801  : 1 [end]	element 00005704  : 0 [end]	element 00005804  : 1 [end]
+ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
diff --git a/tests/shell/testcases/nft-f/0016redefines_1 b/tests/shell/testcases/nft-f/0016redefines_1
index d0148d65da54..a6e857bd13c0 100755
--- a/tests/shell/testcases/nft-f/0016redefines_1
+++ b/tests/shell/testcases/nft-f/0016redefines_1
@@ -17,7 +17,7 @@ table ip x {
 EXPECTED="table ip x {
 	chain y {
 		ip saddr { 1.1.1.1, 2.2.2.2 }
-		ip saddr { 3.3.3.3 }
+		ip saddr 3.3.3.3
 	}
 }"
 
-- 
2.21.0

