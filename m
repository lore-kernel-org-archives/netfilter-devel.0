Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C5EC432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 13:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9309A2072C
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 13:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfK3Nxb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 08:53:31 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:47980 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfK3Nxb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 08:53:31 -0500
Received: from localhost ([::1]:32836 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ib3Bh-00054C-0B; Sat, 30 Nov 2019 14:53:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Brett Mastbergen <bmastbergen@untangle.com>
Subject: [nft PATCH v3] src: Support maps as left side expressions
Date:   Sat, 30 Nov 2019 14:53:21 +0100
Message-Id: <20191130135321.5188-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Brett Mastbergen <bmastbergen@untangle.com>

This change allows map expressions on the left side of comparisons:

nft add rule foo bar ip saddr map @map_a == 22 counter

It also allows map expressions as the left side expression of other
map expressions:

nft add rule foo bar ip saddr map @map_a map @map_b == 22 counter

To accomplish this, some additional context needs to be set during
evaluation and delinearization.  A tweak is also make to the parser
logic to allow map expressions as the left hand expression to other
map expressions.

By allowing maps as left side comparison expressions one can map
information in the packet to some arbitrary piece of data and use
the equality (or inequality) to make some decision about the traffic,
unlike today where the result of a map lookup is only usable as the
right side of a statement (like dnat or snat) that actually uses the
value as input.

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
v2: Add testcases
v3: Support maps on vmap LHS

Pablo, Brett,

Reading the discussion about pending v2 of this patch I gave it a try
and extending functionality to verdict maps was easy and
straightforward, so I just went ahead and extended the code accordingly.

Cheers, Phil
---
 src/evaluate.c                                    |  2 +-
 src/expression.c                                  | 12 +++++++++++-
 src/netlink_delinearize.c                         |  2 ++
 src/parser_bison.y                                | 15 +++++++++++----
 .../testcases/maps/dumps/left_side_map_0.nft      | 10 ++++++++++
 tests/shell/testcases/maps/dumps/map_to_map_0.nft | 14 ++++++++++++++
 .../shell/testcases/maps/dumps/map_to_vmap_0.nft  | 14 ++++++++++++++
 tests/shell/testcases/maps/left_side_map_0        |  8 ++++++++
 tests/shell/testcases/maps/map_to_map_0           |  9 +++++++++
 tests/shell/testcases/maps/map_to_vmap_0          |  9 +++++++++
 10 files changed, 89 insertions(+), 6 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/left_side_map_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/map_to_map_0.nft
 create mode 100644 tests/shell/testcases/maps/dumps/map_to_vmap_0.nft
 create mode 100755 tests/shell/testcases/maps/left_side_map_0
 create mode 100755 tests/shell/testcases/maps/map_to_map_0
 create mode 100755 tests/shell/testcases/maps/map_to_vmap_0

diff --git a/src/evaluate.c b/src/evaluate.c
index a865902c0fc7b..832af56a32a5b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1415,6 +1415,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		    !set_is_datamap(map->mappings->set->flags))
 			return expr_error(ctx->msgs, map->mappings,
 					  "Expression is not a map");
+		expr_set_context(&ctx->ectx, map->mappings->set->datatype, map->mappings->set->datalen);
 		break;
 	default:
 		BUG("invalid mapping expression %s\n",
@@ -1429,7 +1430,6 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 					 map->map->dtype->desc);
 
 	datatype_set(map, map->mappings->set->datatype);
