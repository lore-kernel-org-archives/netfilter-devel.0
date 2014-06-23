From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH] proto: add icmp and icmpv6 in inet protocols
Date: Mon, 23 Jun 2014 13:18:17 +0200
Message-ID: <1403522297-16661-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50056 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaFWLTA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:19:00 -0400
Received: by mail-wi0-f178.google.com with SMTP id n15so4029676wiw.11
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 04:18:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we try to add a rule with icmp or icmpv6 in a inet table like this:

nft add rule inet filter input icmp type echo-request counter
or
nft add rule inet filter input icmpv6 type echo-request counter

we have this error:

<cmdline>:1:28-38: Error: conflicting protocols specified: inet-service vs. icmpv6
add rule inet filter input icmpv6 type echo-request counter accept
                           ^^^^^^^^^^^

This patch solve it adding icmp and icmpv6 in the inet protocols that we can use.
Also, I have added a statement meta for restricting that the rules for icmp is only
for ipv4 traffic and the rules for icmpv6 is for ipv6 traffic.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
I have tested this patch with the rules:

nft add rule inet filter input tcp dport 22 counter
nft add rule inet filter input icmp type echo-request counter
nft add rule inet filter input icmpv6 type echo-request counter

I have created traffic and I have seen that it works for me.

 include/payload.h         |    4 +--
 include/statement.h       |    1 +
 src/evaluate.c            |   11 ++----
 src/netlink_delinearize.c |   43 +++++++++++++++--------
 src/payload.c             |   84 ++++++++++++++++++++++++++++++++++-----------
 src/proto.c               |    2 ++
 6 files changed, 100 insertions(+), 45 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index d47e564..db2184e 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -11,8 +11,8 @@ extern void payload_init_raw(struct expr *expr, enum proto_bases base,
 			     unsigned int offset, unsigned int len);
 
 struct eval_ctx;
-extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
-				  struct expr **res);
+extern int payload_gen_dependency(struct eval_ctx *ctx,
+				  const struct expr *expr);
 
 extern bool payload_is_adjacent(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
diff --git a/include/statement.h b/include/statement.h
index 28f9a35..b0ce377 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -162,4 +162,5 @@ extern void stmt_free(struct stmt *stmt);
 extern void stmt_list_free(struct list_head *list);
 extern void stmt_print(const struct stmt *stmt);
 
+int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
 #endif /* NFTABLES_STATEMENT_H */
diff --git a/src/evaluate.c b/src/evaluate.c
index 216194f..9b307b5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -27,7 +27,6 @@
 #include <utils.h>
 
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
-static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt);
 
 static const char *byteorder_names[] = {
 	[BYTEORDER_INVALID]		= "invalid",
@@ -271,16 +270,10 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct expr *payload = *expr;
 	enum proto_bases base = payload->payload.base;
-	struct stmt *nstmt;
-	struct expr *nexpr;
 
 	if (ctx->pctx.protocol[base].desc == NULL) {
-		if (payload_gen_dependency(ctx, payload, &nexpr) < 0)
+		if (payload_gen_dependency(ctx, payload) < 0)
 			return -1;
-		nstmt = expr_stmt_alloc(&nexpr->location, nexpr);
-		if (stmt_evaluate(ctx, nstmt) < 0)
-			return -1;
-		list_add_tail(&nstmt->list, &ctx->stmt->list);
 	} else if (ctx->pctx.protocol[base].desc != payload->payload.desc)
 		return expr_error(ctx->msgs, payload,
 				  "conflicting protocols specified: %s vs. %s",
@@ -1196,7 +1189,7 @@ static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
-static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
+int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
 #ifdef DEBUG
 	if (debug_level & DEBUG_EVALUATION) {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8d30b2d..81cd3f3 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -14,6 +14,8 @@
 #include <string.h>
 #include <limits.h>
 #include <linux/netfilter/nf_tables.h>
+#include <netinet/in.h>
+#include <linux/netfilter.h>
 #include <netlink.h>
 #include <rule.h>
 #include <statement.h>
@@ -603,8 +605,9 @@ static int netlink_parse_expr(struct nft_rule_expr *nle, void *arg)
 
 struct rule_pp_ctx {
 	struct proto_ctx	pctx;
-	enum proto_bases	pbase;
-	struct stmt		*pdep;
+	struct {
+		struct stmt		*pdep;
+	} protocol[PROTO_BASE_MAX + 1];
 };
 
 /*
@@ -612,13 +615,27 @@ struct rule_pp_ctx {
  */
 static void payload_dependency_kill(struct rule_pp_ctx *ctx, struct expr *expr)
 {
-	if (ctx->pbase != PROTO_BASE_INVALID &&
-	    ctx->pbase == expr->payload.base - 1 &&
-	    ctx->pdep != NULL) {
-		list_del(&ctx->pdep->list);
-		stmt_free(ctx->pdep);
-		ctx->pbase = PROTO_BASE_INVALID;
-		ctx->pdep = NULL;
+	int base = expr->payload.base - 1;
+
+	if (base < 0)
+		return;
+
+	if (ctx->protocol[base].pdep != NULL) {
+		list_del(&ctx->protocol[base].pdep->list);
+		stmt_free(ctx->protocol[base].pdep);
+		ctx->protocol[base].pdep = NULL;
+	}
+
+	if (ctx->pctx.family == NFPROTO_INET) {
+		base--;
+		if (base < 0)
+			return;
+
+		if (ctx->protocol[base].pdep != NULL) {
+			list_del(&ctx->protocol[base].pdep->list);
+			stmt_free(ctx->protocol[base].pdep);
+			ctx->protocol[base].pdep = NULL;
+		}
 	}
 }
 
@@ -626,8 +643,7 @@ static void payload_dependency_store(struct rule_pp_ctx *ctx,
 				     struct stmt *stmt,
 				     enum proto_bases base)
 {
-	ctx->pbase = base;
-	ctx->pdep  = stmt;
+	ctx->protocol[base].pdep = stmt;
 }
 
 static void payload_match_postprocess(struct rule_pp_ctx *ctx,
@@ -660,7 +676,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 			 * kill it later on if made redundant by a higher layer
 			 * payload expression.
 			 */
-			if (ctx->pbase == PROTO_BASE_INVALID &&
+			if (ctx->protocol[left->payload.base-1].pdep == NULL &&
 			    left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(ctx, nstmt,
 							 left->payload.base);
@@ -689,8 +705,7 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 	case OP_EQ:
 		expr->left->ops->pctx_update(&ctx->pctx, expr);
 
-		if (ctx->pbase == PROTO_BASE_INVALID &&
-		    left->flags & EXPR_F_PROTOCOL)
+		if (left->flags & EXPR_F_PROTOCOL)
 			payload_dependency_store(ctx, stmt, left->meta.base);
 		break;
 	default:
diff --git a/src/payload.c b/src/payload.c
index a1785a5..757e6c2 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -24,6 +24,7 @@
 #include <payload.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <statement.h>
 
 static void payload_expr_print(const struct expr *expr)
 {
@@ -128,6 +129,45 @@ void payload_init_raw(struct expr *expr, enum proto_bases base,
 	expr->len		= len;
 }
 
+static struct expr *payload_gen_dependency_node(const struct proto_desc *desc,
+						const struct expr *expr,
+						int protocol,
+						struct eval_ctx *ctx)
+{
+	struct expr *dep, *left, *right;
+	const struct proto_hdr_template *tmpl;
+
+	tmpl = &desc->templates[desc->protocol_key];
+	if (tmpl->meta_key)
+		left = meta_expr_alloc(&expr->location, tmpl->meta_key);
+	else
+		left = payload_expr_alloc(&expr->location, desc,
+					  desc->protocol_key);
+
+	right = constant_expr_alloc(&expr->location, tmpl->dtype,
+				    BYTEORDER_HOST_ENDIAN,
+				    tmpl->len,
+				    constant_data_ptr(protocol, tmpl->len));
+
+	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
+	left->ops->pctx_update(&ctx->pctx, dep);
+
+	return dep;
+}
+
+static int expr_stmt_create_evaluate(const struct expr *expr,
+				     struct expr *dep,
+				     struct eval_ctx *ctx)
+{
+	struct stmt *nstmt;
+
+	nstmt = expr_stmt_alloc(&expr->location, dep);
+	if (stmt_evaluate(ctx, nstmt) < 0)
+		return -1;
+
+	list_add_tail(&nstmt->list, &ctx->stmt->list);
+	return 0;
+}
 /**
  * payload_gen_dependency - generate match expression on payload dependency
  *
@@ -151,14 +191,12 @@ void payload_init_raw(struct expr *expr, enum proto_bases base,
  *   it is not explicitly verified. The NFT_META_IIFTYPE match will only match
  *   in the input path though.
  */
-int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
-			   struct expr **res)
+int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr)
 {
 	const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
 	const struct proto_desc *desc;
-	const struct proto_hdr_template *tmpl;
 	struct expr *dep, *left, *right;
-	int protocol;
+	int protocol, ret = 0;
 	uint16_t type;
 
 	if (expr->payload.base < h->base) {
@@ -178,8 +216,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 					    2 * BITS_PER_BYTE, &type);
 
 		dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-		*res = dep;
-		return 0;
+		return expr_stmt_create_evaluate(expr, dep, ctx);
 	}
 
 	desc = ctx->pctx.protocol[expr->payload.base - 1].desc;
@@ -201,21 +238,28 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  "conflicting protocols specified: %s vs. %s",
 				  desc->name, expr->payload.desc->name);
 
-	tmpl = &desc->templates[desc->protocol_key];
-	if (tmpl->meta_key)
-		left = meta_expr_alloc(&expr->location, tmpl->meta_key);
-	else
-		left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
-
-	right = constant_expr_alloc(&expr->location, tmpl->dtype,
-				    BYTEORDER_HOST_ENDIAN,
-				    tmpl->len,
-				    constant_data_ptr(protocol, tmpl->len));
+	if (ctx->pctx.family == NFPROTO_INET) {
+		switch (protocol) {
+		case IPPROTO_ICMP:
+			dep = payload_gen_dependency_node(&proto_inet, expr,
+							  NFPROTO_IPV4, ctx);
+			ret = expr_stmt_create_evaluate(expr, dep, ctx);
+			break;
+		case IPPROTO_ICMPV6:
+			dep = payload_gen_dependency_node(&proto_inet, expr,
+							  NFPROTO_IPV6, ctx);
+			ret = expr_stmt_create_evaluate(expr, dep, ctx);
+			break;
+		default:
+			break;
+		}
+	}
+	if (ret < 0)
+		return -1;
 
-	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-	left->ops->pctx_update(&ctx->pctx, dep);
-	*res = dep;
-	return 0;
+	dep = payload_gen_dependency_node(desc, expr, protocol, ctx);
+	ret = expr_stmt_create_evaluate(expr, dep, ctx);
+	return ret;
 }
 
 /**
diff --git a/src/proto.c b/src/proto.c
index 0a37a65..a3bf387 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -644,6 +644,8 @@ const struct proto_desc proto_inet_service = {
 		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
+		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
+		PROTO_LINK(IPPROTO_ICMP,	&proto_icmp),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
-- 
1.7.10.4

