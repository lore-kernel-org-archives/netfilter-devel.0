Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA895C43219
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 11:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiKXLqK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 06:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiKXLqK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 06:46:10 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F6159DB96
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 03:46:06 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sbrivio@redhat.com
Subject: [PATCH nft] src: support for selectors with different byteorder with interval concatenations
Date:   Thu, 24 Nov 2022 12:46:02 +0100
Message-Id: <20221124114602.277741-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Assuming the following interval set with concatenations:

 set test {
	typeof ip saddr . meta mark
	flags interval
 }

then, the following rule:

 ip saddr . meta mark @test

requires bytecode that swaps the byteorder for the meta mark selector in
case the set contains intervals and concatenations.

 inet x y
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ meta load mark => reg 9 ]
   [ byteorder reg 9 = hton(reg 9, 4, 4) ] 	<----- this is required !
   [ lookup reg 1 set test dreg 0 ]

This patch updates byteorder_conversion() to add the unary expression
that introduces the byteorder expression.

Moreover, store the meta mark range component of the element tuple in
the set in big endian as it is required for the range comparisons. Undo
the byteorder swap in the netlink delinearize path to listing the meta
mark values accordingly.

Update tests/py to validate that byteorder expression is emitted in the
bytecode. Update tests/shell to validate insertion and listing of a
named map declaration.

