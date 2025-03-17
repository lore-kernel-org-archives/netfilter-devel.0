Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DBC18EFD1
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Mar 2025 22:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742251437; cv=none; b=NbXHMeR+rUKhmbCkUaZbXGr4kXbZX3FPi4quF8QcS8dRGva3edyM1uDXJXvBYTlMFmcpKeJ17FifKuXIndleUVUXkvzVOMOTjwcg+yNyLC14uiWZuoLINC7o/CyA1dbyd/v6EHEIKX06h4GiXA/21FWV/2Kvx2uh7ldDSL+D/iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742251437; c=relaxed/simple;
	bh=Da5tNo/dByA2jWBsirDWrLvG6xu7qjF/bDlUvcXIlrs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=a14G9r8QmGitMzyrgZ77ictOjPvZWwKKFGiS8g2w4haqFpIfg9HlQn6IqA1Lu4TffZXwJs/Kl/1l5lB3+uArbMnzRMmskLSbYcBpTHQj/sp0UFrhfE50cSjahXegAye0szpny1KHHw9tU3D25hLrFYFbxHSfln+731RP+NU1bHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UoAMDp42; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h68i2t1u; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UoAMDp42";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h68i2t1u"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 37BFD605E8; Mon, 17 Mar 2025 23:43:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742251420;
	bh=98Rlta48PmmT8OkZ5cIe8XHK0KgAftRhj7gvoFLC2MI=;
	h=From:To:Subject:Date:From;
	b=UoAMDp42OeXFGvbjHy0ZcMSDU5zCf+XjLbr8wPkOS9eS4EKY0cgXlaeU0TOtdQWYN
	 aE9CUEZOUcD91EWf7R2agHa2+S2YpXBHslmd2be9lRMOTVudSWqkc0eL8pTv6ehuTq
	 rA7oISoAYxPLLUW/8Ab9G4c6Wc3tX89x/Ziv55q9yK6tvxUhwOb8Sg7n+TtGXDMhMO
	 uKX9D04B20MSsFuAVO9CM249JyZTTYgEwkBEtdO4dJs41VBz94ONMQxUvxE1uSj3Np
	 lrjLoiM3m2EM0RyF+kSecm0+jjog1dCktgozGtoDnWVExa1RSR7CZ8GlzHcp36t9ub
	 BL850MvazsFyA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EBA7B605E6
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Mar 2025 23:43:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742251419;
	bh=98Rlta48PmmT8OkZ5cIe8XHK0KgAftRhj7gvoFLC2MI=;
	h=From:To:Subject:Date:From;
	b=h68i2t1u8kxZyILFdzkNrtIxoYS4ABgf7FEcQh6DKoN0P1jOjfYu+vhv+YftwIfsX
	 3tTjie/RQjNd2QtJcObEMs4TvwIQj41KAGWXKNV4+RCkQOS4FomU6xdPCeJkrcNSAL
	 112RERUVsmB6lSfGWh+FDJ15zN7wft7tU+OxREJnYBQqRCXRa+niKAGDvbnNiBYpGC
	 UdNyuiB16ulqWgpsE5iweDdfm+F0z9O7Pt7wx05UY9D8y1IZtuakwnm6Yy95juEm/0
	 jnQXVIx/z6v2nfFZLPyPGJqEPYKKnwQ+hSKGpe24HTFDtBFSco3yaeVhPz8scHGWkf
	 xDZnkvgMwzEyg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: replace struct stmt_ops by type field in struct stmt
Date: Mon, 17 Mar 2025 23:43:33 +0100
Message-Id: <20250317224333.2037199-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Shrink struct stmt in 8 bytes.

__stmt_ops_by_type() provides an operation for STMT_INVALID since this
is required by -o/--optimize.

There are many checks for stmt->ops->type, which is the most accessed
field, that can be trivially replaced.

BUG() uses statement type enum instead of name.

