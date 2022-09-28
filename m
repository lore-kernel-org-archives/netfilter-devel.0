Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99349C04A95
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 22:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbiI1WJX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 18:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiI1WJW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 18:09:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA0F8B6D38
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 15:09:20 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] src: add dl_proto_ctx()
Date:   Thu, 29 Sep 2022 00:09:12 +0200
Message-Id: <20220928220914.1486-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220928220914.1486-1-pablo@netfilter.org>
References: <20220928220914.1486-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add dl_proto_ctx() to access protocol context (struct proto_ctx and
struct payload_dep_ctx) from the delinearize path.

This patch comes in preparation for supporting outer and inner
protocol context.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h         |   8 ++-
 src/netlink_delinearize.c | 116 ++++++++++++++++++++++----------------
 src/xt.c                  |   8 ++-
 3 files changed, 78 insertions(+), 54 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 63d07edf419e..4823f1e65d67 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -49,9 +49,13 @@ struct netlink_parse_ctx {
 #define RULE_PP_REMOVE_OP_AND		(RULE_PP_IN_CONCATENATION | \
 					 RULE_PP_IN_SET_ELEM)
 
-struct rule_pp_ctx {
+struct dl_proto_ctx {
 	struct proto_ctx	pctx;
 	struct payload_dep_ctx	pdctx;
+};
+
+struct rule_pp_ctx {
+	struct dl_proto_ctx	_dl;
 	struct stmt		*stmt;
 	unsigned int		flags;
 };
@@ -246,4 +250,6 @@ struct nft_expr_loc {
 struct nft_expr_loc *nft_expr_loc_find(const struct nftnl_expr *nle,
 				       struct netlink_linearize_ctx *ctx);
 
+struct dl_proto_ctx *dl_proto_ctx(struct rule_pp_ctx *ctx);
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0da6cc78f94f..7ebe0ef87092 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -30,6 +30,11 @@
 #include <cache.h>
 #include <xt.h>
 
+struct dl_proto_ctx *dl_proto_ctx(struct rule_pp_ctx *ctx)
+{
+	return &ctx->_dl;
+}
+
 static int netlink_parse_expr(const struct nftnl_expr *nle,
 			      struct netlink_parse_ctx *ctx);
 
@@ -1876,11 +1881,12 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 {
 	struct expr *left = payload, *right = expr->right, *tmp;
 	struct list_head list = LIST_HEAD_INIT(list);
-	struct stmt *nstmt;
-	struct expr *nexpr = NULL;
+	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
 	enum proto_bases base = left->payload.base;
+	struct expr *nexpr = NULL;
+	struct stmt *nstmt;
 
-	payload_expr_expand(&list, left, &ctx->pctx);
+	payload_expr_expand(&list, left, &dl->pctx);
 
 	list_for_each_entry(left, &list, list) {
 		tmp = constant_expr_splice(right, left->len);
@@ -1895,7 +1901,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		nexpr = relational_expr_alloc(&expr->location, expr->op,
 					      left, tmp);
 		if (expr->op == OP_EQ)
-			relational_expr_pctx_update(&ctx->pctx, nexpr);
+			relational_expr_pctx_update(&dl->pctx, nexpr);
 
 		nstmt = expr_stmt_alloc(&ctx->stmt->location, nexpr);
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
@@ -1904,17 +1910,17 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		assert(left->payload.base);
 		assert(base == left->payload.base);
 
-		if (payload_is_stacked(ctx->pctx.protocol[base].desc, nexpr))
+		if (payload_is_stacked(dl->pctx.protocol[base].desc, nexpr))
 			base--;
 
 		/* Remember the first payload protocol expression to
 		 * kill it later on if made redundant by a higher layer
 		 * payload expression.
 		 */
-		payload_dependency_kill(&ctx->pdctx, nexpr->left,
-					ctx->pctx.family);
+		payload_dependency_kill(&dl->pdctx, nexpr->left,
+					dl->pctx.family);
 		if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
-			payload_dependency_store(&ctx->pdctx, nstmt, base);
+			payload_dependency_store(&dl->pdctx, nstmt, base);
 	}
 	list_del(&ctx->stmt->list);
 	stmt_free(ctx->stmt);
@@ -1923,6 +1929,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 
 static void payload_icmp_check(struct rule_pp_ctx *rctx, struct expr *expr, const struct expr *value)
 {
+	struct dl_proto_ctx *dl = dl_proto_ctx(rctx);
 	const struct proto_hdr_template *tmpl;
 	const struct proto_desc *desc;
 	uint8_t icmp_type;
@@ -1937,10 +1944,10 @@ static void payload_icmp_check(struct rule_pp_ctx *rctx, struct expr *expr, cons
 	/* icmp(v6) type is 8 bit, if value is smaller or larger, this is not
 	 * a protocol dependency.
 	 */
-	if (expr->len != 8 || value->len != 8 || rctx->pctx.th_dep.icmp.type)
+	if (expr->len != 8 || value->len != 8 || dl->pctx.th_dep.icmp.type)
 		return;
 
-	desc = rctx->pctx.protocol[expr->payload.base].desc;
+	desc = dl->pctx.protocol[expr->payload.base].desc;
 	if (desc == NULL)
 		return;
 
@@ -1968,7 +1975,7 @@ static void payload_icmp_check(struct rule_pp_ctx *rctx, struct expr *expr, cons
 
 		expr->payload.desc = desc;
 		expr->payload.tmpl = tmpl;
-		rctx->pctx.th_dep.icmp.type = icmp_type;
+		dl->pctx.th_dep.icmp.type = icmp_type;
 		return;
 	}
 }
@@ -1977,6 +1984,8 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 				      struct expr *expr,
 				      struct expr *payload)
 {
+	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
+
 	switch (expr->op) {
 	case OP_EQ:
 	case OP_NEQ:
@@ -2000,10 +2009,10 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		}
 		/* Fall through */
 	default:
-		payload_expr_complete(payload, &ctx->pctx);
+		payload_expr_complete(payload, &dl->pctx);
 		expr_set_type(expr->right, payload->dtype,
 			      payload->byteorder);
-		payload_dependency_kill(&ctx->pdctx, payload, ctx->pctx.family);
+		payload_dependency_kill(&dl->pdctx, payload, dl->pctx.family);
 		break;
 	}
 }
@@ -2111,6 +2120,7 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 				       const struct expr *expr,
 				       enum proto_bases base)
 {
+	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
 	const struct expr *left = expr->left;
 	struct expr *right = expr->right;
 
@@ -2124,16 +2134,16 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 		    expr->right->etype == EXPR_SET_REF)
 			break;
 
-		relational_expr_pctx_update(&ctx->pctx, expr);
+		relational_expr_pctx_update(&dl->pctx, expr);
 
 		if (base < PROTO_BASE_TRANSPORT_HDR) {
-			if (payload_dependency_exists(&ctx->pdctx, base) &&
-			    meta_may_dependency_kill(&ctx->pdctx,
-						     ctx->pctx.family, expr))
-				payload_dependency_release(&ctx->pdctx, base);
+			if (payload_dependency_exists(&dl->pdctx, base) &&
+			    meta_may_dependency_kill(&dl->pdctx,
+						     dl->pctx.family, expr))
+				payload_dependency_release(&dl->pdctx, base);
 
 			if (left->flags & EXPR_F_PROTOCOL)
-				payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
+				payload_dependency_store(&dl->pdctx, ctx->stmt, base);
 		}
 		break;
 	default:
@@ -2261,13 +2271,14 @@ static void __binop_postprocess(struct rule_pp_ctx *ctx,
 				struct expr *mask,
 				struct expr **expr_binop)
 {
+	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
 	struct expr *binop = *expr_binop;
 	unsigned int shift;
 
 	assert(binop->etype == EXPR_BINOP);
 
 	if ((left->etype == EXPR_PAYLOAD &&
-	    payload_expr_trim(left, mask, &ctx->pctx, &shift)) ||
+	    payload_expr_trim(left, mask, &dl->pctx, &shift)) ||
 	    (left->etype == EXPR_EXTHDR &&
 	     exthdr_find_template(left, mask, &shift))) {
 		struct expr *right = NULL;
@@ -2519,6 +2530,7 @@ static struct expr *expr_postprocess_string(struct expr *expr)
 
 static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 {
+	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
 	struct expr *expr = *exprp, *i;
 
 	switch (expr->etype) {
@@ -2636,8 +2648,8 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		}
 		break;
 	case EXPR_PAYLOAD:
-		payload_expr_complete(expr, &ctx->pctx);
-		payload_dependency_kill(&ctx->pdctx, expr, ctx->pctx.family);
+		payload_expr_complete(expr, &dl->pctx);
+		payload_dependency_kill(&dl->pdctx, expr, dl->pctx.family);
 		break;
 	case EXPR_VALUE:
 		// FIXME
@@ -2666,7 +2678,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		ctx->flags &= ~RULE_PP_IN_SET_ELEM;
 		break;
 	case EXPR_EXTHDR:
-		exthdr_dependency_kill(&ctx->pdctx, expr, ctx->pctx.family);
+		exthdr_dependency_kill(&dl->pdctx, expr, dl->pctx.family);
 		break;
 	case EXPR_SET_REF:
 	case EXPR_META:
@@ -2683,7 +2695,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			expr_postprocess(ctx, &expr->hash.expr);
 		break;
 	case EXPR_CT:
-		ct_expr_update_type(&ctx->pctx, expr);
+		ct_expr_update_type(&dl->pctx, expr);
 		break;
 	default:
 		BUG("unknown expression type %s\n", expr_name(expr));
@@ -2692,27 +2704,28 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 
 static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 {
+	struct dl_proto_ctx *dl = dl_proto_ctx(rctx);
 	const struct proto_desc *desc, *base;
 	struct stmt *stmt = rctx->stmt;
 	int protocol;
 
-	switch (rctx->pctx.family) {
+	switch (dl->pctx.family) {
 	case NFPROTO_IPV4:
-		stmt->reject.family = rctx->pctx.family;
+		stmt->reject.family = dl->pctx.family;
 		datatype_set(stmt->reject.expr, &icmp_code_type);
 		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
-		    payload_dependency_exists(&rctx->pdctx,
+		    payload_dependency_exists(&dl->pdctx,
 					      PROTO_BASE_TRANSPORT_HDR))
-			payload_dependency_release(&rctx->pdctx,
+			payload_dependency_release(&dl->pdctx,
 						   PROTO_BASE_TRANSPORT_HDR);
 		break;
 	case NFPROTO_IPV6:
-		stmt->reject.family = rctx->pctx.family;
+		stmt->reject.family = dl->pctx.family;
 		datatype_set(stmt->reject.expr, &icmpv6_code_type);
 		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
-		    payload_dependency_exists(&rctx->pdctx,
+		    payload_dependency_exists(&dl->pdctx,
 					      PROTO_BASE_TRANSPORT_HDR))
-			payload_dependency_release(&rctx->pdctx,
+			payload_dependency_release(&dl->pdctx,
 						   PROTO_BASE_TRANSPORT_HDR);
 		break;
 	case NFPROTO_INET:
@@ -2728,8 +2741,8 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		 */
 		stmt->reject.verbose_print = 1;
 
-		base = rctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
-		desc = rctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		base = dl->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		desc = dl->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case NFPROTO_IPV4:			/* INET */
@@ -2746,8 +2759,8 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 			break;
 		}
 
-		if (payload_dependency_exists(&rctx->pdctx, PROTO_BASE_NETWORK_HDR))
-			payload_dependency_release(&rctx->pdctx,
+		if (payload_dependency_exists(&dl->pdctx, PROTO_BASE_NETWORK_HDR))
+			payload_dependency_release(&dl->pdctx,
 						   PROTO_BASE_NETWORK_HDR);
 		break;
 	default:
@@ -2791,23 +2804,24 @@ static bool expr_may_merge_range(struct expr *expr, struct expr *prev,
 
 static void expr_postprocess_range(struct rule_pp_ctx *ctx, enum ops op)
 {
+	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
 	struct stmt *nstmt, *stmt = ctx->stmt;
 	struct expr *nexpr, *rel;
 
-	nexpr = range_expr_alloc(&ctx->pdctx.prev->location,
-				 expr_clone(ctx->pdctx.prev->expr->right),
+	nexpr = range_expr_alloc(&dl->pdctx.prev->location,
+				 expr_clone(dl->pdctx.prev->expr->right),
 				 expr_clone(stmt->expr->right));
 	expr_set_type(nexpr, stmt->expr->right->dtype,
 		      stmt->expr->right->byteorder);
 
-	rel = relational_expr_alloc(&ctx->pdctx.prev->location, op,
+	rel = relational_expr_alloc(&dl->pdctx.prev->location, op,
 				    expr_clone(stmt->expr->left), nexpr);
 
 	nstmt = expr_stmt_alloc(&stmt->location, rel);
 	list_add_tail(&nstmt->list, &stmt->list);
 
-	list_del(&ctx->pdctx.prev->list);
-	stmt_free(ctx->pdctx.prev);
+	list_del(&dl->pdctx.prev->list);
+	stmt_free(dl->pdctx.prev);
 
 	list_del(&stmt->list);
 	stmt_free(stmt);
@@ -2816,26 +2830,28 @@ static void expr_postprocess_range(struct rule_pp_ctx *ctx, enum ops op)
 
 static void stmt_expr_postprocess(struct rule_pp_ctx *ctx)
 {
+	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
 	enum ops op;
 
 	expr_postprocess(ctx, &ctx->stmt->expr);
 
-	if (ctx->pdctx.prev && ctx->stmt &&
-	    ctx->stmt->ops->type == ctx->pdctx.prev->ops->type &&
-	    expr_may_merge_range(ctx->stmt->expr, ctx->pdctx.prev->expr, &op))
+	if (dl->pdctx.prev && ctx->stmt &&
+	    ctx->stmt->ops->type == dl->pdctx.prev->ops->type &&
+	    expr_may_merge_range(ctx->stmt->expr, dl->pdctx.prev->expr, &op))
 		expr_postprocess_range(ctx, op);
 }
 
 static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
 {
+	struct dl_proto_ctx *dl = dl_proto_ctx(ctx);
 	struct expr *payload = binop->left;
 	struct expr *mask = binop->right;
 	unsigned int shift;
 
 	assert(payload->etype == EXPR_PAYLOAD);
-	if (payload_expr_trim(payload, mask, &ctx->pctx, &shift)) {
+	if (payload_expr_trim(payload, mask, &dl->pctx, &shift)) {
 		binop_adjust(binop, mask, shift);
-		payload_expr_complete(payload, &ctx->pctx);
+		payload_expr_complete(payload, &dl->pctx);
 		expr_set_type(mask, payload->dtype,
 			      payload->byteorder);
 	}
@@ -3044,7 +3060,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 	struct expr *expr;
 
 	memset(&rctx, 0, sizeof(rctx));
-	proto_ctx_init(&rctx.pctx, rule->handle.family, ctx->debug_mask);
+	proto_ctx_init(&rctx._dl.pctx, rule->handle.family, ctx->debug_mask);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
 		enum stmt_types type = stmt->ops->type;
@@ -3081,7 +3097,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			if (stmt->nat.addr != NULL)
 				expr_postprocess(&rctx, &stmt->nat.addr);
 			if (stmt->nat.proto != NULL) {
-				payload_dependency_reset(&rctx.pdctx);
+				payload_dependency_reset(&rctx._dl.pdctx);
 				expr_postprocess(&rctx, &stmt->nat.proto);
 			}
 			break;
@@ -3089,7 +3105,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			if (stmt->tproxy.addr)
 				expr_postprocess(&rctx, &stmt->tproxy.addr);
 			if (stmt->tproxy.port) {
-				payload_dependency_reset(&rctx.pdctx);
+				payload_dependency_reset(&rctx._dl.pdctx);
 				expr_postprocess(&rctx, &stmt->tproxy.port);
 			}
 			break;
@@ -3127,9 +3143,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			break;
 		}
 
-		rctx.pdctx.prev = rctx.stmt;
+		rctx._dl.pdctx.prev = rctx.stmt;
 
-		rule_maybe_reset_payload_deps(&rctx.pdctx, type);
+		rule_maybe_reset_payload_deps(&rctx._dl.pdctx, type);
 	}
 }
 
diff --git a/src/xt.c b/src/xt.c
index 789de9926261..fa8dd4fe4176 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -305,11 +305,13 @@ static bool is_watcher(uint32_t family, struct stmt *stmt)
 void stmt_xt_postprocess(struct rule_pp_ctx *rctx, struct stmt *stmt,
 			 struct rule *rule)
 {
-	if (is_watcher(rctx->pctx.family, stmt))
+	struct dl_proto_ctx *dl = dl_proto_ctx(rctx);
+
+	if (is_watcher(dl->pctx.family, stmt))
 		stmt->xt.type = NFT_XT_WATCHER;
 
-	stmt->xt.proto = xt_proto(&rctx->pctx);
-	stmt->xt.entry = xt_entry_alloc(&stmt->xt, rctx->pctx.family);
+	stmt->xt.proto = xt_proto(&dl->pctx);
+	stmt->xt.entry = xt_entry_alloc(&stmt->xt, dl->pctx.family);
 }
 
 static int nft_xt_compatible_revision(const char *name, uint8_t rev, int opt)
-- 
2.30.2