A similar commit 806ab081dc9a ("netlink: swap byteorder for
host-endian concat data") already exists in the tree to handle this for
strings with prefix (e.g. eth*).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                | 23 ++++++++++++++++-
 src/netlink.c                                 | 25 ++++++++++++++-----
 tests/py/inet/meta.t                          |  2 ++
 tests/py/inet/meta.t.payload                  | 12 +++++++++
 tests/shell/testcases/maps/0012map_0          | 19 ++++++++++++++
 .../shell/testcases/maps/dumps/0012map_0.nft  | 13 ++++++++++
 6 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 0bf6a0d1b110..991de1d7e977 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -148,8 +148,29 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 		return 0;
 
 	/* Conversion for EXPR_CONCAT is handled for single composing ranges */
-	if ((*expr)->etype == EXPR_CONCAT)
+	if ((*expr)->etype == EXPR_CONCAT) {
+		struct expr *i, *next, *unary;
+
+		list_for_each_entry_safe(i, next, &(*expr)->expressions, list) {
+			if (i->byteorder == BYTEORDER_BIG_ENDIAN)
+				continue;
+
+			basetype = expr_basetype(i)->type;
+			if (basetype == TYPE_STRING)
+				continue;
+
+			assert(basetype == TYPE_INTEGER);
+
+			op = byteorder_conversion_op(i, byteorder);
+			unary = unary_expr_alloc(&i->location, op, i);
+			if (expr_evaluate(ctx, &unary) < 0)
+				return -1;
+
+			list_replace(&i->list, &unary->list);
+		}
+
 		return 0;
+	}
 
 	basetype = expr_basetype(*expr)->type;
 	switch (basetype) {
diff --git a/src/netlink.c b/src/netlink.c
index 799cf9b8ebef..db5e79f235d0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -249,9 +249,20 @@ static int netlink_export_pad(unsigned char *data, const mpz_t v,
 static int netlink_gen_concat_data_expr(int end, const struct expr *i,
 					unsigned char *data)
 {
+	struct expr *expr;
+
 	switch (i->etype) {
 	case EXPR_RANGE:
-		i = end ? i->right : i->left;
+		if (end)
+			expr = i->right;
+		else
+			expr = i->left;
+
+		if (expr_basetype(expr)->type == TYPE_INTEGER &&
+		    expr->byteorder == BYTEORDER_HOST_ENDIAN)
+			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+
+		i = expr;
 		break;
 	case EXPR_PREFIX:
 		if (end) {
@@ -1109,7 +1120,7 @@ static struct expr *netlink_parse_interval_elem(const struct set *set,
 	return range_expr_to_prefix(range);
 }
 
-static struct expr *concat_elem_expr(struct expr *key,
+static struct expr *concat_elem_expr(const struct set *set, struct expr *key,
 				     const struct datatype *dtype,
 				     struct expr *data, int *off)
 {
@@ -1133,7 +1144,9 @@ static struct expr *concat_elem_expr(struct expr *key,
 		expr->byteorder = subtype->byteorder;
 	}
 
-	if (expr->byteorder == BYTEORDER_HOST_ENDIAN)
+	if (expr_basetype(expr)->type == TYPE_STRING ||
+	    (!(set->flags & NFT_SET_INTERVAL) &&
+	     expr->byteorder == BYTEORDER_HOST_ENDIAN))
 		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
 	if (expr->dtype->basetype != NULL &&
@@ -1157,7 +1170,7 @@ static struct expr *netlink_parse_concat_elem_key(const struct set *set,
 
 	concat = concat_expr_alloc(&data->location);
 	while (off > 0) {
-		expr = concat_elem_expr(n, dtype, data, &off);
+		expr = concat_elem_expr(set, n, dtype, data, &off);
 		compound_expr_add(concat, expr);
 		if (set->key->etype == EXPR_CONCAT)
 			n = list_next_entry(n, list);
@@ -1180,7 +1193,7 @@ static struct expr *netlink_parse_concat_elem(const struct set *set,
 
 	concat = concat_expr_alloc(&data->location);
 	while (off > 0) {
-		expr = concat_elem_expr(NULL, dtype, data, &off);
+		expr = concat_elem_expr(set, NULL, dtype, data, &off);
 		list_add_tail(&expr->list, &expressions);
 	}
 
@@ -1192,7 +1205,7 @@ static struct expr *netlink_parse_concat_elem(const struct set *set,
 		while (off > 0) {
 			left = list_first_entry(&expressions, struct expr, list);
 
-			expr = concat_elem_expr(NULL, dtype, data, &off);
+			expr = concat_elem_expr(set, NULL, dtype, data, &off);
 			list_del(&left->list);
 
 			range = range_expr_alloc(&data->location, left, expr);
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
index 423cc5f32cba..0d7d5f255c00 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -21,3 +21,5 @@ meta secpath missing;ok;meta ipsec missing
 meta ibrname "br0";fail
 meta obrname "br0";fail
 meta mark set ct mark >> 8;ok
+
+meta mark . tcp dport { 0x0000000a-0x00000014 . 80-90, 0x00100000-0x00100123 . 100-120 };ok
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index fd0545490b78..2b4e6c2d180d 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -97,3 +97,15 @@ inet test-inet input
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00004300 ]
+
+# meta mark . tcp dport { 0x0000000a-0x00000014 . 80-90, 0x00100000-0x00100123 . 100-120 }
+__set%d test-inet 87 size 1
+__set%d test-inet 0
+	element 0a000000 00005000  - 14000000 00005a00  : 0 [end]       element 00001000 00006400  - 23011000 00007800  : 0 [end]
+ip test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ meta load mark => reg 1 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ payload load 2b @ transport header + 2 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
diff --git a/tests/shell/testcases/maps/0012map_0 b/tests/shell/testcases/maps/0012map_0
index dd93c482f441..49e51b755b0f 100755
--- a/tests/shell/testcases/maps/0012map_0
+++ b/tests/shell/testcases/maps/0012map_0
@@ -15,3 +15,22 @@ table ip x {
 }"
 
 $NFT -f - <<< "$EXPECTED"
+
+EXPECTED="table ip x {
+	map w {
+		typeof ip saddr . meta mark : verdict
+		flags interval
+		counter
+		elements = {
+			127.0.0.1-127.0.0.4 . 0x123434-0xb00122 : accept,
+		}
+	}
+
+	chain k {
+		type filter hook input priority filter + 1; policy accept;
+		meta mark set 0x123434
+		ip saddr . meta mark vmap @w
+	}
+}"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/maps/dumps/0012map_0.nft b/tests/shell/testcases/maps/dumps/0012map_0.nft
index e734fc1c70b9..895490cffa8c 100644
--- a/tests/shell/testcases/maps/dumps/0012map_0.nft
+++ b/tests/shell/testcases/maps/dumps/0012map_0.nft
@@ -6,7 +6,20 @@ table ip x {
 			     "eth1" : drop }
 	}
 
+	map w {
+		typeof ip saddr . meta mark : verdict
+		flags interval
+		counter
+		elements = { 127.0.0.1-127.0.0.4 . 0x00123434-0x00b00122 counter packets 0 bytes 0 : accept }
+	}
+
 	chain y {
 		iifname vmap { "lo" : accept, "eth0" : drop, "eth1" : drop }
 	}
+
+	chain k {
+		type filter hook input priority filter + 1; policy accept;
+		meta mark set 0x00123434
+		ip saddr . meta mark vmap @w
+	}
 }
-- 
2.30.2

