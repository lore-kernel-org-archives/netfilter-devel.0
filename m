From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/3] netlink_linearize: add register dumping helper function
Date: Sun, 11 Jan 2015 08:41:58 +0000
Message-ID: <1420965718-24339-4-git-send-email-kaber@trash.net>
References: <1420965718-24339-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54998 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbbAKImG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:42:06 -0500
In-Reply-To: <1420965718-24339-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a helper function to dump netlink register numbers in preparation
of concat support.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_linearize.c | 74 ++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 34 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index de338cb..9bef67b 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -24,6 +24,12 @@ struct netlink_linearize_ctx {
 	unsigned int		reg_low;
 };
 
+static void netlink_put_register(struct nft_rule_expr *nle,
+				 uint32_t attr, uint32_t reg)
+{
+	nft_rule_expr_set_u32(nle, attr, reg);
+}
+
 static enum nft_registers get_register(struct netlink_linearize_ctx *ctx)
 {
 	if (ctx->reg_low > NFT_REG_MAX)
@@ -57,7 +63,7 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 	struct nft_rule_expr *nle;
 
 	nle = alloc_nft_expr("payload");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_PAYLOAD_DREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_PAYLOAD_DREG, dreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_PAYLOAD_BASE,
 			      expr->payload.base - 1);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_PAYLOAD_OFFSET,
@@ -74,7 +80,7 @@ static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
 	struct nft_rule_expr *nle;
 
 	nle = alloc_nft_expr("exthdr");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_EXTHDR_DREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_EXTHDR_DREG, dreg);
 	nft_rule_expr_set_u8(nle, NFT_EXPR_EXTHDR_TYPE,
 			     expr->exthdr.desc->type);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_EXTHDR_OFFSET,
@@ -91,7 +97,7 @@ static void netlink_gen_meta(struct netlink_linearize_ctx *ctx,
 	struct nft_rule_expr *nle;
 
 	nle = alloc_nft_expr("meta");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_META_DREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_META_DREG, dreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_META_KEY, expr->meta.key);
 	nft_rule_add_expr(ctx->nlr, nle);
 }
@@ -103,7 +109,7 @@ static void netlink_gen_ct(struct netlink_linearize_ctx *ctx,
 	struct nft_rule_expr *nle;
 
 	nle = alloc_nft_expr("ct");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_CT_DREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_CT_DREG, dreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CT_KEY, expr->ct.key);
 	nft_rule_add_expr(ctx->nlr, nle);
 }
@@ -125,8 +131,8 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 	netlink_gen_expr(ctx, expr->map, sreg);
 
 	nle = alloc_nft_expr("lookup");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_SREG, sreg);
-	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_DREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_LOOKUP_SREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_LOOKUP_DREG, dreg);
 	nft_rule_expr_set_str(nle, NFT_EXPR_LOOKUP_SET,
 			      expr->mappings->set->handle.set);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_SET_ID,
@@ -152,7 +158,7 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 	netlink_gen_expr(ctx, expr->left, sreg);
 
 	nle = alloc_nft_expr("lookup");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_SREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_LOOKUP_SREG, sreg);
 	nft_rule_expr_set_str(nle, NFT_EXPR_LOOKUP_SET,
 			      expr->right->set->handle.set);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_SET_ID,
@@ -213,8 +219,8 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 		zero.len = nld.len;
 
 		nle = alloc_nft_expr("bitwise");
-		nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_SREG, sreg);
-		nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, sreg);
+		netlink_put_register(nle, NFT_EXPR_BITWISE_SREG, sreg);
+		netlink_put_register(nle, NFT_EXPR_BITWISE_DREG, sreg);
 		nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, nld.len);
 		nft_rule_expr_set(nle, NFT_EXPR_BITWISE_MASK, &nld.value, nld.len);
 		nft_rule_expr_set(nle, NFT_EXPR_BITWISE_XOR, &zero.value, zero.len);
@@ -230,7 +236,7 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	}
 
 	nle = alloc_nft_expr("cmp");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_CMP_SREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
 			      netlink_gen_cmp_op(expr->op));
 	netlink_gen_data(right, &nld);
@@ -255,7 +261,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 	netlink_gen_expr(ctx, expr->left, sreg);
 
 	nle = alloc_nft_expr("cmp");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_CMP_SREG, sreg);
 	switch (expr->op) {
 	case OP_NEQ:
 		nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
@@ -275,7 +281,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 
 	nle = alloc_nft_expr("cmp");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_CMP_SREG, sreg);
 	switch (expr->op) {
 	case OP_NEQ:
 		nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP,
@@ -319,15 +325,15 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 	netlink_gen_data(expr->right, &nld2);
 
 	nle = alloc_nft_expr("bitwise");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_SREG, sreg);
