From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/8] src: pass proto_ctx to payload_dependency_kill
Date: Fri, 27 Oct 2017 01:06:07 +0200
Message-ID: <20171026230611.14269-5-fw@strlen.de>
References: <20171026230611.14269-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59766 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932335AbdJZXGK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 19:06:10 -0400
In-Reply-To: <20171026230611.14269-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Preparation patch only, we pass proto_ctx but don't
do anything with it yet to reduce noise of follup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h         |  6 ++++--
 src/netlink_delinearize.c | 12 ++++++------
 src/payload.c             | 32 ++++++++++++++++++--------------
 3 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 76662a7a8a91..baf284e9c307 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -40,9 +40,11 @@ void payload_dependency_reset(struct payload_dep_ctx *ctx);
 extern void payload_dependency_store(struct payload_dep_ctx *ctx,
 				     struct stmt *stmt,
 				     enum proto_bases base);
-extern void __payload_dependency_kill(struct payload_dep_ctx *ctx,
+extern void __payload_dependency_kill(struct payload_dep_ctx *pdctx,
+				      const struct proto_ctx *pctx,
 				      enum proto_bases base);
-extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
+extern void payload_dependency_kill(struct payload_dep_ctx *pdctx,
+				    const struct proto_ctx *pctx,
 				    const struct expr *expr);
 extern void payload_dependency_update(struct payload_dep_ctx *pdctx,
 				      struct proto_ctx *ctx,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 543b3a379b15..57d780b316d0 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1367,7 +1367,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		payload_expr_complete(payload, &ctx->pctx);
 		expr_set_type(expr->right, payload->dtype,
 			      payload->byteorder);
-		payload_dependency_kill(&ctx->pdctx, payload);
+		payload_dependency_kill(&ctx->pdctx, &ctx->pctx, payload);
 		break;
 	}
 }
@@ -1390,7 +1390,7 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 		    left->flags & EXPR_F_PROTOCOL) {
 			payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		} else if (ctx->pdctx.pbase < PROTO_BASE_TRANSPORT_HDR) {
-			__payload_dependency_kill(&ctx->pdctx, base);
+			__payload_dependency_kill(&ctx->pdctx, &ctx->pctx, base);
 			if (left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		}
@@ -1798,7 +1798,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		break;
 	case EXPR_PAYLOAD:
 		payload_expr_complete(expr, &ctx->pctx);
-		payload_dependency_kill(&ctx->pdctx, expr);
+		payload_dependency_kill(&ctx->pdctx, &ctx->pctx, expr);
 		break;
 	case EXPR_VALUE:
 		// FIXME
@@ -1821,7 +1821,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->key);
 		break;
 	case EXPR_EXTHDR:
-		payload_dependency_kill(&ctx->pdctx, expr);
+		payload_dependency_kill(&ctx->pdctx, &ctx->pctx, expr);
 		break;
 	case EXPR_SET_REF:
 	case EXPR_META:
@@ -1853,14 +1853,14 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		stmt->reject.family = rctx->pctx.family;
 		stmt->reject.expr->dtype = &icmp_code_type;
 		if (stmt->reject.type == NFT_REJECT_TCP_RST)
-			__payload_dependency_kill(&rctx->pdctx,
+			__payload_dependency_kill(&rctx->pdctx, &rctx->pctx,
 						  PROTO_BASE_TRANSPORT_HDR);
 		break;
 	case NFPROTO_IPV6:
 		stmt->reject.family = rctx->pctx.family;
 		stmt->reject.expr->dtype = &icmpv6_code_type;
 		if (stmt->reject.type == NFT_REJECT_TCP_RST)
-			__payload_dependency_kill(&rctx->pdctx,
+			__payload_dependency_kill(&rctx->pdctx, &rctx->pctx,
 						  PROTO_BASE_TRANSPORT_HDR);
 		break;
 	case NFPROTO_INET:
diff --git a/src/payload.c b/src/payload.c
index f1b0def7cd28..12d359fd1738 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -471,25 +471,27 @@ static enum proto_bases expr_to_base(const struct expr *expr)
 /**
  * __payload_dependency_kill - kill a redundant payload depedency
  *
- * @ctx: payload dependency context
+ * @pdctx: payload dependency context
+ * @pctx: protocol context
  * @expr: higher layer payload expression
  *
  * Kill a redundant payload expression if a higher layer payload expression
  * implies its existance.
  */
-void __payload_dependency_kill(struct payload_dep_ctx *ctx,
+void __payload_dependency_kill(struct payload_dep_ctx *pdctx,
+			       const struct proto_ctx *pctx,
 			       enum proto_bases base)
 {
-	if (ctx->pbase != PROTO_BASE_INVALID &&
-	    ctx->pbase == base &&
-	    ctx->pdep != NULL) {
-		list_del(&ctx->pdep->list);
-		stmt_free(ctx->pdep);
+	if (pdctx->pbase != PROTO_BASE_INVALID &&
+	    pdctx->pbase == base &&
+	    pdctx->pdep != NULL) {
+		list_del(&pdctx->pdep->list);
+		stmt_free(pdctx->pdep);
 
-		ctx->pbase = PROTO_BASE_INVALID;
-		if (ctx->pdep == ctx->prev)
-			ctx->prev = NULL;
-		ctx->pdep  = NULL;
+		pdctx->pbase = PROTO_BASE_INVALID;
+		if (pdctx->pdep == pdctx->prev)
+			pdctx->prev = NULL;
+		pdctx->pdep  = NULL;
 	}
 }
 
@@ -510,15 +512,17 @@ void payload_dependency_update(struct payload_dep_ctx *pdctx,
 	    left->flags & EXPR_F_PROTOCOL) {
 		payload_dependency_store(pdctx, stmt, base);
 	} else {
-		payload_dependency_kill(pdctx, left);
+		payload_dependency_kill(pdctx, ctx, left);
 		if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
 			payload_dependency_store(pdctx, stmt, base);
 	}
 }
 
-void payload_dependency_kill(struct payload_dep_ctx *ctx, const struct expr *expr)
+void payload_dependency_kill(struct payload_dep_ctx *pdctx,
+			     const struct proto_ctx *ctx,
+			     const struct expr *expr)
 {
-	__payload_dependency_kill(ctx, expr_to_base(expr));
+	__payload_dependency_kill(pdctx, ctx, expr_to_base(expr));
 }
 
 /**
-- 
2.13.6

