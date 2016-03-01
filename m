From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 04/10] payload: move payload_gen_dependency generic part to helper
Date: Tue,  1 Mar 2016 16:37:44 +0100
Message-ID: <1456846670-28179-5-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49301 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbcCAPhp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:37:45 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We should treat exthdr just as if user asked for e.g. ip6 saddr
and inject the needed dependency statement.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 66 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 6a977e8..8f67b6e 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -162,6 +162,43 @@ struct stmt *payload_stmt_alloc(const struct location *loc,
 	return stmt;
 }
 
+static int payload_add_dependency(struct eval_ctx *ctx,
+				  const struct proto_desc *desc,
+				  const struct proto_desc *upper,
+				  const struct expr *expr,
+				  struct stmt **res)
+{
+	const struct proto_hdr_template *tmpl;
+	struct expr *dep, *left, *right;
+	struct stmt *stmt;
+	int protocol = proto_find_num(desc, upper);
+
+	if (protocol < 0)
+		return expr_error(ctx->msgs, expr,
+				  "conflicting protocols specified: %s vs. %s",
+				  desc->name, upper->name);
+
+	tmpl = &desc->templates[desc->protocol_key];
+	if (tmpl->meta_key)
+		left = meta_expr_alloc(&expr->location, tmpl->meta_key);
+	else
+		left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
+
+	right = constant_expr_alloc(&expr->location, tmpl->dtype,
+				    tmpl->dtype->byteorder, tmpl->len,
+				    constant_data_ptr(protocol, tmpl->len));
+
+	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
+	stmt = expr_stmt_alloc(&dep->location, dep);
+	if (stmt_evaluate(ctx, stmt) < 0) {
+		return expr_error(ctx->msgs, expr,
+					  "dependency statement is invalid");
+	}
+	left->ops->pctx_update(&ctx->pctx, dep);
+	*res = stmt;
+	return 0;
+}
+
 /**
  * payload_gen_dependency - generate match expression on payload dependency
  *
@@ -190,10 +227,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 {
 	const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
 	const struct proto_desc *desc;
-	const struct proto_hdr_template *tmpl;
-	struct expr *dep, *left, *right;
 	struct stmt *stmt;
-	int protocol;
 	uint16_t type;
 
 	if (expr->payload.base < h->base) {
@@ -265,31 +299,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  "no %s protocol specified",
 				  proto_base_names[expr->payload.base - 1]);
 
-	protocol = proto_find_num(desc, expr->payload.desc);
-	if (protocol < 0)
-		return expr_error(ctx->msgs, expr,
-				  "conflicting protocols specified: %s vs. %s",
-				  desc->name, expr->payload.desc->name);
-
-	tmpl = &desc->templates[desc->protocol_key];
-	if (tmpl->meta_key)
-		left = meta_expr_alloc(&expr->location, tmpl->meta_key);
-	else
-		left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
-
-	right = constant_expr_alloc(&expr->location, tmpl->dtype,
-				    tmpl->dtype->byteorder, tmpl->len,
-				    constant_data_ptr(protocol, tmpl->len));
-
-	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-	stmt = expr_stmt_alloc(&dep->location, dep);
-	if (stmt_evaluate(ctx, stmt) < 0) {
-		return expr_error(ctx->msgs, expr,
-					  "dependency statement is invalid");
-	}
-	left->ops->pctx_update(&ctx->pctx, dep);
-	*res = stmt;
-	return 0;
+	return payload_add_dependency(ctx, desc, expr->payload.desc, expr, res);
 }
 
 /**
-- 
2.4.10