-	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_BITWISE_SREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_BITWISE_DREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, len);
 	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_MASK, &nld2.value, nld2.len);
 	nft_rule_expr_set(nle, NFT_EXPR_BITWISE_XOR, &nld.value, nld.len);
 	nft_rule_add_expr(ctx->nlr, nle);
 
 	nle = alloc_nft_expr("cmp");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_CMP_SREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP, NFT_CMP_NEQ);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	nft_rule_add_expr(ctx->nlr, nle);
@@ -419,8 +425,8 @@ static void netlink_gen_binop(struct netlink_linearize_ctx *ctx,
 	len = div_round_up(expr->len, BITS_PER_BYTE);
 
 	nle = alloc_nft_expr("bitwise");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_SREG, dreg);
-	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_DREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_BITWISE_SREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_BITWISE_DREG, dreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_BITWISE_LEN, len);
 
 	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
@@ -457,8 +463,8 @@ static void netlink_gen_unary(struct netlink_linearize_ctx *ctx,
 	netlink_gen_expr(ctx, expr->arg, dreg);
 
 	nle = alloc_nft_expr("byteorder");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_BYTEORDER_SREG, dreg);
-	nft_rule_expr_set_u32(nle, NFT_EXPR_BYTEORDER_DREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_BYTEORDER_SREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_BYTEORDER_DREG, dreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_BYTEORDER_LEN,
 			      expr->len / BITS_PER_BYTE);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_BYTEORDER_SIZE,
@@ -476,7 +482,7 @@ static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 	struct nft_data_linearize nld;
 
 	nle = alloc_nft_expr("immediate");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_IMM_DREG, dreg);
+	netlink_put_register(nle, NFT_EXPR_IMM_DREG, dreg);
 	netlink_gen_data(expr, &nld);
 	switch (expr->ops->type) {
 	case EXPR_VALUE:
@@ -561,7 +567,7 @@ static void netlink_gen_meta_stmt(struct netlink_linearize_ctx *ctx,
 	release_register(ctx);
 
 	nle = alloc_nft_expr("meta");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_META_SREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_META_SREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_META_KEY, stmt->meta.key);
 	nft_rule_add_expr(ctx->nlr, nle);
 }
@@ -647,14 +653,14 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 
 			netlink_gen_expr(ctx, stmt->nat.addr->left, amin_reg);
 			netlink_gen_expr(ctx, stmt->nat.addr->right, amax_reg);
-			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_ADDR_MIN,
-					      amin_reg);
-			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_ADDR_MAX,
-					      amax_reg);
+			netlink_put_register(nle, NFT_EXPR_NAT_REG_ADDR_MIN,
+					     amin_reg);
+			netlink_put_register(nle, NFT_EXPR_NAT_REG_ADDR_MAX,
+					     amax_reg);
 		} else {
 			netlink_gen_expr(ctx, stmt->nat.addr, amin_reg);
-			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_ADDR_MIN,
-					      amin_reg);
+			netlink_put_register(nle, NFT_EXPR_NAT_REG_ADDR_MIN,
+					     amin_reg);
 		}
 
 	}
@@ -669,14 +675,14 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 
 			netlink_gen_expr(ctx, stmt->nat.proto->left, pmin_reg);
 			netlink_gen_expr(ctx, stmt->nat.proto->right, pmax_reg);
-			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_PROTO_MIN,
-					      pmin_reg);
-			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_PROTO_MAX,
-					      pmax_reg);
+			netlink_put_register(nle, NFT_EXPR_NAT_REG_PROTO_MIN,
+					     pmin_reg);
+			netlink_put_register(nle, NFT_EXPR_NAT_REG_PROTO_MAX,
+					     pmax_reg);
 		} else {
 			netlink_gen_expr(ctx, stmt->nat.proto, pmin_reg);
-			nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_REG_PROTO_MIN,
-					      pmin_reg);
+			netlink_put_register(nle, NFT_EXPR_NAT_REG_PROTO_MIN,
+					     pmin_reg);
 		}
 	}
 
@@ -787,7 +793,7 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 	release_register(ctx);
 
 	nle = alloc_nft_expr("ct");
-	nft_rule_expr_set_u32(nle, NFT_EXPR_CT_SREG, sreg);
+	netlink_put_register(nle, NFT_EXPR_CT_SREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CT_KEY, stmt->ct.key);
 	nft_rule_add_expr(ctx->nlr, nle);
 }
-- 
2.1.0

