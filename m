From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 3/9] netlink: pass expression to register allocation/release functions
Date: Fri,  5 Jun 2015 15:42:45 +0200
Message-ID: <1433511771-4620-4-git-send-email-kaber@trash.net>
References: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59937 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbFENmz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:55 -0400
In-Reply-To: <1433511771-4620-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prepare for taking the expression size into account.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_linearize.c | 54 +++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index fbc6ae1..beeb0c2 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -30,14 +30,16 @@ static void netlink_put_register(struct nft_rule_expr *nle,
 	nft_rule_expr_set_u32(nle, attr, reg);
 }
 
-static enum nft_registers get_register(struct netlink_linearize_ctx *ctx)
+static enum nft_registers get_register(struct netlink_linearize_ctx *ctx,
+				       const struct expr *expr)
 {
 	if (ctx->reg_low > NFT_REG_MAX)
 		BUG("register reg_low %u invalid\n", ctx->reg_low);
 	return ctx->reg_low++;
 }
 
-static void release_register(struct netlink_linearize_ctx *ctx)
+static void release_register(struct netlink_linearize_ctx *ctx,
+			     const struct expr *expr)
 {
 	ctx->reg_low--;
 }
@@ -124,7 +126,7 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 	assert(expr->mappings->ops->type == EXPR_SET_REF);
 
 	if (dreg == NFT_REG_VERDICT)
-		sreg = get_register(ctx);
+		sreg = get_register(ctx, expr->map);
 	else
 		sreg = dreg;
 
@@ -139,7 +141,7 @@ static void netlink_gen_map(struct netlink_linearize_ctx *ctx,
 			      expr->mappings->set->handle.set_id);
 
 	if (dreg == NFT_REG_VERDICT)
-		release_register(ctx);
+		release_register(ctx, expr->map);
 
 	nft_rule_add_expr(ctx->nlr, nle);
 }
@@ -154,7 +156,7 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 	assert(expr->right->ops->type == EXPR_SET_REF);
 	assert(dreg == NFT_REG_VERDICT);
 
-	sreg = get_register(ctx);
+	sreg = get_register(ctx, expr->left);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
 	nle = alloc_nft_expr("lookup");
@@ -164,7 +166,7 @@ static void netlink_gen_lookup(struct netlink_linearize_ctx *ctx,
 	nft_rule_expr_set_u32(nle, NFT_EXPR_LOOKUP_SET_ID,
 			      expr->right->set->handle.set_id);
 
-	release_register(ctx);
+	release_register(ctx, expr->left);
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
@@ -206,7 +208,7 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 	if (expr->right->ops->type == EXPR_RANGE)
 		return netlink_gen_range(ctx, expr, dreg);
 
-	sreg = get_register(ctx);
+	sreg = get_register(ctx, expr->left);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
 	switch (expr->right->ops->type) {
@@ -242,7 +244,7 @@ static void netlink_gen_cmp(struct netlink_linearize_ctx *ctx,
 			      netlink_gen_cmp_op(expr->op));
 	netlink_gen_data(right, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
-	release_register(ctx);
+	release_register(ctx, expr->left);
 
 	nft_rule_add_expr(ctx->nlr, nle);
 }
@@ -258,7 +260,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 
 	assert(dreg == NFT_REG_VERDICT);
 
-	sreg = get_register(ctx);
+	sreg = get_register(ctx, expr->left);
 	netlink_gen_expr(ctx, expr->left, sreg);
 
 	nle = alloc_nft_expr("cmp");
@@ -301,7 +303,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	nft_rule_add_expr(ctx->nlr, nle);
 
-	release_register(ctx);
+	release_register(ctx, expr->left);
 }
 
 static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
@@ -316,7 +318,7 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 
 	assert(dreg == NFT_REG_VERDICT);
 
-	sreg = get_register(ctx);
+	sreg = get_register(ctx, expr->left);
 	netlink_gen_expr(ctx, expr->left, sreg);
 	len = div_round_up(expr->left->len, BITS_PER_BYTE);
 
@@ -340,7 +342,7 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 
 	mpz_clear(zero);
-	release_register(ctx);
+	release_register(ctx, expr->left);
 }
 
 static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
