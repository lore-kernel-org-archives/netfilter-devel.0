From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 05/10] exthdr: generate dependencies for inet/bridge/netdev family
Date: Tue,  1 Mar 2016 16:37:45 +0100
Message-ID: <1456846670-28179-6-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49305 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbcCAPht (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:37:49 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Should treat this as if user would have asked to match ipv6 header field.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h |  2 ++
 src/evaluate.c    | 17 ++++++++++++++---
 src/payload.c     | 15 +++++++++++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 9192d6e..a19e690 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -14,6 +14,8 @@ struct eval_ctx;
 struct stmt;
 extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  struct stmt **res);
+extern int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
+				  struct stmt **res);
 
 extern bool payload_is_adjacent(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
diff --git a/src/evaluate.c b/src/evaluate.c
index 47a1f8c..28e17cb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -344,18 +344,29 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
 }
 
 /*
- * Exthdr expression: check whether dependencies are fulfilled.
+ * Exthdr expression: check whether dependencies are fulfilled, otherwise
+ * generate the necessary relational expression and prepend it to the current
+ * statement.
  */
 static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **expr)
 {
 	const struct proto_desc *base;
+	struct stmt *nstmt;
 
 	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 	if (base == &proto_ip6)
 		return expr_evaluate_primary(ctx, expr);
 
-	return expr_error(ctx->msgs, *expr,
-			  "exthdr can only be used with ipv6");
+	if (base)
+		return expr_error(ctx->msgs, *expr,
+				  "cannot use exthdr with %s", base->name);
+
+	if (exthdr_gen_dependency(ctx, *expr, &nstmt) < 0)
+		return -1;
+
+	list_add(&nstmt->list, &ctx->rule->stmts);
+
+	return expr_evaluate_primary(ctx, expr);
 }
 
 /* dependency supersede.
diff --git a/src/payload.c b/src/payload.c
index 8f67b6e..7e38061 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -302,6 +302,21 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 	return payload_add_dependency(ctx, desc, expr->payload.desc, expr, res);
 }
 
+int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
+			  struct stmt **res)
+{
+	const struct proto_desc *desc;
+
+	desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+	if (desc == NULL)
+		return expr_error(ctx->msgs, expr,
+				  "Cannot generate dependency: "
+				  "no %s protocol specified",
+				  proto_base_names[PROTO_BASE_LL_HDR]);
+
+	return payload_add_dependency(ctx, desc, &proto_ip6, expr, res);
+}
+
 /**
  * payload_expr_complete - fill in type information of a raw payload expr
  *
-- 
2.4.10