Similar to:

 68e76238749f ("src: expr: add and use expr_name helper").
 72931553828a ("src: expr: add expression etype")
 2cc91e6198e7 ("src: expr: add and use internal expr_ops helper")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/ct.h              |  4 +++
 include/exthdr.h          |  2 ++
 include/meta.h            |  2 ++
 include/payload.h         |  2 ++
 include/statement.h       |  6 ++--
 src/ct.c                  |  6 ++--
 src/evaluate.c            | 24 ++++++-------
 src/exthdr.c              |  2 +-
 src/json.c                |  9 ++---
 src/meta.c                |  2 +-
 src/netlink_delinearize.c |  6 ++--
 src/netlink_linearize.c   |  8 ++---
 src/optimize.c            | 55 ++++++++++++++---------------
 src/parser_bison.y        |  4 +--
 src/payload.c             |  4 +--
 src/rule.c                |  6 ++--
 src/statement.c           | 73 +++++++++++++++++++++++++++++++++++----
 17 files changed, 144 insertions(+), 71 deletions(-)

diff --git a/include/ct.h b/include/ct.h
index 0a705fd06ee1..bb9193d8fc50 100644
--- a/include/ct.h
+++ b/include/ct.h
@@ -42,4 +42,8 @@ extern const struct datatype ct_status_type;
 extern const struct datatype ct_label_type;
 extern const struct datatype ct_event_type;
 
+extern const struct stmt_ops ct_stmt_ops;
+extern const struct stmt_ops notrack_stmt_ops;
+extern const struct stmt_ops flow_offload_stmt_ops;
+
 #endif /* NFTABLES_CT_H */
diff --git a/include/exthdr.h b/include/exthdr.h
index 084daba5358f..98494e4d5bf7 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -117,4 +117,6 @@ extern const struct exthdr_desc exthdr_dst;
 extern const struct exthdr_desc exthdr_mh;
 extern const struct datatype mh_type_type;
 
+extern const struct stmt_ops exthdr_stmt_ops;
+
 #endif /* NFTABLES_EXTHDR_H */
diff --git a/include/meta.h b/include/meta.h
index af2d772bb6a0..84937ba3a1fe 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -47,4 +47,6 @@ extern const struct datatype day_type;
 
 bool lhs_is_meta_hour(const struct expr *meta);
 
+extern const struct stmt_ops meta_stmt_ops;
+
 #endif /* NFTABLES_META_H */
diff --git a/include/payload.h b/include/payload.h
index 20304252e3f6..e14fc0f24477 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -74,4 +74,6 @@ bool payload_expr_cmp(const struct expr *e1, const struct expr *e2);
 
 const struct proto_desc *find_proto_desc(const struct nftnl_udata *ud);
 
+extern const struct stmt_ops payload_stmt_ops;
+
 #endif /* NFTABLES_PAYLOAD_H */
