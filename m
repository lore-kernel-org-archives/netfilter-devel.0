From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/6] src: pass family to payload_dependency_kill()
Date: Wed, 14 Feb 2018 16:22:24 +0100
Message-ID: <20180214152229.11830-2-pablo@netfilter.org>
References: <20180214152229.11830-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51630 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030767AbeBNPWj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 10:22:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2A116117735
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 196C8DA3A0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BFA3DA78B
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:35 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 01BFD41E4817
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:34 +0100 (CET)
In-Reply-To: <20180214152229.11830-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This context information is very relevant when deciding if a redundant
dependency needs to be removed or not, specifically for the inet, bridge
and netdev families. This new parameter is used by follow up patch
entitled ("payload: add payload_should_dependency_kill()").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/payload.h         |  7 ++++---
 src/netlink.c             |  2 +-
 src/netlink_delinearize.c | 18 +++++++++++-------
 src/payload.c             | 14 ++++++++------
 4 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 8e357aef461e..294ff2706e30 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -41,11 +41,12 @@ extern void payload_dependency_store(struct payload_dep_ctx *ctx,
 				     struct stmt *stmt,
 				     enum proto_bases base);
 extern void __payload_dependency_kill(struct payload_dep_ctx *ctx,
-				      enum proto_bases base);
+				      enum proto_bases base,
+				      unsigned int family);
 extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
-				    struct expr *expr);
+				    struct expr *expr, unsigned int family);
 extern void exthdr_dependency_kill(struct payload_dep_ctx *ctx,
-				   struct expr *expr);
+				   struct expr *expr, unsigned int family);
 
 extern bool payload_can_merge(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
diff --git a/src/netlink.c b/src/netlink.c
index 488ae6f3971f..233bfd2df764 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2768,7 +2768,7 @@ next:
 		    pctx->pbase == PROTO_BASE_INVALID) {
 			payload_dependency_store(pctx, stmt, base - stacked);
 		} else {
-			payload_dependency_kill(pctx, lhs);
+			payload_dependency_kill(pctx, lhs, ctx->family);
 			if (lhs->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(pctx, stmt, base - stacked);
 		}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 256552b5b46e..8d11969e0fb1 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1352,7 +1352,8 @@ static void payload_match_expand(struct rule_pp_ctx *ctx,
 		    left->flags & EXPR_F_PROTOCOL) {
 			payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
 		} else {
-			payload_dependency_kill(&ctx->pdctx, nexpr->left);
+			payload_dependency_kill(&ctx->pdctx, nexpr->left,
+						ctx->pctx.family);
 			if (expr->op == OP_EQ && left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(&ctx->pdctx, nstmt, base - stacked);
 		}
@@ -1383,7 +1384,7 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 		payload_expr_complete(payload, &ctx->pctx);
 		expr_set_type(expr->right, payload->dtype,
 			      payload->byteorder);
-		payload_dependency_kill(&ctx->pdctx, payload);
+		payload_dependency_kill(&ctx->pdctx, payload, ctx->pctx.family);
 		break;
 	}
 }
@@ -1406,7 +1407,8 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 		    left->flags & EXPR_F_PROTOCOL) {
 			payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		} else if (ctx->pdctx.pbase < PROTO_BASE_TRANSPORT_HDR) {
-			__payload_dependency_kill(&ctx->pdctx, base);
+			__payload_dependency_kill(&ctx->pdctx, base,
+						  ctx->pctx.family);
 			if (left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		}
@@ -1814,7 +1816,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		break;
 	case EXPR_PAYLOAD:
 		payload_expr_complete(expr, &ctx->pctx);
-		payload_dependency_kill(&ctx->pdctx, expr);
+		payload_dependency_kill(&ctx->pdctx, expr, ctx->pctx.family);
 		break;
 	case EXPR_VALUE:
 		// FIXME
@@ -1837,7 +1839,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->key);
 		break;
 	case EXPR_EXTHDR:
-		exthdr_dependency_kill(&ctx->pdctx, expr);
+		exthdr_dependency_kill(&ctx->pdctx, expr, ctx->pctx.family);
 		break;
 	case EXPR_SET_REF:
 	case EXPR_META:
@@ -1870,14 +1872,16 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		stmt->reject.expr->dtype = &icmp_code_type;
 		if (stmt->reject.type == NFT_REJECT_TCP_RST)
 			__payload_dependency_kill(&rctx->pdctx,
-						  PROTO_BASE_TRANSPORT_HDR);
+						  PROTO_BASE_TRANSPORT_HDR,
+						  rctx->pctx.family);
 		break;
 	case NFPROTO_IPV6:
 		stmt->reject.family = rctx->pctx.family;
 		stmt->reject.expr->dtype = &icmpv6_code_type;
 		if (stmt->reject.type == NFT_REJECT_TCP_RST)
 			__payload_dependency_kill(&rctx->pdctx,
-						  PROTO_BASE_TRANSPORT_HDR);
+						  PROTO_BASE_TRANSPORT_HDR,
+						  rctx->pctx.family);
 		break;
 	case NFPROTO_INET:
 		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
diff --git a/src/payload.c b/src/payload.c
index 60090accbcd8..df3c8136c88c 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -438,7 +438,7 @@ void payload_dependency_store(struct payload_dep_ctx *ctx,
  * implies its existance.
  */
 void __payload_dependency_kill(struct payload_dep_ctx *ctx,
-			       enum proto_bases base)
+			       enum proto_bases base, unsigned int family)
 {
 	if (ctx->pbase != PROTO_BASE_INVALID &&
 	    ctx->pbase == base &&
@@ -453,19 +453,21 @@ void __payload_dependency_kill(struct payload_dep_ctx *ctx,
 	}
 }
 
-void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr)
+void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
+			     unsigned int family)
 {
-	__payload_dependency_kill(ctx, expr->payload.base);
+	__payload_dependency_kill(ctx, expr->payload.base, family);
 }
 
-void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr)
+void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
+			    unsigned int family)
 {
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_TCPOPT:
-		__payload_dependency_kill(ctx, PROTO_BASE_TRANSPORT_HDR);
+		__payload_dependency_kill(ctx, PROTO_BASE_TRANSPORT_HDR, family);
 		break;
 	case NFT_EXTHDR_OP_IPV6:
-		__payload_dependency_kill(ctx, PROTO_BASE_NETWORK_HDR);
+		__payload_dependency_kill(ctx, PROTO_BASE_NETWORK_HDR, family);
 		break;
 	default:
 		break;
-- 
2.11.0

