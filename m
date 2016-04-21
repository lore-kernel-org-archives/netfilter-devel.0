From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/4] ct: add conntrack label set support
Date: Thu, 21 Apr 2016 16:34:44 +0200
Message-ID: <1461249284-12114-5-git-send-email-fw@strlen.de>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54976 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbcDUOej (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2016 10:34:39 -0400
In-Reply-To: <1461249284-12114-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo suggested to support this by indicating the label bit number that we
want to set via netlink attribute.

IOW, ct label set doesn't use an sreg -- instead the bit that we
should set in the conntrack label area is passed as immediate attribute.

To make this work we have to dissect the argument and derive the
bit from the bitfield (only one bit can be set).

For nft list, we create a new bitfield and set the appropriate label bit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c            | 28 ++++++++++++++++++++++++----
 src/netlink_delinearize.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 src/netlink_linearize.c   | 23 +++++++++++++++++------
 3 files changed, 80 insertions(+), 15 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 346e34f..5983159 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1468,10 +1468,30 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	return stmt_evaluate_arg(ctx, stmt,
-				 stmt->ct.tmpl->dtype,
-				 stmt->ct.tmpl->len,
-				 &stmt->ct.expr);
+	int ret = stmt_evaluate_arg(ctx, stmt, stmt->ct.tmpl->dtype,
+				    stmt->ct.tmpl->len, &stmt->ct.expr);
+	if (ret < 0)
+		return ret;
+
+	switch (stmt->ct.key) {
+	case NFT_CT_LABELS: {
+		struct expr *e = stmt->ct.expr;
+		int bit;
+
+		if (e->ops->type != EXPR_VALUE ||
+		    mpz_popcount(e->value) != 1)
+			return stmt_error(ctx, stmt, "label expected");
+
+		bit = mpz_scan1(e->value, 0);
+		mpz_set_ui(e->value, htonl(bit));
+		e->len = sizeof(uint32_t) * BITS_PER_BYTE;
+		break;
+	}
+	default:
+		break;
+	}
+
+	return 0;
 }
 
 static int reject_payload_gen_dependency_tcp(struct eval_ctx *ctx,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ca1c6e6..2327fcf 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -525,10 +525,20 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 	struct expr *expr;
 
-	sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
-	expr = netlink_get_register(ctx, loc, sreg);
-
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
+
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_CT_SREG)) {
+		sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
+		expr = netlink_get_register(ctx, loc, sreg);
+	} else if (nftnl_expr_is_set(nle, NFTNL_EXPR_CT_IMM)) {
+		struct nft_data_delinearize nld;
+
+		nld.value = nftnl_expr_get(nle, NFTNL_EXPR_CT_IMM, &nld.len);
+		expr = netlink_alloc_value(loc, &nld);
+	} else {
+		BUG("neither sreg nor immediate present");
+	}
+
 	stmt = ct_stmt_alloc(loc, key, expr);
 	expr_set_type(expr, stmt->ct.tmpl->dtype, stmt->ct.tmpl->byteorder);
 
@@ -1554,6 +1564,31 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	}
 }
 
+static void stmt_ct_postprocess(struct rule_pp_ctx *rctx)
+{
+	struct stmt *stmt = rctx->stmt;
+
+	switch (stmt->ct.key) {
+	case NFT_CT_LABELS: {
+		struct expr *expr = stmt->ct.expr;
+		unsigned int bit;
+
+		assert(expr && expr->ops->type == EXPR_VALUE);
+
+		bit = mpz_get_uint32(expr->value);
+		mpz_set_ui(expr->value, 0);
+		mpz_setbit(expr->value, bit);
+		expr->byteorder = BYTEORDER_BIG_ENDIAN;
+		break;
+	}
+	default:
+		break;
+	}
+
+	if (stmt->ct.expr != NULL)
+		expr_postprocess(rctx, &stmt->ct.expr);
+}
+
 static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 {
 	const struct proto_desc *desc, *base;
@@ -1711,8 +1746,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 				expr_postprocess(&rctx, &stmt->meta.expr);
 			break;
 		case STMT_CT:
-			if (stmt->ct.expr != NULL)
-				expr_postprocess(&rctx, &stmt->ct.expr);
+			stmt_ct_postprocess(&rctx);
 			break;
 		case STMT_NAT:
 			if (stmt->nat.addr != NULL)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 3263043..417e999 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1083,15 +1083,26 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
 				  const struct stmt *stmt)
 {
-	struct nftnl_expr *nle;
+	struct nftnl_expr *nle = alloc_nft_expr("ct");
 	enum nft_registers sreg;
 
-	sreg = get_register(ctx, stmt->ct.expr);
-	netlink_gen_expr(ctx, stmt->ct.expr, sreg);
-	release_register(ctx, stmt->ct.expr);
+	switch (stmt->ct.key) {
+	case NFT_CT_LABELS: {
+		struct nft_data_linearize nld;
+
+		netlink_gen_data(stmt->ct.expr, &nld);
+		nftnl_expr_set(nle, NFTNL_EXPR_CT_IMM, nld.value, nld.len);
+		break;
+	}
+	default:
+		sreg = get_register(ctx, stmt->ct.expr);
+		netlink_gen_expr(ctx, stmt->ct.expr, sreg);
+		release_register(ctx, stmt->ct.expr);
+
+		netlink_put_register(nle, NFTNL_EXPR_CT_SREG, sreg);
+		break;
+	}
 
-	nle = alloc_nft_expr("ct");
-	netlink_put_register(nle, NFTNL_EXPR_CT_SREG, sreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_CT_KEY, stmt->ct.key);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
-- 
2.7.3

