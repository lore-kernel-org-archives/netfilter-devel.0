From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] ct: add conntrack label set support
Date: Tue, 15 Mar 2016 17:10:11 +0100
Message-ID: <1458058211-11147-4-git-send-email-fw@strlen.de>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55488 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756398AbcCOQKF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 12:10:05 -0400
In-Reply-To: <1458058211-11147-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo suggested to support this by adding the label bit number
that we want to set as a netlink attribute and pass that to the kernel.

IOW, ct label set doesn't use an sreg -- instead, the bit that we
should set in the conntrack label area is taken directly from the user.

This works pretty much the same way as '-m connlabel --set foo'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I find the placement of the expr <-> attribute conversion
 in netlink_(de)linearize to be pretty bad, but doing it
 during stmt_evaluate_ct() requires extra member in
 stmt->ct to store the 'extracted' bit value.

 Thoughts?

 src/evaluate.c            | 19 +++++++++++++++----
 src/netlink_delinearize.c | 24 +++++++++++++++++++++---
 src/netlink_linearize.c   | 20 ++++++++++++++------
 3 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 473f014..7a3be46 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1462,10 +1462,21 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 
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
+	case NFT_CT_LABELS:
+		if (stmt->ct.expr->ops->type != EXPR_VALUE)
+			return stmt_error(ctx, stmt, "label expected");
+		break;
+	default:
+		break;
+	}
+
+	return 0;
 }
 
 static int reject_payload_gen_dependency_tcp(struct eval_ctx *ctx,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d431588..86ff376 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -524,10 +524,28 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 	struct expr *expr;
 
-	sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
-	expr = netlink_get_register(ctx, loc, sreg);
-
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
+	switch (key) {
+	case NFT_CT_LABELS: {
+		unsigned char data[128];
+		mpz_t value;
+
+		mpz_init(value);
+		mpz_setbit(value, nftnl_expr_get_u16(nle, NFTNL_EXPR_CT_LABEL));
+
+		mpz_export_data(data, value, BYTEORDER_HOST_ENDIAN, sizeof(data));
+		expr = constant_expr_alloc(loc, &integer_type,
+					   BYTEORDER_BIG_ENDIAN,
+					   BITS_PER_BYTE * sizeof(data), data);
+		break;
+	}
+	default:
+		sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
+		expr = netlink_get_register(ctx, loc, sreg);
+		break;
+	}
+
+
 	stmt = ct_stmt_alloc(loc, key, expr);
 	expr_set_type(expr, stmt->ct.tmpl->dtype, stmt->ct.tmpl->byteorder);
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index bb51de7..ab1103c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1082,15 +1082,23 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
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
+	case NFT_CT_LABELS:
+		nftnl_expr_set_u16(nle, NFTNL_EXPR_CT_LABEL,
+				   mpz_scan1(stmt->ct.expr->value, 0));
+		break;
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
2.4.10

