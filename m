From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/8] src: add and use payload_dependency_update helper
Date: Fri, 27 Oct 2017 01:06:06 +0200
Message-ID: <20171026230611.14269-4-fw@strlen.de>
References: <20171026230611.14269-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59762 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932335AbdJZXGG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 19:06:06 -0400
In-Reply-To: <20171026230611.14269-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have two places that kill previous dependency (if posssible)
and then store current statement as new dependency (if eligible).

Add a helper for this and use it both from netlink (trace monitor)
and netlink_delinarize.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h         |  6 +++++-
 src/netlink.c             | 11 +----------
 src/netlink_delinearize.c | 15 +--------------
 src/payload.c             | 25 ++++++++++++++++++++++++-
 4 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 22443adc3358..76662a7a8a91 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -43,7 +43,11 @@ extern void payload_dependency_store(struct payload_dep_ctx *ctx,
 extern void __payload_dependency_kill(struct payload_dep_ctx *ctx,
 				      enum proto_bases base);
 extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
-				    struct expr *expr);
+				    const struct expr *expr);
+extern void payload_dependency_update(struct payload_dep_ctx *pdctx,
+				      struct proto_ctx *ctx,
+				      struct stmt *stmt,
+				      enum proto_bases base);
 
 extern bool payload_can_merge(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
diff --git a/src/netlink.c b/src/netlink.c
index 845eeeffd738..0f1dc31dc73a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2753,16 +2753,7 @@ next:
 		n++;
 
 		stacked = payload_is_stacked(desc, rel);
-
-		if (lhs->flags & EXPR_F_PROTOCOL &&
-		    pctx->pbase == PROTO_BASE_INVALID) {
-			payload_dependency_store(pctx, stmt, base - stacked);
-		} else {
-			payload_dependency_kill(pctx, lhs);
-			if (lhs->flags & EXPR_F_PROTOCOL)
-				payload_dependency_store(pctx, stmt, base - stacked);
-		}
-
+		payload_dependency_update(pctx, ctx, stmt, base - stacked);
 		goto next;
 	}
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1a5724843218..543b3a379b15 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1339,20 +1339,7 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		assert(base == left->payload.base);
 
 		stacked = payload_is_stacked(ctx->pctx.protocol[base].desc, nexpr);
-
-		/* Remember the first payload protocol expression to
-		 * kill it later on if made redundant by a higher layer
-		 * payload expression.
-		 */
-		if (ctx->pdctx.pbase == PROTO_BASE_INVALID &&
-		    expr->op == OP_EQ &&
-		    left->flags & EXPR_F_PROTOCOL) {
-			payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
-		} else {
-			payload_dependency_kill(&ctx->pdctx, nexpr->left);
-			if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
-				payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
-		}
+		payload_dependency_update(&ctx->pdctx, &ctx->pctx, nstmt, base - stacked);
 	}
 	list_del(&ctx->stmt->list);
 	stmt_free(ctx->stmt);
diff --git a/src/payload.c b/src/payload.c
index 7d5596670cb4..f1b0def7cd28 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -493,7 +493,30 @@ void __payload_dependency_kill(struct payload_dep_ctx *ctx,
 	}
 }
 
-void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr)
+void payload_dependency_update(struct payload_dep_ctx *pdctx,
+			       struct proto_ctx *ctx,
+			       struct stmt *stmt,
+			       enum proto_bases base)
+{
+	const struct expr *expr = stmt->expr;
+	const struct expr *left;
+
+	assert(stmt->ops->type == STMT_EXPRESSION);
+	assert(expr->ops->type == EXPR_RELATIONAL);
+
+	left = expr->left;
+	if (pdctx->pbase == PROTO_BASE_INVALID &&
+	    expr->op == OP_EQ &&
+	    left->flags & EXPR_F_PROTOCOL) {
+		payload_dependency_store(pdctx, stmt, base);
+	} else {
+		payload_dependency_kill(pdctx, left);
+		if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
+			payload_dependency_store(pdctx, stmt, base);
+	}
+}
+
+void payload_dependency_kill(struct payload_dep_ctx *ctx, const struct expr *expr)
 {
 	__payload_dependency_kill(ctx, expr_to_base(expr));
 }
-- 
2.13.6

