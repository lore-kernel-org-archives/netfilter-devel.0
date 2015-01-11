From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] netlink_delinearize: add register parsing helper function
Date: Sun, 11 Jan 2015 08:41:57 +0000
Message-ID: <1420965718-24339-3-git-send-email-kaber@trash.net>
References: <1420965718-24339-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54996 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbbAKImF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:42:05 -0500
In-Reply-To: <1420965718-24339-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a helper function to parse netlink register numbers in preparation
of concat support.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_delinearize.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 27801be..387bb67 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -46,6 +46,12 @@ static void __fmtstring(3, 4) netlink_error(struct netlink_parse_ctx *ctx,
 	erec_queue(erec, ctx->msgs);
 }
 
+static unsigned int netlink_parse_register(const struct nft_rule_expr *nle,
+					   unsigned int attr)
+{
+	return nft_rule_expr_get_u32(nle, attr);
+}
+
 static void netlink_set_register(struct netlink_parse_ctx *ctx,
 				 enum nft_registers reg,
 				 struct expr *expr)
@@ -108,7 +114,7 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 		nld.value = nft_rule_expr_get(nle, NFT_EXPR_IMM_DATA, &nld.len);
 	}
 
-	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_IMM_DREG);
+	dreg = netlink_parse_register(nle, NFT_EXPR_IMM_DREG);
 
 	expr = netlink_alloc_data(loc, &nld, dreg);
 	if (dreg == NFT_REG_VERDICT) {
@@ -148,7 +154,7 @@ static void netlink_parse_cmp(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 	enum ops op;
 
-	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_CMP_SREG);
+	sreg = netlink_parse_register(nle, NFT_EXPR_CMP_SREG);
 	left = netlink_get_register(ctx, loc, sreg);
 	if (left == NULL)
 		return netlink_error(ctx, loc,
@@ -181,7 +187,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	struct expr *expr, *left, *right;
 	struct set *set;
 
-	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_LOOKUP_SREG);
+	sreg = netlink_parse_register(nle, NFT_EXPR_LOOKUP_SREG);
 	left = netlink_get_register(ctx, loc, sreg);
 	if (left == NULL)
 		return netlink_error(ctx, loc,
@@ -197,7 +203,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	right = set_ref_expr_alloc(loc, set);
 
 	if (nft_rule_expr_is_set(nle, NFT_EXPR_LOOKUP_DREG)) {
-		dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_LOOKUP_DREG);
+		dreg = netlink_parse_register(nle, NFT_EXPR_LOOKUP_DREG);
 		expr = map_expr_alloc(loc, left, right);
 		if (dreg != NFT_REG_VERDICT)
 			return netlink_set_register(ctx, dreg, expr);
@@ -218,7 +224,7 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 	struct expr *expr, *left, *mask, *xor, *or;
 	mpz_t m, x, o;
 
-	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_BITWISE_SREG);
+	sreg = netlink_parse_register(nle, NFT_EXPR_BITWISE_SREG);
 	left = netlink_get_register(ctx, loc, sreg);
 	if (left == NULL)
 		return netlink_error(ctx, loc,
@@ -274,7 +280,7 @@ static void netlink_parse_bitwise(struct netlink_parse_ctx *ctx,
 	mpz_clear(x);
 	mpz_clear(o);
 
-	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_BITWISE_DREG);
+	dreg = netlink_parse_register(nle, NFT_EXPR_BITWISE_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
 
@@ -286,7 +292,7 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 	struct expr *expr, *arg;
 	enum ops op;
 
-	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_SREG);
+	sreg = netlink_parse_register(nle, NFT_EXPR_BYTEORDER_SREG);
 	arg = netlink_get_register(ctx, loc, sreg);
 	if (arg == NULL)
 		return netlink_error(ctx, loc,
@@ -308,7 +314,7 @@ static void netlink_parse_byteorder(struct netlink_parse_ctx *ctx,
 	expr = unary_expr_alloc(loc, op, arg);
 	expr->len = arg->len;
 
-	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_BYTEORDER_DREG);
+	dreg = netlink_parse_register(nle, NFT_EXPR_BYTEORDER_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
 
@@ -327,7 +333,7 @@ static void netlink_parse_payload(struct netlink_parse_ctx *ctx,
 	expr = payload_expr_alloc(loc, NULL, 0);
 	payload_init_raw(expr, base, offset, len);
 
-	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_PAYLOAD_DREG);
+	dreg = netlink_parse_register(nle, NFT_EXPR_PAYLOAD_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
 
@@ -347,7 +353,7 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 	expr = exthdr_expr_alloc(loc, NULL, 0);
 	exthdr_init_raw(expr, type, offset, len);
 
-	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_EXTHDR_DREG);
+	dreg = netlink_parse_register(nle, NFT_EXPR_EXTHDR_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
 
@@ -362,7 +368,7 @@ static void netlink_parse_meta_expr(struct netlink_parse_ctx *ctx,
 	key  = nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY);
 	expr = meta_expr_alloc(loc, key);
 
-	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_META_DREG);
+	dreg = netlink_parse_register(nle, NFT_EXPR_META_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
 
@@ -375,7 +381,7 @@ static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 	struct expr *expr;
 
-	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_META_SREG);
+	sreg = netlink_parse_register(nle, NFT_EXPR_META_SREG);
 	expr = netlink_get_register(ctx, loc, sreg);
 
 	key  = nft_rule_expr_get_u32(nle, NFT_EXPR_META_KEY);
@@ -404,7 +410,7 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 	struct expr *expr;
 
-	sreg = nft_rule_expr_get_u32(nle, NFT_EXPR_CT_SREG);
+	sreg = netlink_parse_register(nle, NFT_EXPR_CT_SREG);
 	expr = netlink_get_register(ctx, loc, sreg);
 
 	key  = nft_rule_expr_get_u32(nle, NFT_EXPR_CT_KEY);
@@ -425,7 +431,7 @@ static void netlink_parse_ct_expr(struct netlink_parse_ctx *ctx,
 	key  = nft_rule_expr_get_u32(nle, NFT_EXPR_CT_KEY);
 	expr = ct_expr_alloc(loc, key);
 
-	dreg = nft_rule_expr_get_u32(nle, NFT_EXPR_CT_DREG);
+	dreg = netlink_parse_register(nle, NFT_EXPR_CT_DREG);
 	netlink_set_register(ctx, dreg, expr);
 }
 
@@ -536,7 +542,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.flags = nft_rule_expr_get_u32(nle,
 							NFT_EXPR_NAT_FLAGS);
 
-	reg1 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_ADDR_MIN);
+	reg1 = netlink_parse_register(nle, NFT_EXPR_NAT_REG_ADDR_MIN);
 	if (reg1) {
 		addr = netlink_get_register(ctx, loc, reg1);
 		if (addr == NULL)
@@ -552,7 +558,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.addr = addr;
 	}
 
-	reg2 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_ADDR_MAX);
+	reg2 = netlink_parse_register(nle, NFT_EXPR_NAT_REG_ADDR_MAX);
 	if (reg2 && reg2 != reg1) {
 		addr = netlink_get_register(ctx, loc, reg2);
 		if (addr == NULL)
@@ -570,7 +576,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.addr = addr;
 	}
 
-	reg1 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_PROTO_MIN);
+	reg1 = netlink_parse_register(nle, NFT_EXPR_NAT_REG_PROTO_MIN);
 	if (reg1) {
 		proto = netlink_get_register(ctx, loc, reg1);
 		if (proto == NULL)
@@ -582,7 +588,7 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
 		stmt->nat.proto = proto;
 	}
 
-	reg2 = nft_rule_expr_get_u32(nle, NFT_EXPR_NAT_REG_PROTO_MAX);
+	reg2 = netlink_parse_register(nle, NFT_EXPR_NAT_REG_PROTO_MAX);
 	if (reg2 && reg2 != reg1) {
 		proto = netlink_get_register(ctx, loc, reg2);
 		if (proto == NULL)
@@ -632,7 +638,7 @@ static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
 		stmt->redir.flags = flags;
 	}
 
-	reg1 = nft_rule_expr_get_u32(nle, NFT_EXPR_REDIR_REG_PROTO_MIN);
+	reg1 = netlink_parse_register(nle, NFT_EXPR_REDIR_REG_PROTO_MIN);
 	if (reg1) {
 		proto = netlink_get_register(ctx, loc, reg1);
 		if (proto == NULL)
@@ -644,7 +650,7 @@ static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
 		stmt->redir.proto = proto;
 	}
 
-	reg2 = nft_rule_expr_get_u32(nle, NFT_EXPR_REDIR_REG_PROTO_MAX);
+	reg2 = netlink_parse_register(nle, NFT_EXPR_REDIR_REG_PROTO_MAX);
 	if (reg2 && reg2 != reg1) {
 		proto = netlink_get_register(ctx, loc, reg2);
 		if (proto == NULL)
-- 
2.1.0