diff --git a/include/statement.h b/include/statement.h
index 9376911bb377..e8724dde63d0 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -372,16 +372,16 @@ enum stmt_flags {
  * struct stmt
  *
  * @list:	rule list node
- * @ops:	statement ops
  * @location:	location where the statement was defined
  * @flags:	statement flags
+ * @type:	statement type
  * @union:	type specific data
  */
 struct stmt {
 	struct list_head		list;
-	const struct stmt_ops		*ops;
 	struct location			location;
 	enum stmt_flags			flags;
+	enum stmt_types			type:8;
 
 	union {
 		struct expr		*expr;
@@ -420,6 +420,8 @@ int stmt_dependency_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
 extern void stmt_free(struct stmt *stmt);
 extern void stmt_list_free(struct list_head *list);
 extern void stmt_print(const struct stmt *stmt, struct output_ctx *octx);
+const char *stmt_name(const struct stmt *stmt);
+const struct stmt_ops *stmt_ops(const struct stmt *stmt);
 
 const char *get_rate(uint64_t byte_rate, uint64_t *rate);
 const char *get_unit(uint64_t u);
diff --git a/src/ct.c b/src/ct.c
index 6793464859ca..4d71a4b0103b 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -530,7 +530,7 @@ static void ct_stmt_destroy(struct stmt *stmt)
 	expr_free(stmt->ct.expr);
 }
 
-static const struct stmt_ops ct_stmt_ops = {
+const struct stmt_ops ct_stmt_ops = {
 	.type		= STMT_CT,
 	.name		= "ct",
 	.print		= ct_stmt_print,
@@ -557,7 +557,7 @@ static void notrack_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	nft_print(octx, "notrack");
 }
 
-static const struct stmt_ops notrack_stmt_ops = {
+const struct stmt_ops notrack_stmt_ops = {
 	.type		= STMT_NOTRACK,
 	.name		= "notrack",
 	.print		= notrack_stmt_print,
@@ -580,7 +580,7 @@ static void flow_offload_stmt_destroy(struct stmt *stmt)
 	free_const(stmt->flow.table_name);
 }
 
-static const struct stmt_ops flow_offload_stmt_ops = {
+const struct stmt_ops flow_offload_stmt_ops = {
 	.type		= STMT_FLOW_OFFLOAD,
 	.name		= "flow_offload",
 	.print		= flow_offload_stmt_print,
diff --git a/src/evaluate.c b/src/evaluate.c
index 7fc210fd3b12..90a212117a5b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -74,9 +74,9 @@ static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 	return -1;
 }
 
-static const char *stmt_name(const struct stmt *stmt)
+const char *stmt_name(const struct stmt *stmt)
 {
-	switch (stmt->ops->type) {
+	switch (stmt->type) {
 	case STMT_NAT:
 		switch (stmt->nat.type) {
 		case NFT_NAT_SNAT:
@@ -93,7 +93,7 @@ static const char *stmt_name(const struct stmt *stmt)
 		break;
 	}
 
-	return stmt->ops->name;
+	return stmt_ops(stmt)->name;
 }
 
 static int stmt_error_range(struct eval_ctx *ctx, const struct stmt *stmt, const struct expr *e)
@@ -573,7 +573,7 @@ static int expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 	 * require the transformations that are needed for payload matching,
 	 * skip this.
 	 */
-	if (ctx->stmt && ctx->stmt->ops->type == STMT_PAYLOAD)
+	if (ctx->stmt && ctx->stmt->type == STMT_PAYLOAD)
 		return 0;
 
 	switch (expr->etype) {
@@ -790,7 +790,7 @@ static int stmt_dep_conflict(struct eval_ctx *ctx, const struct stmt *nstmt)
 		if (stmt == nstmt)
 			break;
 
-		if (stmt->ops->type != STMT_EXPRESSION ||
+		if (stmt->type != STMT_EXPRESSION ||
 		    stmt->expr->etype != EXPR_RELATIONAL ||
 		    stmt->expr->right->etype != EXPR_VALUE ||
 		    stmt->expr->left->etype != EXPR_PAYLOAD ||
@@ -1841,13 +1841,13 @@ static int __expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr *elem)
 		set_stmt = list_first_entry(&set->stmt_list, struct stmt, list);
 
 		list_for_each_entry(elem_stmt, &elem->stmt_list, list) {
-			if (set_stmt->ops != elem_stmt->ops) {
+			if (set_stmt->type != elem_stmt->type) {
 				return stmt_error(ctx, elem_stmt,
 						  "statement mismatch, element expects %s, "
 						  "but %s has type %s",
-						  elem_stmt->ops->name,
+						  stmt_name(elem_stmt),
 						  set_is_map(set->flags) ? "map" : "set",
-						  set_stmt->ops->name);
+						  stmt_name(set_stmt));
 			}
 			set_stmt = list_next_entry(set_stmt, list);
 		}
@@ -4126,7 +4126,7 @@ static int stmt_evaluate_l3proto(struct eval_ctx *ctx,
 					 "conflicting protocols specified: %s vs. %s. You must specify ip or ip6 family in %s statement",
 					 pctx->protocol[PROTO_BASE_NETWORK_HDR].desc->name,
 					 family2str(family),
-					 stmt->ops->name);
+					 stmt_name(stmt));
 	return 0;
 }
 
@@ -4854,7 +4854,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	if (ctx->nft->debug_mask & NFT_DEBUG_EVALUATION) {
 		struct error_record *erec;
 		erec = erec_create(EREC_INFORMATIONAL, &stmt->location,
-				   "Evaluate %s", stmt->ops->name);
+				   "Evaluate %s", stmt_name(stmt));
 		erec_print(&ctx->nft->output, erec, ctx->nft->debug_mask);
 		stmt_print(stmt, &ctx->nft->output);
 		nft_print(&ctx->nft->output, "\n\n");
@@ -4863,7 +4863,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 
 	ctx->stmt_len = 0;
 
-	switch (stmt->ops->type) {
+	switch (stmt->type) {
 	case STMT_CONNLIMIT:
 	case STMT_COUNTER:
 	case STMT_LAST:
@@ -4913,7 +4913,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	case STMT_OPTSTRIP:
 		return stmt_evaluate_optstrip(ctx, stmt);
 	default:
-		BUG("unknown statement type %s\n", stmt->ops->name);
+		BUG("unknown statement type %d\n", stmt->type);
 	}
 }
 
diff --git a/src/exthdr.c b/src/exthdr.c
index 1438d7e2d2dc..c7d876a45aab 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -269,7 +269,7 @@ static void exthdr_stmt_destroy(struct stmt *stmt)
 	expr_free(stmt->exthdr.val);
 }
 
-static const struct stmt_ops exthdr_stmt_ops = {
+const struct stmt_ops exthdr_stmt_ops = {
 	.type		= STMT_EXTHDR,
 	.name		= "exthdr",
 	.print		= exthdr_stmt_print,
diff --git a/src/json.c b/src/json.c
index 64a6888f9e0a..96413d70895a 100644
--- a/src/json.c
+++ b/src/json.c
@@ -109,19 +109,20 @@ static json_t *set_key_dtype_json(const struct set *set,
 
 static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
 {
+	const struct stmt_ops *ops = stmt_ops(stmt);
 	char buf[1024];
 	FILE *fp;
 
-	if (stmt->ops->json)
-		return stmt->ops->json(stmt, octx);
+	if (ops->json)
+		return ops->json(stmt, octx);
 
 	fprintf(stderr, "warning: stmt ops %s have no json callback\n",
-		stmt->ops->name);
+		ops->name);
 
 	fp = octx->output_fp;
 	octx->output_fp = fmemopen(buf, 1024, "w");
 
-	stmt->ops->print(stmt, octx);
+	ops->print(stmt, octx);
 
 	fclose(octx->output_fp);
 	octx->output_fp = fp;
diff --git a/src/meta.c b/src/meta.c
index a17bacf07d0e..1010209d3152 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -952,7 +952,7 @@ static void meta_stmt_destroy(struct stmt *stmt)
 	expr_free(stmt->meta.expr);
 }
 
-static const struct stmt_ops meta_stmt_ops = {
+const struct stmt_ops meta_stmt_ops = {
 	.type		= STMT_META,
 	.name		= "meta",
 	.print		= meta_stmt_print,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ae14065c00d6..ae1ee53f6e7c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -3121,7 +3121,7 @@ static void stmt_expr_postprocess(struct rule_pp_ctx *ctx)
 	expr_postprocess(ctx, &ctx->stmt->expr);
 
 	if (dl->pdctx.prev && ctx->stmt &&
-	    ctx->stmt->ops->type == dl->pdctx.prev->ops->type &&
+	    ctx->stmt->type == dl->pdctx.prev->type &&
 	    expr_may_merge_range(ctx->stmt->expr, dl->pdctx.prev->expr, &op))
 		expr_postprocess_range(ctx, op);
 }
@@ -3404,7 +3404,7 @@ static struct dl_proto_ctx *rule_update_dl_proto_ctx(struct rule_pp_ctx *rctx)
 	const struct stmt *stmt = rctx->stmt;
 	bool inner = false;
 
-	switch (stmt->ops->type) {
+	switch (stmt->type) {
 	case STMT_EXPRESSION:
 		if (has_inner_desc(stmt->expr->left))
 			inner = true;
@@ -3438,7 +3438,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 	proto_ctx_init(&rctx._dl[1].pctx, NFPROTO_BRIDGE, ctx->debug_mask, true);
 
 	list_for_each_entry_safe(stmt, next, &rule->stmts, list) {
-		enum stmt_types type = stmt->ops->type;
+		enum stmt_types type = stmt->type;
 
 		rctx.stmt = stmt;
 		dl = rule_update_dl_proto_ctx(&rctx);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 598ddfab5827..5f73183bf19a 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1046,7 +1046,7 @@ static struct nftnl_expr *netlink_gen_last_stmt(const struct stmt *stmt)
 
 struct nftnl_expr *netlink_gen_stmt_stateful(const struct stmt *stmt)
 {
-	switch (stmt->ops->type) {
+	switch (stmt->type) {
 	case STMT_CONNLIMIT:
 		return netlink_gen_connlimit_stmt(stmt);
 	case STMT_COUNTER:
@@ -1058,7 +1058,7 @@ struct nftnl_expr *netlink_gen_stmt_stateful(const struct stmt *stmt)
 	case STMT_LAST:
 		return netlink_gen_last_stmt(stmt);
 	default:
-		BUG("unknown stateful statement type %s\n", stmt->ops->name);
+		BUG("unknown stateful statement type %d\n", stmt->type);
 	}
 }
 
@@ -1694,7 +1694,7 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 {
 	struct nftnl_expr *nle;
 
-	switch (stmt->ops->type) {
+	switch (stmt->type) {
 	case STMT_EXPRESSION:
 		return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 	case STMT_VERDICT:
@@ -1748,7 +1748,7 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 	case STMT_OPTSTRIP:
 		return netlink_gen_optstrip_stmt(ctx, stmt);
 	default:
-		BUG("unknown statement type %s\n", stmt->ops->name);
+		BUG("unknown statement type %d\n", stmt->type);
 	}
 }
 
diff --git a/src/optimize.c b/src/optimize.c
index 230fe4a23de3..05d8084b2a47 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -164,10 +164,10 @@ static bool __stmt_type_eq(const struct stmt *stmt_a, const struct stmt *stmt_b,
 {
 	struct expr *expr_a, *expr_b;
 
-	if (stmt_a->ops->type != stmt_b->ops->type)
+	if (stmt_a->type != stmt_b->type)
 		return false;
 
-	switch (stmt_a->ops->type) {
+	switch (stmt_a->type) {
 	case STMT_EXPRESSION:
 		expr_a = stmt_a->expr;
 		expr_b = stmt_b->expr;
@@ -324,7 +324,7 @@ static bool stmt_verdict_eq(const struct stmt *stmt_a, const struct stmt *stmt_b
 {
 	struct expr *expr_a, *expr_b;
 
-	assert (stmt_a->ops->type == STMT_VERDICT);
+	assert (stmt_a->type == STMT_VERDICT);
 
 	expr_a = stmt_a->expr;
 	expr_b = stmt_b->expr;
@@ -345,14 +345,14 @@ static bool stmt_type_find(struct optimize_ctx *ctx, const struct stmt *stmt)
 	uint32_t i;
 
 	for (i = 0; i < ctx->num_stmts; i++) {
-		if (ctx->stmt[i]->ops->type == STMT_INVALID)
+		if (ctx->stmt[i]->type == STMT_INVALID)
 			unsupported_exists = true;
 
 		if (__stmt_type_eq(stmt, ctx->stmt[i], false))
 			return true;
 	}
 
-	switch (stmt->ops->type) {
+	switch (stmt->type) {
 	case STMT_EXPRESSION:
 	case STMT_VERDICT:
 	case STMT_COUNTER:
@@ -371,13 +371,9 @@ static bool stmt_type_find(struct optimize_ctx *ctx, const struct stmt *stmt)
 	return false;
 }
 
-static struct stmt_ops unsupported_stmt_ops = {
-	.type	= STMT_INVALID,
-	.name	= "unsupported",
-};
-
 static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 {
+	const struct stmt_ops *ops;
 	struct stmt *stmt, *clone;
 
 	list_for_each_entry(stmt, &rule->stmts, list) {
@@ -387,16 +383,17 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 		/* No refcounter available in statement objects, clone it to
 		 * to store in the array of selectors.
 		 */
-		clone = stmt_alloc(&internal_location, stmt->ops);
-		switch (stmt->ops->type) {
+		ops = stmt_ops(stmt);
+		clone = stmt_alloc(&internal_location, ops);
+		switch (stmt->type) {
 		case STMT_EXPRESSION:
 			if (stmt->expr->op != OP_IMPLICIT &&
 			    stmt->expr->op != OP_EQ) {
-				clone->ops = &unsupported_stmt_ops;
+				clone->type = STMT_INVALID;
 				break;
 			}
 			if (stmt->expr->left->etype == EXPR_CONCAT) {
-				clone->ops = &unsupported_stmt_ops;
+				clone->type = STMT_INVALID;
 				break;
 			}
 			/* fall-through */
@@ -418,7 +415,7 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 			    (stmt->nat.proto &&
 			     (stmt->nat.proto->etype == EXPR_MAP ||
 			      stmt->nat.proto->etype == EXPR_VARIABLE))) {
-				clone->ops = &unsupported_stmt_ops;
+				clone->type = STMT_INVALID;
 				break;
 			}
 			clone->nat.type = stmt->nat.type;
@@ -438,7 +435,7 @@ static int rule_collect_stmts(struct optimize_ctx *ctx, struct rule *rule)
 			clone->reject.family = stmt->reject.family;
 			break;
 		default:
-			clone->ops = &unsupported_stmt_ops;
+			clone->type = STMT_INVALID;
 			break;
 		}
 
@@ -455,7 +452,7 @@ static int unsupported_in_stmt_matrix(const struct optimize_ctx *ctx)
 	uint32_t i;
 
 	for (i = 0; i < ctx->num_stmts; i++) {
-		if (ctx->stmt[i]->ops->type == STMT_INVALID)
+		if (ctx->stmt[i]->type == STMT_INVALID)
 			return i;
 	}
 	/* this should not happen. */
@@ -475,7 +472,7 @@ static int cmd_stmt_find_in_stmt_matrix(struct optimize_ctx *ctx, struct stmt *s
 }
 
 static struct stmt unsupported_stmt = {
-	.ops	= &unsupported_stmt_ops,
+	.type	= STMT_INVALID,
 };
 
 static void rule_build_stmt_matrix_stmts(struct optimize_ctx *ctx,
@@ -502,7 +499,7 @@ static int stmt_verdict_find(const struct optimize_ctx *ctx)
 	uint32_t i;
 
 	for (i = 0; i < ctx->num_stmts; i++) {
-		if (ctx->stmt[i]->ops->type != STMT_VERDICT)
+		if (ctx->stmt[i]->type != STMT_VERDICT)
 			continue;
 
 		return i;
@@ -569,7 +566,7 @@ static void merge_verdict_stmts(const struct optimize_ctx *ctx,
 
 	for (i = from + 1; i <= to; i++) {
 		stmt_b = ctx->stmt_matrix[i][merge->stmt[0]];
-		switch (stmt_b->ops->type) {
+		switch (stmt_b->type) {
 		case STMT_VERDICT:
 			switch (stmt_b->expr->etype) {
 			case EXPR_MAP:
@@ -591,7 +588,7 @@ static void merge_stmts(const struct optimize_ctx *ctx,
 {
 	struct stmt *stmt_a = ctx->stmt_matrix[from][merge->stmt[0]];
 
-	switch (stmt_a->ops->type) {
+	switch (stmt_a->type) {
 	case STMT_EXPRESSION:
 		merge_expr_stmts(ctx, from, to, merge, stmt_a);
 		break;
@@ -762,7 +759,7 @@ static void remove_counter(const struct optimize_ctx *ctx, uint32_t from)
 		if (!stmt)
 			continue;
 
-		if (stmt->ops->type == STMT_COUNTER) {
+		if (stmt->type == STMT_COUNTER) {
 			list_del(&stmt->list);
 			stmt_free(stmt);
 		}
@@ -780,7 +777,7 @@ static struct stmt *zap_counter(const struct optimize_ctx *ctx, uint32_t from)
 		if (!stmt)
 			continue;
 
-		if (stmt->ops->type == STMT_COUNTER) {
+		if (stmt->type == STMT_COUNTER) {
 			list_del(&stmt->list);
 			return stmt;
 		}
@@ -937,7 +934,7 @@ static int stmt_nat_type(const struct optimize_ctx *ctx, int from,
 		if (!ctx->stmt_matrix[from][j])
 			continue;
 
-		if (ctx->stmt_matrix[from][j]->ops->type == STMT_NAT) {
+		if (ctx->stmt_matrix[from][j]->type == STMT_NAT) {
 			*nat_type = ctx->stmt_matrix[from][j]->nat.type;
 			return 0;
 		}
@@ -955,7 +952,7 @@ static int stmt_nat_find(const struct optimize_ctx *ctx, int from)
 		return -1;
 
 	for (i = 0; i < ctx->num_stmts; i++) {
-		if (ctx->stmt[i]->ops->type != STMT_NAT ||
+		if (ctx->stmt[i]->type != STMT_NAT ||
 		    ctx->stmt[i]->nat.type != nat_type)
 			continue;
 
@@ -969,7 +966,7 @@ static struct expr *stmt_nat_expr(struct stmt *nat_stmt)
 {
 	struct expr *nat_expr;
 
-	assert(nat_stmt->ops->type == STMT_NAT);
+	assert(nat_stmt->type == STMT_NAT);
 
 	if (nat_stmt->nat.proto) {
 		if (nat_stmt->nat.addr) {
@@ -1153,7 +1150,7 @@ static uint32_t merge_stmt_type(const struct optimize_ctx *ctx,
 			stmt = ctx->stmt_matrix[i][j];
 			if (!stmt)
 				continue;
-			if (stmt->ops->type == STMT_NAT) {
+			if (stmt->type == STMT_NAT) {
 				if ((stmt->nat.type == NFT_NAT_REDIR &&
 				     !stmt->nat.proto) ||
 				    stmt->nat.type == NFT_NAT_MASQ)
@@ -1250,7 +1247,7 @@ static bool stmt_is_mergeable(const struct stmt *stmt)
 	if (!stmt)
 		return false;
 
-	switch (stmt->ops->type) {
+	switch (stmt->type) {
 	case STMT_VERDICT:
 		if (stmt->expr->etype == EXPR_MAP)
 			return true;
@@ -1346,7 +1343,7 @@ static int chain_optimize(struct nft_ctx *nft, struct list_head *rules)
 		for (m = 0; m < ctx->num_stmts; m++) {
 			if (!ctx->stmt_matrix[i][m])
 				continue;
-			switch (ctx->stmt_matrix[i][m]->ops->type) {
+			switch (ctx->stmt_matrix[i][m]->type) {
 			case STMT_EXPRESSION:
 				merge[k].stmt[merge[k].num_stmts++] = m;
 				break;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e494079d6373..4d4d39342bf7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3306,12 +3306,12 @@ counter_args		:	counter_arg
 
 counter_arg		:	PACKETS			NUM
 			{
-				assert($<stmt>0->ops->type == STMT_COUNTER);
+				assert($<stmt>0->type == STMT_COUNTER);
 				$<stmt>0->counter.packets = $2;
 			}
 			|	BYTES			NUM
 			{
-				assert($<stmt>0->ops->type == STMT_COUNTER);
+				assert($<stmt>0->type == STMT_COUNTER);
 				$<stmt>0->counter.bytes	 = $2;
 			}
 			;
diff --git a/src/payload.c b/src/payload.c
index 50b5acc9a927..a38f5bf730d1 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -378,7 +378,7 @@ static void payload_stmt_destroy(struct stmt *stmt)
 	expr_free(stmt->payload.val);
 }
 
-static const struct stmt_ops payload_stmt_ops = {
+const struct stmt_ops payload_stmt_ops = {
 	.type		= STMT_PAYLOAD,
 	.name		= "payload",
 	.print		= payload_stmt_print,
@@ -1198,7 +1198,7 @@ bool stmt_payload_expr_trim(struct stmt *stmt, const struct proto_ctx *pctx)
 	mpz_t bitmask, tmp, tmp2;
 	unsigned long n;
 
-	assert(stmt->ops->type == STMT_PAYLOAD);
+	assert(stmt->type == STMT_PAYLOAD);
 	assert(expr->etype == EXPR_BINOP);
 
 	payload = expr->left;
diff --git a/src/rule.c b/src/rule.c
index 9c317934139c..3edfa4715853 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -494,10 +494,12 @@ void rule_free(struct rule *rule)
 
 void rule_print(const struct rule *rule, struct output_ctx *octx)
 {
+	const struct stmt_ops *ops;
 	const struct stmt *stmt;
 
 	list_for_each_entry(stmt, &rule->stmts, list) {
-		stmt->ops->print(stmt, octx);
+		ops = stmt_ops(stmt);
+		ops->print(stmt, octx);
 		if (!list_is_last(&stmt->list, &rule->stmts))
 			nft_print(octx, " ");
 	}
@@ -2741,7 +2743,7 @@ static void stmt_reduce(const struct rule *rule)
 		}
 
 		/* Must not merge across other statements */
-		if (stmt->ops->type != STMT_EXPRESSION) {
+		if (stmt->type != STMT_EXPRESSION) {
 			if (idx >= 2)
 				payload_do_merge(sa, idx);
 			idx = 0;
diff --git a/src/statement.c b/src/statement.c
index 551cd13fa04e..695b57a6cc65 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -33,24 +33,27 @@
 #include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/nf_synproxy.h>
 
-struct stmt *stmt_alloc(const struct location *loc,
-			const struct stmt_ops *ops)
+struct stmt *stmt_alloc(const struct location *loc, const struct stmt_ops *ops)
 {
 	struct stmt *stmt;
 
 	stmt = xzalloc(sizeof(*stmt));
 	init_list_head(&stmt->list);
 	stmt->location = *loc;
-	stmt->ops      = ops;
+	stmt->type = ops->type;
 	return stmt;
 }
 
 void stmt_free(struct stmt *stmt)
 {
+	const struct stmt_ops *ops;
+
 	if (stmt == NULL)
 		return;
-	if (stmt->ops->destroy)
-		stmt->ops->destroy(stmt);
+
+	ops = stmt_ops(stmt);
+	if (ops->destroy)
+		ops->destroy(stmt);
 	free(stmt);
 }
 
@@ -66,7 +69,9 @@ void stmt_list_free(struct list_head *list)
 
 void stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
-	stmt->ops->print(stmt, octx);
+	const struct stmt_ops *ops = stmt_ops(stmt);
+
+	ops->print(stmt, octx);
 }
 
 static void expr_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
@@ -1079,3 +1084,59 @@ struct stmt *synproxy_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &synproxy_stmt_ops);
 }
+
+/* For src/optimize.c */
+static struct stmt_ops invalid_stmt_ops = {
+	.type	= STMT_INVALID,
+	.name	= "unsupported",
+};
+
+static const struct stmt_ops *__stmt_ops_by_type(enum stmt_types type)
+{
+	switch (type) {
+	case STMT_INVALID: return &invalid_stmt_ops;
+	case STMT_EXPRESSION: return &expr_stmt_ops;
+	case STMT_VERDICT: return &verdict_stmt_ops;
+	case STMT_METER: return &meter_stmt_ops;
+	case STMT_COUNTER: return &counter_stmt_ops;
+	case STMT_PAYLOAD: return &payload_stmt_ops;
+	case STMT_META: return &meta_stmt_ops;
+	case STMT_LIMIT: return &limit_stmt_ops;
+	case STMT_LOG: return &log_stmt_ops;
+	case STMT_REJECT: return &reject_stmt_ops;
+	case STMT_NAT: return &nat_stmt_ops;
+	case STMT_TPROXY: return &tproxy_stmt_ops;
+	case STMT_QUEUE: return &queue_stmt_ops;
+	case STMT_CT: return &ct_stmt_ops;
+	case STMT_SET: return &set_stmt_ops;
+	case STMT_DUP: return &dup_stmt_ops;
+	case STMT_FWD: return &fwd_stmt_ops;
+	case STMT_XT: return &xt_stmt_ops;
+	case STMT_QUOTA: return &quota_stmt_ops;
+	case STMT_NOTRACK: return &notrack_stmt_ops;
+	case STMT_OBJREF: return &objref_stmt_ops;
+	case STMT_EXTHDR: return &exthdr_stmt_ops;
+	case STMT_FLOW_OFFLOAD: return &flow_offload_stmt_ops;
+	case STMT_CONNLIMIT: return &connlimit_stmt_ops;
+	case STMT_MAP: return &map_stmt_ops;
+	case STMT_SYNPROXY: return &synproxy_stmt_ops;
+	case STMT_CHAIN: return &chain_stmt_ops;
+	case STMT_OPTSTRIP: return &optstrip_stmt_ops;
+	case STMT_LAST: return &last_stmt_ops;
+	default:
+		break;
+	}
+
+	return NULL;
+}
+
+const struct stmt_ops *stmt_ops(const struct stmt *stmt)
+{
+	const struct stmt_ops *ops;
+
+	ops = __stmt_ops_by_type(stmt->type);
+	if (!ops)
+		BUG("Unknown statement type %d\n", stmt->type);
+
+	return ops;
+}
-- 
2.30.2