@@ -565,9 +567,9 @@ static void netlink_gen_meta_stmt(struct netlink_linearize_ctx *ctx,
 	struct nft_rule_expr *nle;
 	enum nft_registers sreg;
 
-	sreg = get_register(ctx);
+	sreg = get_register(ctx, stmt->meta.expr);
 	netlink_gen_expr(ctx, stmt->meta.expr, sreg);
-	release_register(ctx);
+	release_register(ctx, stmt->meta.expr);
 
 	nle = alloc_nft_expr("meta");
 	netlink_put_register(nle, NFT_EXPR_META_SREG, sreg);
@@ -647,11 +649,11 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		nft_rule_expr_set_u32(nle, NFT_EXPR_NAT_FLAGS, stmt->nat.flags);
 
 	if (stmt->nat.addr) {
-		amin_reg = get_register(ctx);
+		amin_reg = get_register(ctx, NULL);
 		registers++;
 
 		if (stmt->nat.addr->ops->type == EXPR_RANGE) {
-			amax_reg = get_register(ctx);
+			amax_reg = get_register(ctx, NULL);
 			registers++;
 
 			netlink_gen_expr(ctx, stmt->nat.addr->left, amin_reg);
@@ -669,11 +671,11 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 	}
 
 	if (stmt->nat.proto) {
-		pmin_reg = get_register(ctx);
+		pmin_reg = get_register(ctx, NULL);
 		registers++;
 
 		if (stmt->nat.proto->ops->type == EXPR_RANGE) {
-			pmax_reg = get_register(ctx);
+			pmax_reg = get_register(ctx, NULL);
 			registers++;
 
 			netlink_gen_expr(ctx, stmt->nat.proto->left, pmin_reg);
@@ -690,7 +692,7 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 	}
 
 	while (registers > 0) {
-		release_register(ctx);
+		release_register(ctx, NULL);
 		registers--;
 	}
 
@@ -724,11 +726,11 @@ static void netlink_gen_redir_stmt(struct netlink_linearize_ctx *ctx,
 				      stmt->redir.flags);
 
 	if (stmt->redir.proto) {
-		pmin_reg = get_register(ctx);
+		pmin_reg = get_register(ctx, NULL);
 		registers++;
 
 		if (stmt->redir.proto->ops->type == EXPR_RANGE) {
-			pmax_reg = get_register(ctx);
+			pmax_reg = get_register(ctx, NULL);
 			registers++;
 
 			netlink_gen_expr(ctx, stmt->redir.proto->left,
@@ -750,7 +752,7 @@ static void netlink_gen_redir_stmt(struct netlink_linearize_ctx *ctx,
 	}
 
 	while (registers > 0) {
-		release_register(ctx);
+		release_register(ctx, NULL);
 		registers--;
 	}
 
@@ -791,9 +793,9 @@ static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 	struct nft_rule_expr *nle;
 	enum nft_registers sreg;
 
-	sreg = get_register(ctx);
+	sreg = get_register(ctx, stmt->ct.expr);
 	netlink_gen_expr(ctx, stmt->ct.expr, sreg);
-	release_register(ctx);
+	release_register(ctx, stmt->ct.expr);
 
 	nle = alloc_nft_expr("ct");
 	netlink_put_register(nle, NFT_EXPR_CT_SREG, sreg);
@@ -807,9 +809,9 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 	struct nft_rule_expr *nle;
 	enum nft_registers sreg_key;
 
-	sreg_key = get_register(ctx);
+	sreg_key = get_register(ctx, stmt->set.key);
 	netlink_gen_expr(ctx, stmt->set.key, sreg_key);
-	release_register(ctx);
+	release_register(ctx, stmt->set.key);
 
 	nle = alloc_nft_expr("dynset");
 	netlink_put_register(nle, NFT_EXPR_DYNSET_SREG_KEY, sreg_key);
-- 
2.1.0