-	map->flags |= EXPR_F_CONSTANT;
 
 	/* Data for range lookups needs to be in big endian order */
 	if (map->mappings->set->flags & NFT_SET_INTERVAL &&
diff --git a/src/expression.c b/src/expression.c
index 5070b1014392c..b3ff4ff1e1edb 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1081,8 +1081,18 @@ static const struct expr_ops set_ref_expr_ops = {
 struct expr *set_ref_expr_alloc(const struct location *loc, struct set *set)
 {
 	struct expr *expr;
+	const struct datatype *dtype;
+	unsigned int len;
 
-	expr = expr_alloc(loc, EXPR_SET_REF, set->key->dtype, 0, 0);
+	if (set->flags & NFT_SET_MAP) {
+		dtype = set->datatype;
+		len = set->datalen;
+	} else {
+		dtype = set->key->dtype;
+		len = set->key->len;
+	}
+
+	expr = expr_alloc(loc, EXPR_SET_REF, dtype, 0, len);
 	expr->set = set_get(set);
 	expr->flags |= EXPR_F_CONSTANT;
 	return expr;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 154353b8161a0..a972adc2d4cdc 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -341,6 +341,8 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_LOOKUP_DREG)) {
 		dreg = netlink_parse_register(nle, NFTNL_EXPR_LOOKUP_DREG);
 		expr = map_expr_alloc(loc, left, right);
+		expr_set_type(expr, right->dtype, right->byteorder);
+		expr->len = right->len;
 		if (dreg != NFT_REG_VERDICT)
 			return netlink_set_register(ctx, dreg, expr);
 	} else {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 707f46716ed3f..ad5d5911383b0 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -671,8 +671,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			concat_expr
 %destructor { expr_free($$); }	concat_expr
 
-%type <expr>			map_expr
-%destructor { expr_free($$); }	map_expr
+%type <expr>			map_expr map_lhs_expr verdict_map_lhs_expr
+%destructor { expr_free($$); }	map_expr map_lhs_expr verdict_map_lhs_expr
 
 %type <expr>			verdict_map_stmt
 %destructor { expr_free($$); }	verdict_map_stmt
@@ -2430,7 +2430,10 @@ verdict_stmt		:	verdict_expr
 			}
 			;
 
-verdict_map_stmt	:	concat_expr	VMAP	verdict_map_expr
+verdict_map_lhs_expr	:	concat_expr
+			|	map_expr
+
+verdict_map_stmt	:	verdict_map_lhs_expr	VMAP	verdict_map_expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
@@ -3559,7 +3562,11 @@ multiton_rhs_expr	:	prefix_rhs_expr
 			|	wildcard_expr
 			;
 
-map_expr		:	concat_expr	MAP	rhs_expr
+map_lhs_expr		:	concat_expr
+			|	map_expr
+			;
+
+map_expr		:	map_lhs_expr	MAP	rhs_expr
 			{
 				$$ = map_expr_alloc(&@$, $1, $3);
 			}
diff --git a/tests/shell/testcases/maps/dumps/left_side_map_0.nft b/tests/shell/testcases/maps/dumps/left_side_map_0.nft
new file mode 100644
index 0000000000000..b93948fc6561b
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/left_side_map_0.nft
@@ -0,0 +1,10 @@
+table ip x {
+	map y {
+		type ipv4_addr : inet_service
+	}
+
+	chain z {
+		type filter hook output priority filter; policy accept;
+		ip saddr map @y 22 counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/maps/dumps/map_to_map_0.nft b/tests/shell/testcases/maps/dumps/map_to_map_0.nft
new file mode 100644
index 0000000000000..fd7339f99b4ae
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/map_to_map_0.nft
@@ -0,0 +1,14 @@
+table ip x {
+	map y {
+		type ipv4_addr : mark
+	}
+
+	map yy {
+		type mark : inet_service
+	}
+
+	chain z {
+		type filter hook output priority filter; policy accept;
+		ip saddr map @y map @yy 22 counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/maps/dumps/map_to_vmap_0.nft b/tests/shell/testcases/maps/dumps/map_to_vmap_0.nft
new file mode 100644
index 0000000000000..0802284dd8ef8
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/map_to_vmap_0.nft
@@ -0,0 +1,14 @@
+table ip x {
+	map y {
+		type ipv4_addr : mark
+	}
+
+	map yy {
+		type mark : verdict
+	}
+
+	chain z {
+		type filter hook output priority filter; policy accept;
+		ip saddr map @y vmap @yy
+	}
+}
diff --git a/tests/shell/testcases/maps/left_side_map_0 b/tests/shell/testcases/maps/left_side_map_0
new file mode 100755
index 0000000000000..93c721b72b361
--- /dev/null
+++ b/tests/shell/testcases/maps/left_side_map_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+$NFT add map x y { type ipv4_addr : inet_service\; }
+$NFT add chain ip x z { type filter hook output priority 0 \; }
+$NFT add rule x z ip saddr map @y 22 counter
diff --git a/tests/shell/testcases/maps/map_to_map_0 b/tests/shell/testcases/maps/map_to_map_0
new file mode 100755
index 0000000000000..95a45f622173e
--- /dev/null
+++ b/tests/shell/testcases/maps/map_to_map_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+$NFT add map x y { type ipv4_addr : mark\; }
+$NFT add map x yy { type mark : inet_service\; }
+$NFT add chain ip x z { type filter hook output priority 0 \; }
+$NFT add rule x z ip saddr map @y map@yy 22 counter
diff --git a/tests/shell/testcases/maps/map_to_vmap_0 b/tests/shell/testcases/maps/map_to_vmap_0
new file mode 100755
index 0000000000000..dc3aefaf66528
--- /dev/null
+++ b/tests/shell/testcases/maps/map_to_vmap_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table x
+$NFT add map x y { type ipv4_addr : mark\; }
+$NFT add map x yy { type mark : verdict\; }
+$NFT add chain ip x z { type filter hook output priority 0 \; }
+$NFT add rule x z ip saddr map @y vmap @yy
-- 
2.24.0

