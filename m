From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/6] src: get rid of __payload_dependency_kill()
Date: Wed, 14 Feb 2018 16:22:27 +0100
Message-ID: <20180214152229.11830-5-pablo@netfilter.org>
References: <20180214152229.11830-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51648 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030682AbeBNPWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 10:22:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9A3BC117737
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DC1CDA788
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72B1CDA808
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:37 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3EFA941E4817
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:37 +0100 (CET)
In-Reply-To: <20180214152229.11830-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use payload_dependency_release() instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/payload.h         |  3 +--
 src/netlink_delinearize.c |  9 +++------
 src/payload.c             | 15 +++++----------
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index dec4647aad9f..161c64aedf11 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -42,8 +42,7 @@ extern void payload_dependency_store(struct payload_dep_ctx *ctx,
 				     enum proto_bases base);
 extern bool payload_dependency_exists(const struct payload_dep_ctx *ctx,
 				      enum proto_bases base);
-extern void __payload_dependency_kill(struct payload_dep_ctx *ctx,
-				      unsigned int family);
+extern void payload_dependency_release(struct payload_dep_ctx *ctx);
 extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
 				    struct expr *expr, unsigned int family);
 extern void exthdr_dependency_kill(struct payload_dep_ctx *ctx,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index f4b943964fc9..b9f195b07d63 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1408,8 +1408,7 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 			payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		} else if (ctx->pdctx.pbase < PROTO_BASE_TRANSPORT_HDR) {
 			if (payload_dependency_exists(&ctx->pdctx, base))
-				__payload_dependency_kill(&ctx->pdctx,
-							  ctx->pctx.family);
+				payload_dependency_release(&ctx->pdctx);
 			if (left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		}
@@ -1874,8 +1873,7 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
 		    payload_dependency_exists(&rctx->pdctx,
 					      PROTO_BASE_TRANSPORT_HDR))
-			__payload_dependency_kill(&rctx->pdctx,
-						  rctx->pctx.family);
+			payload_dependency_release(&rctx->pdctx);
 		break;
 	case NFPROTO_IPV6:
 		stmt->reject.family = rctx->pctx.family;
@@ -1883,8 +1881,7 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
 		    payload_dependency_exists(&rctx->pdctx,
 					      PROTO_BASE_TRANSPORT_HDR))
-			__payload_dependency_kill(&rctx->pdctx,
-						  rctx->pctx.family);
+			payload_dependency_release(&rctx->pdctx);
 		break;
 	case NFPROTO_INET:
 		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
diff --git a/src/payload.c b/src/payload.c
index df59ac8adcac..383aed039a5e 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -445,7 +445,7 @@ bool payload_dependency_exists(const struct payload_dep_ctx *ctx,
 	       ctx->pdep != NULL;
 }
 
-static void payload_dependency_release(struct payload_dep_ctx *ctx)
+void payload_dependency_release(struct payload_dep_ctx *ctx)
 {
 	list_del(&ctx->pdep->list);
 	stmt_free(ctx->pdep);
@@ -457,7 +457,7 @@ static void payload_dependency_release(struct payload_dep_ctx *ctx)
 }
 
 /**
- * __payload_dependency_kill - kill a redundant payload depedency
+ * payload_dependency_kill - kill a redundant payload depedency
  *
  * @ctx: payload dependency context
  * @expr: higher layer payload expression
@@ -465,16 +465,11 @@ static void payload_dependency_release(struct payload_dep_ctx *ctx)
  * Kill a redundant payload expression if a higher layer payload expression
  * implies its existance.
  */
-void __payload_dependency_kill(struct payload_dep_ctx *ctx, unsigned int family)
-{
-	payload_dependency_release(ctx);
-}
-
 void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 			     unsigned int family)
 {
 	if (payload_dependency_exists(ctx, expr->payload.base))
-		__payload_dependency_kill(ctx, family);
+		payload_dependency_release(ctx);
 }
 
 void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
@@ -483,11 +478,11 @@ void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_TCPOPT:
 		if (payload_dependency_exists(ctx, PROTO_BASE_TRANSPORT_HDR))
-			__payload_dependency_kill(ctx, family);
+			payload_dependency_release(ctx);
 		break;
 	case NFT_EXTHDR_OP_IPV6:
 		if (payload_dependency_exists(ctx, PROTO_BASE_NETWORK_HDR))
-			__payload_dependency_kill(ctx, family);
+			payload_dependency_release(ctx);
 		break;
 	default:
 		break;
-- 
2.11.0

