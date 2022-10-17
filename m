Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30BBC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJQLET (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJQLES (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56A5710C8
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 01/16] src: add eval_proto_ctx()
Date:   Mon, 17 Oct 2022 13:03:53 +0200
Message-Id: <20221017110408.742223-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221017110408.742223-1-pablo@netfilter.org>
References: <20221017110408.742223-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add eval_proto_ctx() to access protocol context (struct proto_ctx).
Rename struct proto_ctx field to _pctx to highlight that this field
is internal and the helper function should be used.

This patch comes in preparation for supporting outer and inner
protocol context.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/proto.h |   3 +
 include/rule.h  |   2 +-
 src/evaluate.c  | 188 +++++++++++++++++++++++++++++-------------------
 src/payload.c   |  58 +++++++++------
 4 files changed, 154 insertions(+), 97 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index 35e760c7e16e..6a9289b17f05 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -413,4 +413,7 @@ extern const struct datatype icmp6_type_type;
 extern const struct datatype dscp_type;
 extern const struct datatype ecn_type;
 
+struct eval_ctx;
+struct proto_ctx *eval_proto_ctx(struct eval_ctx *ctx);
+
 #endif /* NFTABLES_PROTO_H */
diff --git a/include/rule.h b/include/rule.h
index ad9f91273722..795951326886 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -768,7 +768,7 @@ struct eval_ctx {
 	struct set		*set;
 	struct stmt		*stmt;
 	struct expr_ctx		ectx;
-	struct proto_ctx	pctx;
+	struct proto_ctx	_pctx;
 };
 
 extern int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd);
diff --git a/src/evaluate.c b/src/evaluate.c
index 0bf6a0d1b110..7f371dc5f569 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -39,6 +39,11 @@
 #include <utils.h>
 #include <xt.h>
 
