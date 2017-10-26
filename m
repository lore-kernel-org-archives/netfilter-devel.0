From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 7/8] payload: consider expression type during dependency removal
Date: Fri, 27 Oct 2017 01:06:10 +0200
Message-ID: <20171026230611.14269-8-fw@strlen.de>
References: <20171026230611.14269-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59778 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932334AbdJZXGT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 19:06:19 -0400
In-Reply-To: <20171026230611.14269-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

permit removal of linklayer dependencies if the current
expression type permits this.

This gets rid of most of the warnings added by the previous
commit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c |  2 +-
 src/payload.c             | 37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 57d780b316d0..efb80fdc3da4 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1390,7 +1390,7 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 		    left->flags & EXPR_F_PROTOCOL) {
 			payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		} else if (ctx->pdctx.pbase < PROTO_BASE_TRANSPORT_HDR) {
-			__payload_dependency_kill(&ctx->pdctx, &ctx->pctx, base);
+			payload_dependency_kill(&ctx->pdctx, &ctx->pctx, left);
 			if (left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		}
diff --git a/src/payload.c b/src/payload.c
index 184a611704ea..69985af99c9a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -506,6 +506,7 @@ static bool get_relop_base(const struct stmt *stmt,
  */
 static bool pdep_is_redundant(struct payload_dep_ctx *pdctx,
 			      const struct proto_ctx *pctx,
+			      const struct expr *e,
 			      enum proto_bases base)
 {
 	const struct proto_desc *proto, *proto_upper;
@@ -541,6 +542,28 @@ static bool pdep_is_redundant(struct payload_dep_ctx *pdctx,
 		break;
 	case PROTO_BASE_LL_HDR:
 		/*
+		 * If we have an expression, then check if it implies an l3
+		 * protocol.
+		 * If we don't have one, then we keep the protocol dependency.
+		 */
+		if (!e)
+			return false;
+
+		if ((e->flags & EXPR_F_PROTOCOL) == 0)
+			return true;
+
+		switch (e->ops->type) {
+		case EXPR_PAYLOAD:
+			return true;
+		case EXPR_CT:
+			if (type == EXPR_CT) /* ct s/daddr */
+				return true;
+			break;
+		default:
+			break;
+		}
+
+		/*
 		 * It would be nice to also remove
 		 * 'meta nfproto' in cases like
 		 * meta nfproto ipv6 icmpv6 type ..., but we can't.
@@ -574,14 +597,15 @@ static bool pdep_is_redundant(struct payload_dep_ctx *pdctx,
  * Kill a redundant payload expression if a higher layer payload expression
  * implies its existance.
  */
-void __payload_dependency_kill(struct payload_dep_ctx *pdctx,
+static void do_payload_dependency_kill(struct payload_dep_ctx *pdctx,
 			       const struct proto_ctx *pctx,
+			       const struct expr *e,
 			       enum proto_bases base)
 {
 	if (pdctx->pbase != PROTO_BASE_INVALID &&
 	    pdctx->pbase == base &&
 	    pdctx->pdep != NULL &&
-	    pdep_is_redundant(pdctx, pctx, base)) {
+	    pdep_is_redundant(pdctx, pctx, e, base)) {
 		list_del(&pdctx->pdep->list);
 		stmt_free(pdctx->pdep);
 
@@ -592,6 +616,13 @@ void __payload_dependency_kill(struct payload_dep_ctx *pdctx,
 	}
 }
 
+void __payload_dependency_kill(struct payload_dep_ctx *pdctx,
+			       const struct proto_ctx *pctx,
+			       enum proto_bases base)
+{
+	do_payload_dependency_kill(pdctx, pctx, NULL, base);
+}
+
 void payload_dependency_update(struct payload_dep_ctx *pdctx,
 			       struct proto_ctx *ctx,
 			       struct stmt *stmt,
@@ -619,7 +650,7 @@ void payload_dependency_kill(struct payload_dep_ctx *pdctx,
 			     const struct proto_ctx *ctx,
 			     const struct expr *expr)
 {
-	__payload_dependency_kill(pdctx, ctx, expr_to_base(expr));
+	do_payload_dependency_kill(pdctx, ctx, expr, expr_to_base(expr));
 }
 
 /**
-- 
2.13.6

