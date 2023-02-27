Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2C6C64ED8
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Feb 2023 11:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjB0L6Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Feb 2023 06:58:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjB0L6P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2023 06:58:15 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4727D19AB
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2023 03:58:13 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] evaluate: expand value to range when nat mapping contains intervals
Date:   Mon, 27 Feb 2023 12:58:08 +0100
Message-Id: <20230227115808.179403-1-pablo@netfilter.org>
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

The upgrade also done when concatenations are used in the rhs of the
mapping.

For anonymous sets, expansion cannot be done from expr_evaluate_mapping()
because the EXPR_F_INTERVAL flag is inferred from the elements. For
explicit sets, the user already specifies the interval flag in the rhs
of the map definition.

For anonymous sets, mapping_expr_expand() is called to expand the elements
because

Fixes: 9599d9d25a6b ("src: NAT support for intervals in maps")
Fixes: 66746e7dedeb ("src: support for nat with interval concatenation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix concatenation with ranges and explicit sets too.

 src/evaluate.c                                | 47 ++++++++++++++++++-
 tests/shell/testcases/sets/0047nat_0          |  6 +++
 .../testcases/sets/0067nat_concat_interval_0  | 27 +++++++++++
 .../shell/testcases/sets/dumps/0047nat_0.nft  |  6 +++
 .../sets/dumps/0067nat_concat_interval_0.nft  | 16 +++++++
 5 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 506c2414b9e8..19faf621bf65 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1805,10 +1805,45 @@ static void map_set_concat_info(struct expr *map)
 	}
 }
 
+static void __mapping_expr_expand(struct expr *i)
+{
+	struct expr *j, *range, *next;
+
+	assert(i->etype == EXPR_MAPPING);
+	switch (i->right->etype) {
+	case EXPR_VALUE:
+		range = range_expr_alloc(&i->location, expr_get(i->right), expr_get(i->right));
+		expr_free(i->right);
+		i->right = range;
+		break;
+	case EXPR_CONCAT:
+		list_for_each_entry_safe(j, next, &i->right->expressions, list) {
+			if (j->etype != EXPR_VALUE)
+				continue;
+
+			range = range_expr_alloc(&j->location, expr_get(j), expr_get(j));
+			list_replace(&j->list, &range->list);
+			expr_free(j);
+		}
+		i->right->flags &= ~EXPR_F_SINGLETON;
+		break;
+	default:
+		break;
+	}
+}
+
+static void mapping_expr_expand(struct expr *init)
+{
+	struct expr *i;
+
+	list_for_each_entry(i, &init->expressions, list)
+		__mapping_expr_expand(i);
+}
+
 static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 {
-	struct expr_ctx ectx = ctx->ectx;
 	struct expr *map = *expr, *mappings;
+	struct expr_ctx ectx = ctx->ectx;
 	const struct datatype *dtype;
 	struct expr *key, *data;
 
@@ -1879,9 +1914,13 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
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
@@ -1984,6 +2023,10 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	    data_mapping_has_interval(mapping->right))
 		set->data->flags |= EXPR_F_INTERVAL;
 
+	if (!set_is_anonymous(set->flags) &&
+	    set->data->flags & EXPR_F_INTERVAL)
+		__mapping_expr_expand(mapping);
+
 	if (!(set->data->flags & EXPR_F_INTERVAL) &&
 	    !expr_is_singleton(mapping->right))
 		return expr_error(ctx->msgs, mapping->right,
diff --git a/tests/shell/testcases/sets/0047nat_0 b/tests/shell/testcases/sets/0047nat_0
index d19f5b69fd33..4e53b7b8e8c8 100755
--- a/tests/shell/testcases/sets/0047nat_0
+++ b/tests/shell/testcases/sets/0047nat_0
@@ -8,6 +8,12 @@ EXPECTED="table ip x {
 				 10.141.11.0/24 : 192.168.4.2-192.168.4.3 }
             }
 
+            chain x {
+                    type nat hook prerouting priority dstnat; policy accept;
+                    meta l4proto tcp dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69 . 22, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+                    dnat ip to iifname . ip saddr map { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+            }
+
             chain y {
                     type nat hook postrouting priority srcnat; policy accept;
                     snat to ip saddr map @y
diff --git a/tests/shell/testcases/sets/0067nat_concat_interval_0 b/tests/shell/testcases/sets/0067nat_concat_interval_0
index 530771b0016c..b74c0b762334 100755
--- a/tests/shell/testcases/sets/0067nat_concat_interval_0
+++ b/tests/shell/testcases/sets/0067nat_concat_interval_0
@@ -42,3 +42,30 @@ EXPECTED="table ip nat {
 
 $NFT -f - <<< $EXPECTED
 $NFT add rule ip nat prerouting meta l4proto { tcp, udp } dnat to ip daddr . th dport map @fwdtoip_th
+
+EXPECTED="table ip nat {
+        map ipportmap4 {
+		typeof iifname . ip saddr : interval ip daddr
+		flags interval
+		elements = { enp2s0 . 10.1.1.136 : 1.1.2.69, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+	chain prerouting {
+                type nat hook prerouting priority dstnat; policy accept;
+		dnat to iifname . ip saddr map @ipportmap4
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+EXPECTED="table ip nat {
+        map ipportmap5 {
+		typeof iifname . ip saddr : interval ip daddr . tcp dport
+		flags interval
+		elements = { enp2s0 . 10.1.1.136 : 1.1.2.69 . 22, enp2s0 . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+	}
+	chain prerouting {
+                type nat hook prerouting priority dstnat; policy accept;
+		meta l4proto tcp dnat ip to iifname . ip saddr map @ipportmap5
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
diff --git a/tests/shell/testcases/sets/dumps/0047nat_0.nft b/tests/shell/testcases/sets/dumps/0047nat_0.nft
index 97c04a1637a2..9fa9fc7456c5 100644
--- a/tests/shell/testcases/sets/dumps/0047nat_0.nft
+++ b/tests/shell/testcases/sets/dumps/0047nat_0.nft
@@ -6,6 +6,12 @@ table ip x {
 			     10.141.12.0/24 : 192.168.5.10-192.168.5.20 }
 	}
 
+	chain x {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta l4proto tcp dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+		dnat ip to iifname . ip saddr map { "enp2s0" . 10.1.1.136 : 1.1.2.69/32, "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+
 	chain y {
 		type nat hook postrouting priority srcnat; policy accept;
 		snat ip to ip saddr map @y
diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
index 3226da157272..6af47c6682ce 100644
--- a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
@@ -17,10 +17,26 @@ table ip nat {
 		elements = { 1.2.3.4 . 10000-20000 : 192.168.3.4 . 30000-40000 }
 	}
 
+	map ipportmap4 {
+		type ifname . ipv4_addr : interval ipv4_addr
+		flags interval
+		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69/32,
+			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
+	}
+
+	map ipportmap5 {
+		type ifname . ipv4_addr : interval ipv4_addr . inet_service
+		flags interval
+		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22,
+			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
+	}
+
 	chain prerouting {
 		type nat hook prerouting priority dstnat; policy accept;
 		ip protocol tcp dnat ip to ip saddr map @ipportmap
 		ip protocol tcp dnat ip to ip saddr . ip daddr map @ipportmap2
 		meta l4proto { tcp, udp } dnat ip to ip daddr . th dport map @fwdtoip_th
+		dnat ip to iifname . ip saddr map @ipportmap4
+		meta l4proto tcp dnat ip to iifname . ip saddr map @ipportmap5
 	}
 }
-- 
2.30.2