+struct proto_ctx *eval_proto_ctx(struct eval_ctx *ctx)
+{
+	return &ctx->_pctx;
+}
+
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
 
 static const char * const byteorder_names[] = {
@@ -427,11 +432,13 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
 	const struct proto_hdr_template *tmpl;
 	const struct proto_desc *desc = NULL;
 	struct expr *dep, *left, *right;
+	struct proto_ctx *pctx;
 	struct stmt *stmt;
 
 	assert(expr->payload.base == PROTO_BASE_LL_HDR);
 
-	desc = ctx->pctx.protocol[base].desc;
+	pctx = eval_proto_ctx(ctx);
+	desc = pctx->protocol[base].desc;
 	tmpl = &desc->templates[desc->protocol_key];
 	left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
 
@@ -577,6 +584,7 @@ static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 	const struct proto_desc *base, *dependency = NULL;
 	enum proto_bases pb = PROTO_BASE_NETWORK_HDR;
 	struct expr *expr = *exprp;
+	struct proto_ctx *pctx;
 	struct stmt *nstmt;
 
 	switch (expr->exthdr.op) {
@@ -594,7 +602,8 @@ static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 
 	assert(dependency);
 
-	base = ctx->pctx.protocol[pb].desc;
+	pctx = eval_proto_ctx(ctx);
+	base = pctx->protocol[pb].desc;
 	if (base == dependency)
 		return __expr_evaluate_exthdr(ctx, exprp);
 
@@ -657,8 +666,11 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 {
 	enum proto_bases base = payload->payload.base;
 	struct stmt *nstmt = NULL;
+	struct proto_ctx *pctx;
 	int link, err;
 
+	pctx = eval_proto_ctx(ctx);
+
 	if (payload->payload.base == PROTO_BASE_LL_HDR) {
 		if (proto_is_dummy(desc)) {
 			err = meta_iiftype_gen_dependency(ctx, payload, &nstmt);
@@ -671,8 +683,8 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 			unsigned int i;
 
 			/* payload desc stored in the L2 header stack? No conflict. */
-			for (i = 0; i < ctx->pctx.stacked_ll_count; i++) {
-				if (ctx->pctx.stacked_ll[i] == payload->payload.desc)
+			for (i = 0; i < pctx->stacked_ll_count; i++) {
+				if (pctx->stacked_ll[i] == payload->payload.desc)
 					return 0;
 			}
 		}
@@ -680,7 +692,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 
 	assert(base <= PROTO_BASE_MAX);
 	/* This payload and the existing context don't match, conflict. */
-	if (ctx->pctx.protocol[base + 1].desc != NULL)
+	if (pctx->protocol[base + 1].desc != NULL)
 		return 1;
 
 	link = proto_find_num(desc, payload->payload.desc);
@@ -691,8 +703,8 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 	if (base == PROTO_BASE_LL_HDR) {
 		unsigned int i;
 
-		for (i = 0; i < ctx->pctx.stacked_ll_count; i++)
-			payload->payload.offset += ctx->pctx.stacked_ll[i]->length;
+		for (i = 0; i < pctx->stacked_ll_count; i++)
+			payload->payload.offset += pctx->stacked_ll[i]->length;
 	}
 
 	rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
@@ -710,19 +722,22 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 	struct expr *payload = expr;
 	enum proto_bases base = payload->payload.base;
 	const struct proto_desc *desc;
+	struct proto_ctx *pctx;
 	struct stmt *nstmt;
 	int err;
 
 	if (expr->etype == EXPR_PAYLOAD && expr->payload.is_raw)
 		return 0;
 
-	desc = ctx->pctx.protocol[base].desc;
+	pctx = eval_proto_ctx(ctx);
+	desc = pctx->protocol[base].desc;
 	if (desc == NULL) {
 		if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 			return -1;
 
 		rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
-		desc = ctx->pctx.protocol[base].desc;
+
+		desc = pctx->protocol[base].desc;
 
 		if (desc == expr->payload.desc)
 			goto check_icmp;
@@ -738,15 +753,16 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 						  desc->name,
 						  payload->payload.desc->name);
 
-			payload->payload.offset += ctx->pctx.stacked_ll[0]->length;
+			payload->payload.offset += pctx->stacked_ll[0]->length;
 			rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
 			return 1;
 		}
+		goto check_icmp;
 	}
 
 	if (payload->payload.base == desc->base &&
-	    proto_ctx_is_ambiguous(&ctx->pctx, base)) {
-		desc = proto_ctx_find_conflict(&ctx->pctx, base, payload->payload.desc);
+	    proto_ctx_is_ambiguous(pctx, base)) {
+		desc = proto_ctx_find_conflict(pctx, base, payload->payload.desc);
 		assert(desc);
 
 		return expr_error(ctx->msgs, payload,
@@ -764,8 +780,8 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 		if (desc->base == PROTO_BASE_LL_HDR) {
 			unsigned int i;
 
-			for (i = 0; i < ctx->pctx.stacked_ll_count; i++)
-				payload->payload.offset += ctx->pctx.stacked_ll[i]->length;
+			for (i = 0; i < pctx->stacked_ll_count; i++)
+				payload->payload.offset += pctx->stacked_ll[i]->length;
 		}
 check_icmp:
 		if (desc != &proto_icmp && desc != &proto_icmp6)
@@ -792,13 +808,13 @@ check_icmp:
 		if (err <= 0)
 			return err;
 
-		desc = ctx->pctx.protocol[base].desc;
+		desc = pctx->protocol[base].desc;
 		if (desc == payload->payload.desc)
 			return 0;
 	}
 	return expr_error(ctx->msgs, payload,
 			  "conflicting protocols specified: %s vs. %s",
-			  ctx->pctx.protocol[base].desc->name,
+			  pctx->protocol[base].desc->name,
 			  payload->payload.desc->name);
 }
 
@@ -836,20 +852,22 @@ static int expr_evaluate_rt(struct eval_ctx *ctx, struct expr **expr)
 {
 	static const char emsg[] = "cannot determine ip protocol version, use \"ip nexthop\" or \"ip6 nexthop\" instead";
 	struct expr *rt = *expr;
+	struct proto_ctx *pctx;
 
-	rt_expr_update_type(&ctx->pctx, rt);
+	pctx = eval_proto_ctx(ctx);
+	rt_expr_update_type(pctx, rt);
 
 	switch (rt->rt.key) {
 	case NFT_RT_NEXTHOP4:
 		if (rt->dtype != &ipaddr_type)
 			return expr_error(ctx->msgs, rt, "%s", emsg);
-		if (ctx->pctx.family == NFPROTO_IPV6)
+		if (pctx->family == NFPROTO_IPV6)
 			return expr_error(ctx->msgs, rt, "%s nexthop will not match", "ip");
 		break;
 	case NFT_RT_NEXTHOP6:
 		if (rt->dtype != &ip6addr_type)
 			return expr_error(ctx->msgs, rt, "%s", emsg);
-		if (ctx->pctx.family == NFPROTO_IPV4)
+		if (pctx->family == NFPROTO_IPV4)
 			return expr_error(ctx->msgs, rt, "%s nexthop will not match", "ip6");
 		break;
 	default:
@@ -864,8 +882,10 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
 	const struct proto_desc *base, *base_now;
 	struct expr *left, *right, *dep;
 	struct stmt *nstmt = NULL;
+	struct proto_ctx *pctx;
 
-	base_now = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	pctx = eval_proto_ctx(ctx);
+	base_now = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 
 	switch (ct->ct.nfproto) {
 	case NFPROTO_IPV4:
@@ -875,7 +895,7 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
 		base = &proto_ip6;
 		break;
 	default:
-		base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		base = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 		if (base == &proto_ip)
 			ct->ct.nfproto = NFPROTO_IPV4;
 		else if (base == &proto_ip)
@@ -897,8 +917,8 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
 		return expr_error(ctx->msgs, ct,
 				  "conflicting dependencies: %s vs. %s\n",
 				  base->name,
-				  ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc->name);
-	switch (ctx->pctx.family) {
+				  pctx->protocol[PROTO_BASE_NETWORK_HDR].desc->name);
+	switch (pctx->family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 		return 0;
@@ -911,7 +931,7 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
 				    constant_data_ptr(ct->ct.nfproto, left->len));
 	dep = relational_expr_alloc(&ct->location, OP_EQ, left, right);
 
-	relational_expr_pctx_update(&ctx->pctx, dep);
+	relational_expr_pctx_update(pctx, dep);
 
 	nstmt = expr_stmt_alloc(&dep->location, dep);
 	rule_stmt_insert_at(ctx->rule, nstmt, ctx->stmt);
@@ -927,8 +947,10 @@ static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 {
 	const struct proto_desc *base, *error;
 	struct expr *ct = *expr;
+	struct proto_ctx *pctx;
 
-	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	pctx = eval_proto_ctx(ctx);
+	base = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 
 	switch (ct->ct.key) {
 	case NFT_CT_SRC:
@@ -953,13 +975,13 @@ static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 		break;
 	}
 
-	ct_expr_update_type(&ctx->pctx, ct);
+	ct_expr_update_type(pctx, ct);
 
 	return expr_evaluate_primary(ctx, expr);
 
 err_conflict:
 	return stmt_binary_error(ctx, ct,
-				 &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				 &pctx->protocol[PROTO_BASE_NETWORK_HDR],
 				 "conflicting protocols specified: %s vs. %s",
 				 base->name, error->name);
 }
@@ -2113,6 +2135,7 @@ static bool range_needs_swap(const struct expr *range)
 static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *rel = *expr, *left, *right;
+	struct proto_ctx *pctx;
 	struct expr *range;
 	int ret;
 
@@ -2120,6 +2143,8 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 	left = rel->left;
 
+	pctx = eval_proto_ctx(ctx);
+
 	if (rel->right->etype == EXPR_RANGE && lhs_is_meta_hour(rel->left)) {
 		ret = __expr_evaluate_range(ctx, &rel->right);
 		if (ret)
@@ -2187,7 +2212,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		 * Update protocol context for payload and meta iiftype
 		 * equality expressions.
 		 */
-		relational_expr_pctx_update(&ctx->pctx, rel);
+		relational_expr_pctx_update(pctx, rel);
 
 		/* fall through */
 	case OP_NEQ:
@@ -2299,11 +2324,12 @@ static int expr_evaluate_fib(struct eval_ctx *ctx, struct expr **exprp)
 
 static int expr_evaluate_meta(struct eval_ctx *ctx, struct expr **exprp)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	struct expr *meta = *exprp;
 
 	switch (meta->meta.key) {
 	case NFT_META_NFPROTO:
-		if (ctx->pctx.family != NFPROTO_INET &&
+		if (pctx->family != NFPROTO_INET &&
 		    meta->flags & EXPR_F_PROTOCOL)
 			return expr_error(ctx->msgs, meta,
 					  "meta nfproto is only useful in the inet family");
@@ -2370,9 +2396,10 @@ static int expr_evaluate_variable(struct eval_ctx *ctx, struct expr **exprp)
 
 static int expr_evaluate_xfrm(struct eval_ctx *ctx, struct expr **exprp)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	struct expr *expr = *exprp;
 
-	switch (ctx->pctx.family) {
+	switch (pctx->family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 	case NFPROTO_INET:
@@ -2815,9 +2842,10 @@ static int reject_payload_gen_dependency_tcp(struct eval_ctx *ctx,
 					     struct stmt *stmt,
 					     struct expr **payload)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *desc;
 
-	desc = ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+	desc = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
 	if (desc != NULL)
 		return 0;
 	*payload = payload_expr_alloc(&stmt->location, &proto_tcp,
@@ -2829,9 +2857,10 @@ static int reject_payload_gen_dependency_family(struct eval_ctx *ctx,
 						struct stmt *stmt,
 						struct expr **payload)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *base;
 
-	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	base = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 	if (base != NULL)
 		return 0;
 
@@ -2898,6 +2927,7 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 					    struct stmt *stmt,
 					    const struct proto_desc *desc)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *base;
 	int protocol;
 
@@ -2907,7 +2937,7 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 	case NFT_REJECT_ICMPX_UNREACH:
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
-		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		base = pctx->protocol[PROTO_BASE_LL_HDR].desc;
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case NFPROTO_IPV4:
@@ -2915,14 +2945,14 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 			if (stmt->reject.family == NFPROTO_IPV4)
 				break;
 			return stmt_binary_error(ctx, stmt->reject.expr,
-				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				  &pctx->protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		case NFPROTO_IPV6:
 		case __constant_htons(ETH_P_IPV6):
 			if (stmt->reject.family == NFPROTO_IPV6)
 				break;
 			return stmt_binary_error(ctx, stmt->reject.expr,
-				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				  &pctx->protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		default:
 			return stmt_error(ctx, stmt,
@@ -2937,9 +2967,10 @@ static int stmt_evaluate_reject_inet_family(struct eval_ctx *ctx,
 static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt,
 				     struct expr *expr)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *desc;
 
-	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	desc = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 	if (desc != NULL &&
 	    stmt_evaluate_reject_inet_family(ctx, stmt, desc) < 0)
 		return -1;
@@ -2954,13 +2985,14 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 					      struct stmt *stmt,
 					      const struct proto_desc *desc)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *base;
 	int protocol;
 
 	switch (stmt->reject.type) {
 	case NFT_REJECT_ICMPX_UNREACH:
 	case NFT_REJECT_TCP_RST:
-		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		base = pctx->protocol[PROTO_BASE_LL_HDR].desc;
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case __constant_htons(ETH_P_IP):
@@ -2968,29 +3000,29 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 			break;
 		default:
 			return stmt_binary_error(ctx, stmt,
-				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				    &pctx->protocol[PROTO_BASE_NETWORK_HDR],
 				    "cannot reject this network family");
 		}
 		break;
 	case NFT_REJECT_ICMP_UNREACH:
-		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		base = pctx->protocol[PROTO_BASE_LL_HDR].desc;
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case __constant_htons(ETH_P_IP):
 			if (NFPROTO_IPV4 == stmt->reject.family)
 				break;
 			return stmt_binary_error(ctx, stmt->reject.expr,
-				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				  &pctx->protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		case __constant_htons(ETH_P_IPV6):
 			if (NFPROTO_IPV6 == stmt->reject.family)
 				break;
 			return stmt_binary_error(ctx, stmt->reject.expr,
-				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				  &pctx->protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		default:
 			return stmt_binary_error(ctx, stmt,
-				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+				    &pctx->protocol[PROTO_BASE_NETWORK_HDR],
 				    "cannot reject this network family");
 		}
 		break;
@@ -3002,14 +3034,15 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
 				       struct expr *expr)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *desc;
 
-	desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+	desc = pctx->protocol[PROTO_BASE_LL_HDR].desc;
 	if (desc != &proto_eth && desc != &proto_vlan && desc != &proto_netdev)
 		return __stmt_binary_error(ctx, &stmt->location, NULL,
 					   "cannot reject from this link layer protocol");
 
-	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	desc = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 	if (desc != NULL &&
 	    stmt_evaluate_reject_bridge_family(ctx, stmt, desc) < 0)
 		return -1;
@@ -3023,7 +3056,9 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
 static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 				       struct expr *expr)
 {
-	switch (ctx->pctx.family) {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
+
+	switch (pctx->family) {
 	case NFPROTO_ARP:
 		return stmt_error(ctx, stmt, "cannot use reject with arp");
 	case NFPROTO_IPV4:
@@ -3037,7 +3072,7 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 			return stmt_binary_error(ctx, stmt->reject.expr, stmt,
 				   "abstracted ICMP unreachable not supported");
 		case NFT_REJECT_ICMP_UNREACH:
-			if (stmt->reject.family == ctx->pctx.family)
+			if (stmt->reject.family == pctx->family)
 				break;
 			return stmt_binary_error(ctx, stmt->reject.expr, stmt,
 				  "conflicting protocols specified: ip vs ip6");
@@ -3061,28 +3096,29 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 static int stmt_evaluate_reject_default(struct eval_ctx *ctx,
 					  struct stmt *stmt)
 {
-	int protocol;
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *desc, *base;
+	int protocol;
 
-	switch (ctx->pctx.family) {
+	switch (pctx->family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
-		stmt->reject.family = ctx->pctx.family;
-		if (ctx->pctx.family == NFPROTO_IPV4)
+		stmt->reject.family = pctx->family;
+		if (pctx->family == NFPROTO_IPV4)
 			stmt->reject.icmp_code = ICMP_PORT_UNREACH;
 		else
 			stmt->reject.icmp_code = ICMP6_DST_UNREACH_NOPORT;
 		break;
 	case NFPROTO_INET:
-		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		desc = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 		if (desc == NULL) {
 			stmt->reject.type = NFT_REJECT_ICMPX_UNREACH;
 			stmt->reject.icmp_code = NFT_REJECT_ICMPX_PORT_UNREACH;
 			break;
 		}
 		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
-		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		base = pctx->protocol[PROTO_BASE_LL_HDR].desc;
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case NFPROTO_IPV4:
@@ -3099,14 +3135,14 @@ static int stmt_evaluate_reject_default(struct eval_ctx *ctx,
 		break;
 	case NFPROTO_BRIDGE:
 	case NFPROTO_NETDEV:
-		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		desc = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 		if (desc == NULL) {
 			stmt->reject.type = NFT_REJECT_ICMPX_UNREACH;
 			stmt->reject.icmp_code = NFT_REJECT_ICMPX_PORT_UNREACH;
 			break;
 		}
 		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
-		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		base = pctx->protocol[PROTO_BASE_LL_HDR].desc;
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case __constant_htons(ETH_P_IP):
@@ -3142,9 +3178,9 @@ static int stmt_evaluate_reject_icmp(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_reset(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	int protonum;
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *desc, *base;
-	struct proto_ctx *pctx = &ctx->pctx;
+	int protonum;
 
 	desc = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
 	if (desc == NULL)
@@ -3161,7 +3197,7 @@ static int stmt_evaluate_reset(struct eval_ctx *ctx, struct stmt *stmt)
 	default:
 		if (stmt->reject.type == NFT_REJECT_TCP_RST) {
 			return stmt_binary_error(ctx, stmt,
-				 &ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR],
+				 &pctx->protocol[PROTO_BASE_TRANSPORT_HDR],
 				 "you cannot use tcp reset with this protocol");
 		}
 		break;
@@ -3189,13 +3225,14 @@ static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *nproto;
 
-	switch (ctx->pctx.family) {
+	switch (pctx->family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 		if (stmt->nat.family == NFPROTO_UNSPEC)
-			stmt->nat.family = ctx->pctx.family;
+			stmt->nat.family = pctx->family;
 		return 0;
 	case NFPROTO_INET:
 		if (!stmt->nat.addr) {
@@ -3205,7 +3242,7 @@ static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
 		if (stmt->nat.family != NFPROTO_UNSPEC)
 			return 0;
 
-		nproto = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		nproto = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 
 		if (nproto == &proto_ip)
 			stmt->nat.family = NFPROTO_IPV4;
@@ -3234,7 +3271,7 @@ static const struct datatype *get_addr_dtype(uint8_t family)
 static int evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 			     struct expr **expr)
 {
-	struct proto_ctx *pctx = &ctx->pctx;
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct datatype *dtype;
 
 	dtype = get_addr_dtype(pctx->family);
@@ -3287,7 +3324,7 @@ static bool nat_evaluate_addr_has_th_expr(const struct expr *map)
 static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 				  struct expr **expr)
 {
-	struct proto_ctx *pctx = &ctx->pctx;
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 
 	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL &&
 	    !nat_evaluate_addr_has_th_expr(stmt->nat.addr))
@@ -3303,16 +3340,17 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
 static int stmt_evaluate_l3proto(struct eval_ctx *ctx,
 				 struct stmt *stmt, uint8_t family)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_desc *nproto;
 
-	nproto = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	nproto = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
 
 	if ((nproto == &proto_ip && family != NFPROTO_IPV4) ||
 	    (nproto == &proto_ip6 && family != NFPROTO_IPV6))
 		return stmt_binary_error(ctx, stmt,
-					 &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
+					 &pctx->protocol[PROTO_BASE_NETWORK_HDR],
 					 "conflicting protocols specified: %s vs. %s. You must specify ip or ip6 family in %s statement",
-					 ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc->name,
+					 pctx->protocol[PROTO_BASE_NETWORK_HDR].desc->name,
 					 family2str(family),
 					 stmt->ops->name);
 	return 0;
@@ -3322,10 +3360,11 @@ static int stmt_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 			      uint8_t family,
 			      struct expr **addr)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct datatype *dtype;
 	int err;
 
-	if (ctx->pctx.family == NFPROTO_INET) {
+	if (pctx->family == NFPROTO_INET) {
 		dtype = get_addr_dtype(family);
 		if (dtype->size == 0)
 			return stmt_error(ctx, stmt,
@@ -3342,7 +3381,7 @@ static int stmt_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 
 static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct proto_ctx *pctx = &ctx->pctx;
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	struct expr *one, *two, *data, *tmp;
 	const struct datatype *dtype;
 	int addr_type, err;
@@ -3491,13 +3530,14 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	int err;
 
-	switch (ctx->pctx.family) {
+	switch (pctx->family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6: /* fallthrough */
 		if (stmt->tproxy.family == NFPROTO_UNSPEC)
-			stmt->tproxy.family = ctx->pctx.family;
+			stmt->tproxy.family = pctx->family;
 		break;
 	case NFPROTO_INET:
 		break;
@@ -3506,7 +3546,7 @@ static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
 				  "tproxy is only supported for IPv4/IPv6/INET");
 	}
 
-	if (ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
+	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL)
 		return stmt_error(ctx, stmt, "Transparent proxy support requires"
 					     " transport protocol match");
 
@@ -3616,9 +3656,10 @@ static int stmt_evaluate_optstrip(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	int err;
 
-	switch (ctx->pctx.family) {
+	switch (pctx->family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
 		if (stmt->dup.to == NULL)
@@ -3658,10 +3699,11 @@ static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_fwd(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct datatype *dtype;
 	int err, len;
 
-	switch (ctx->pctx.family) {
+	switch (pctx->family) {
 	case NFPROTO_NETDEV:
 		if (stmt->fwd.dev == NULL)
 			return stmt_error(ctx, stmt,
@@ -4487,7 +4529,7 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
 
-	proto_ctx_init(&ctx->pctx, rule->handle.family, ctx->nft->debug_mask);
+	proto_ctx_init(&ctx->_pctx, rule->handle.family, ctx->nft->debug_mask);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
 	ctx->rule = rule;
diff --git a/src/payload.c b/src/payload.c
index 2c0d0ac9e8ae..07f02359a7e7 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -391,9 +391,11 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 {
 	const struct proto_hdr_template *tmpl;
 	struct expr *dep, *left, *right;
+	struct proto_ctx *pctx;
 	struct stmt *stmt;
-	int protocol = proto_find_num(desc, upper);
+	int protocol;
 
+	protocol = proto_find_num(desc, upper);
 	if (protocol < 0)
 		return expr_error(ctx->msgs, expr,
 				  "conflicting protocols specified: %s vs. %s",
@@ -415,15 +417,17 @@ static int payload_add_dependency(struct eval_ctx *ctx,
 		return expr_error(ctx->msgs, expr,
 					  "dependency statement is invalid");
 	}
-	relational_expr_pctx_update(&ctx->pctx, dep);
+
+	pctx = eval_proto_ctx(ctx);
+	relational_expr_pctx_update(pctx, dep);
 	*res = stmt;
 	return 0;
 }
 
 static const struct proto_desc *
-payload_get_get_ll_hdr(const struct eval_ctx *ctx)
+payload_get_get_ll_hdr(const struct proto_ctx *pctx)
 {
-	switch (ctx->pctx.family) {
+	switch (pctx->family) {
 	case NFPROTO_INET:
 		return &proto_inet;
 	case NFPROTO_BRIDGE:
@@ -440,9 +444,11 @@ payload_get_get_ll_hdr(const struct eval_ctx *ctx)
 static const struct proto_desc *
 payload_gen_special_dependency(struct eval_ctx *ctx, const struct expr *expr)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
+
 	switch (expr->payload.base) {
 	case PROTO_BASE_LL_HDR:
-		return payload_get_get_ll_hdr(ctx);
+		return payload_get_get_ll_hdr(pctx);
 	case PROTO_BASE_TRANSPORT_HDR:
 		if (expr->payload.desc == &proto_icmp ||
 		    expr->payload.desc == &proto_icmp6 ||
@@ -450,9 +456,9 @@ payload_gen_special_dependency(struct eval_ctx *ctx, const struct expr *expr)
 			const struct proto_desc *desc, *desc_upper;
 			struct stmt *nstmt;
 
-			desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+			desc = pctx->protocol[PROTO_BASE_LL_HDR].desc;
 			if (!desc) {
-				desc = payload_get_get_ll_hdr(ctx);
+				desc = payload_get_get_ll_hdr(pctx);
 				if (!desc)
 					break;
 			}
@@ -502,11 +508,14 @@ payload_gen_special_dependency(struct eval_ctx *ctx, const struct expr *expr)
 int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 			   struct stmt **res)
 {
-	const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
+	const struct hook_proto_desc *h;
 	const struct proto_desc *desc;
+	struct proto_ctx *pctx;
 	struct stmt *stmt;
 	uint16_t type;
 
+	pctx = eval_proto_ctx(ctx);
+	h = &hook_proto_desc[pctx->family];
 	if (expr->payload.base < h->base) {
 		if (expr->payload.base < h->base - 1)
 			return expr_error(ctx->msgs, expr,
@@ -527,7 +536,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		return 0;
 	}
 
-	desc = ctx->pctx.protocol[expr->payload.base - 1].desc;
+	desc = pctx->protocol[expr->payload.base - 1].desc;
 	/* Special case for mixed IPv4/IPv6 and bridge tables */
 	if (desc == NULL)
 		desc = payload_gen_special_dependency(ctx, expr);
@@ -538,7 +547,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  "no %s protocol specified",
 				  proto_base_names[expr->payload.base - 1]);
 
-	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
+	if (pctx->family == NFPROTO_BRIDGE && desc == &proto_eth) {
 		/* prefer netdev proto, which adds dependencies based
 		 * on skb->protocol.
 		 *
@@ -563,11 +572,13 @@ int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 			  enum proto_bases pb, struct stmt **res)
 {
 	const struct proto_desc *desc;
+	struct proto_ctx *pctx;
 
-	desc = ctx->pctx.protocol[pb].desc;
+	pctx = eval_proto_ctx(ctx);
+	desc = pctx->protocol[pb].desc;
 	if (desc == NULL) {
 		if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
-			switch (ctx->pctx.family) {
+			switch (pctx->family) {
 			case NFPROTO_NETDEV:
 			case NFPROTO_BRIDGE:
 			case NFPROTO_INET:
@@ -1226,6 +1237,7 @@ __payload_gen_icmp_echo_dependency(struct eval_ctx *ctx, const struct expr *expr
 int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				struct stmt **res)
 {
+	struct proto_ctx *pctx = eval_proto_ctx(ctx);
 	const struct proto_hdr_template *tmpl;
 	const struct proto_desc *desc;
 	struct stmt *stmt = NULL;
@@ -1242,11 +1254,11 @@ int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		break;
 	case PROTO_ICMP_ECHO:
 		/* do not test ICMP_ECHOREPLY here: its 0 */
-		if (ctx->pctx.th_dep.icmp.type == ICMP_ECHO)
+		if (pctx->th_dep.icmp.type == ICMP_ECHO)
 			goto done;
 
 		type = ICMP_ECHO;
-		if (ctx->pctx.th_dep.icmp.type)
+		if (pctx->th_dep.icmp.type)
 			goto bad_proto;
 
 		stmt = __payload_gen_icmp_echo_dependency(ctx, expr,
@@ -1257,21 +1269,21 @@ int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
 	case PROTO_ICMP_MTU:
 	case PROTO_ICMP_ADDRESS:
 		type = icmp_dep_to_type(tmpl->icmp_dep);
-		if (ctx->pctx.th_dep.icmp.type == type)
+		if (pctx->th_dep.icmp.type == type)
 			goto done;
-		if (ctx->pctx.th_dep.icmp.type)
+		if (pctx->th_dep.icmp.type)
 			goto bad_proto;
 		stmt = __payload_gen_icmp_simple_dependency(ctx, expr,
 							    &icmp_type_type,
 							    desc, type);
 		break;
 	case PROTO_ICMP6_ECHO:
-		if (ctx->pctx.th_dep.icmp.type == ICMP6_ECHO_REQUEST ||
-		    ctx->pctx.th_dep.icmp.type == ICMP6_ECHO_REPLY)
+		if (pctx->th_dep.icmp.type == ICMP6_ECHO_REQUEST ||
+		    pctx->th_dep.icmp.type == ICMP6_ECHO_REPLY)
 			goto done;
 
 		type = ICMP6_ECHO_REQUEST;
-		if (ctx->pctx.th_dep.icmp.type)
+		if (pctx->th_dep.icmp.type)
 			goto bad_proto;
 
 		stmt = __payload_gen_icmp_echo_dependency(ctx, expr,
@@ -1284,9 +1296,9 @@ int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
 	case PROTO_ICMP6_MGMQ:
 	case PROTO_ICMP6_PPTR:
 		type = icmp_dep_to_type(tmpl->icmp_dep);
-		if (ctx->pctx.th_dep.icmp.type == type)
+		if (pctx->th_dep.icmp.type == type)
 			goto done;
-		if (ctx->pctx.th_dep.icmp.type)
+		if (pctx->th_dep.icmp.type)
 			goto bad_proto;
 		stmt = __payload_gen_icmp_simple_dependency(ctx, expr,
 							    &icmp6_type_type,
@@ -1297,7 +1309,7 @@ int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		BUG("Unhandled icmp dependency code");
 	}
 
-	ctx->pctx.th_dep.icmp.type = type;
+	pctx->th_dep.icmp.type = type;
 
 	if (stmt_evaluate(ctx, stmt) < 0)
 		return expr_error(ctx->msgs, expr,
@@ -1308,5 +1320,5 @@ done:
 
 bad_proto:
 	return expr_error(ctx->msgs, expr, "incompatible icmp match: rule has %d, need %u",
-			  ctx->pctx.th_dep.icmp.type, type);
+			  pctx->th_dep.icmp.type, type);
 }
-- 
2.30.2

