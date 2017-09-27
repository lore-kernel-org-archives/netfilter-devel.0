From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 03/10] src: ct: add eval part to inject dependencies for ct saddr/daddr
Date: Wed, 27 Sep 2017 20:16:47 +0200
Message-ID: <20170927181654.3129-4-fw@strlen.de>
References: <20170927181654.3129-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37754 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdI0SQq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 14:16:46 -0400
In-Reply-To: <20170927181654.3129-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft has enough context to determine if a dependeny is needed.

add rule ip filter ct original ip6 saddr
allows nft to generate an error due to conflicting bases (ip vs ip6).

add rule inet filter ct original ip6 saddr
allows nft to inject an ipv6 dependency expression.

add rule inet filter ct original saddr
will print an error and will suggest to add ip/ip6 keyword.

Delinerize and print support will be added in followup patches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c       | 26 +++++++++++-----------
 src/evaluate.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 77 insertions(+), 19 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index 99e4430bf173..e8298975e692 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -308,21 +308,21 @@ static void ct_expr_clone(struct expr *new, const struct expr *expr)
 static void ct_expr_pctx_update(struct proto_ctx *ctx, const struct expr *expr)
 {
 	const struct expr *left = expr->left, *right = expr->right;
-	const struct proto_desc *base, *desc;
+	const struct proto_desc *base = NULL, *desc;
+	uint32_t nhproto;
 
 	assert(expr->op == OP_EQ);
 
-	switch (left->ct.key) {
-	case NFT_CT_PROTOCOL:
-		base = ctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
-		desc = proto_find_upper(base, mpz_get_uint32(right->value));
+	nhproto = mpz_get_uint32(right->value);
 
-		proto_ctx_update(ctx, PROTO_BASE_TRANSPORT_HDR,
-				 &expr->location, desc);
-		break;
-	default:
-		break;
-	}
+	base = ctx->protocol[left->ct.base].desc;
+	if (!base)
+		return;
+	desc = proto_find_upper(base, nhproto);
+	if (!desc)
+		return;
+
+	proto_ctx_update(ctx, left->ct.base + 1, &expr->location, desc);
 }
 
 static const struct expr_ops ct_expr_ops = {
@@ -374,10 +374,11 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 {
 	const struct proto_desc *desc;
 
+	desc = ctx->protocol[expr->ct.base].desc;
+
 	switch (expr->ct.key) {
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
-		desc = ctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 		if (desc == &proto_ip)
 			expr->dtype = &ipaddr_type;
 		else if (desc == &proto_ip6)
@@ -387,7 +388,6 @@ void ct_expr_update_type(struct proto_ctx *ctx, struct expr *expr)
 		break;
 	case NFT_CT_PROTO_SRC:
 	case NFT_CT_PROTO_DST:
-		desc = ctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
 		if (desc == NULL)
 			break;
 		expr->dtype = &inet_service_type;
diff --git a/src/evaluate.c b/src/evaluate.c
index 836c95288fda..d379a07ec000 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -696,27 +696,85 @@ static int expr_evaluate_rt(struct eval_ctx *ctx, struct expr **expr)
 	return expr_evaluate_primary(ctx, expr);
 }
 
+static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
+{
+	const struct proto_desc *base, *base_now;
+	struct expr *left, *right, *dep;
+	struct stmt *nstmt = NULL;
+
+	base_now = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+
+	switch (ct->ct.nfproto) {
+	case NFPROTO_IPV4:
+		base = &proto_ip;
+		break;
+	case NFPROTO_IPV6:
+		base = &proto_ip6;
+		break;
+	default:
+		base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (base == &proto_ip)
+			ct->ct.nfproto = NFPROTO_IPV4;
+		else if (base == &proto_ip)
+			ct->ct.nfproto = NFPROTO_IPV6;
+
+		if (base)
+			break;
+
+		return expr_error(ctx->msgs, ct,
+				  "cannot determine ip protocol version, use \"ip %1$caddr\" or \"ip6 %1$caddr\" instead",
+				  ct->ct.key == NFT_CT_SRC ? 's' : 'd');
+	}
+
+	/* no additional dependency needed? */
+	if (base == base_now)
+		return 0;
+
+	if (base_now && base_now != base)
+		return expr_error(ctx->msgs, ct,
+				  "conflicting dependencies: %s vs. %s\n",
+				  base->name,
+				  ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc->name);
+	switch (ctx->pctx.family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		return 0;
+	}
+
+	left = ct_expr_alloc(&ct->location, NFT_CT_L3PROTOCOL, ct->ct.direction, ct->ct.nfproto);
+
+	right = constant_expr_alloc(&ct->location, left->dtype,
+				    left->dtype->byteorder, left->len,
+				    constant_data_ptr(ct->ct.nfproto, left->len));
+	dep = relational_expr_alloc(&ct->location, OP_EQ, left, right);
+
+	left->ops->pctx_update(&ctx->pctx, dep);
+
+	nstmt = expr_stmt_alloc(&dep->location, dep);
+
+	list_add_tail(&nstmt->list, &ctx->stmt->list);
+	return 0;
+}
+
 /*
  * CT expression: update the protocol dependant types bases on the protocol
  * context.
  */
 static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 {
-	const struct proto_desc *base;
 	struct expr *ct = *expr;
 
-	ct_expr_update_type(&ctx->pctx, ct);
-
-	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 	switch (ct->ct.key) {
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
-		if (base != &proto_ip && base != &proto_ip6)
-			return expr_error_base(ctx->msgs, ct);
+		ct_gen_nh_dependency(ctx, ct);
+		break;
 	default:
 		break;
 	}
 
+	ct_expr_update_type(&ctx->pctx, ct);
+
 	return expr_evaluate_primary(ctx, expr);
 }
 
-- 
2.13.5

