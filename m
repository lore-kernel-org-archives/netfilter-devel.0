Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE273C6379F
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 22:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbjBVWME (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 17:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjBVWMB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 17:12:01 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F19E42BD1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 14:11:45 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: expand value to range in nat mapping with intervals
Date:   Wed, 22 Feb 2023 23:11:38 +0100
Message-Id: <20230222221139.2670-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the data in the mapping contains a range, then upgrade value to range.

/dev/stdin:11:57-75: Error: Could not process rule: Invalid argument
dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
                                    ^^^^^^^^^^^^^^^^^^^

Fixes: 9599d9d25a6b ("src: NAT support for intervals in maps")
Fixes: 66746e7dedeb ("src: support for nat with interval concatenation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                | 26 +++++++++++++++++--
 tests/shell/testcases/sets/0047nat_0          |  5 ++++
 .../shell/testcases/sets/dumps/0047nat_0.nft  |  5 ++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d24f8b66b0de..f37f3c2bb70f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1805,10 +1805,28 @@ static void map_set_concat_info(struct expr *map)
 	}
 }
 
+static void mapping_expr_expand(struct expr *init)
+{
+	struct expr *i, *range;
+
+	list_for_each_entry(i, &init->expressions, list) {
+		assert(i->etype == EXPR_MAPPING);
+		switch (i->right->etype) {
+		case EXPR_VALUE:
+			range = range_expr_alloc(&i->location, expr_get(i->right), expr_get(i->right));
+			expr_free(i->right);
+			i->right = range;
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct expr_ctx ectx = ctx->ectx;
 	struct expr *map = *expr, *mappings;
+	struct expr_ctx ectx = ctx->ectx;
 	const struct datatype *dtype;
 	struct expr *key, *data;
 
@@ -1879,9 +1897,13 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		if (binop_transfer(ctx, expr) < 0)
 			return -1;
 
-		if (ctx->set->data->flags & EXPR_F_INTERVAL)
+		if (ctx->set->data->flags & EXPR_F_INTERVAL) {
 			ctx->set->data->len *= 2;
 
+			if (set_is_anonymous(ctx->set->flags))
+				mapping_expr_expand(ctx->set->init);
+		}
+
 		ctx->set->key->len = ctx->ectx.len;
 		ctx->set = NULL;
 		map = *expr;
diff --git a/tests/shell/testcases/sets/0047nat_0 b/tests/shell/testcases/sets/0047nat_0
index d19f5b69fd33..1ef165f14c96 100755
--- a/tests/shell/testcases/sets/0047nat_0
+++ b/tests/shell/testcases/sets/0047nat_0
@@ -8,6 +8,11 @@ EXPECTED="table ip x {
 				 10.141.11.0/24 : 192.168.4.2-192.168.4.3 }
             }
 
+            chain x {
+                    type nat hook prerouting priority dstnat; policy accept;
+                    dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+            }
+
             chain y {
                     type nat hook postrouting priority srcnat; policy accept;
                     snat to ip saddr map @y
diff --git a/tests/shell/testcases/sets/dumps/0047nat_0.nft b/tests/shell/testcases/sets/dumps/0047nat_0.nft
index 97c04a1637a2..d844470ebe35 100644
--- a/tests/shell/testcases/sets/dumps/0047nat_0.nft
+++ b/tests/shell/testcases/sets/dumps/0047nat_0.nft
@@ -6,6 +6,11 @@ table ip x {
 			     10.141.12.0/24 : 192.168.5.10-192.168.5.20 }
 	}
 
+	chain x {
+		type nat hook prerouting priority dstnat; policy accept;
+		dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+
 	chain y {
 		type nat hook postrouting priority srcnat; policy accept;
 		snat ip to ip saddr map @y
-- 
2.30.2

