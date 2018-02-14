From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/6] src: add payload_dependency_exists()
Date: Wed, 14 Feb 2018 16:22:26 +0100
Message-ID: <20180214152229.11830-4-pablo@netfilter.org>
References: <20180214152229.11830-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031177AbeBNPWk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 10:22:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0D18117739
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C34C4DA727
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8053DA727
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:36 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7FFCD41E4817
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:36 +0100 (CET)
In-Reply-To: <20180214152229.11830-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This helper function tells us if there is already a protocol key payload
expression, ie. those with EXPR_F_PROTOCOL flag set on, that we might
want to remove since we can infer from another expression in the upper
protocol base, eg.

	ip protocol tcp tcp dport 22

'ip protocol tcp' can be removed in the ip family since it is redundant,
but not in the netdev, bridge and inet families, where we cannot make
assumptions on the layer 3 protocol.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/payload.h         |  3 ++-
 src/netlink_delinearize.c | 15 +++++++++------
 src/payload.c             | 34 +++++++++++++++++++++++++---------
 3 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 294ff2706e30..dec4647aad9f 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -40,8 +40,9 @@ void payload_dependency_reset(struct payload_dep_ctx *ctx);
 extern void payload_dependency_store(struct payload_dep_ctx *ctx,
 				     struct stmt *stmt,
 				     enum proto_bases base);
+extern bool payload_dependency_exists(const struct payload_dep_ctx *ctx,
+				      enum proto_bases base);
 extern void __payload_dependency_kill(struct payload_dep_ctx *ctx,
-				      enum proto_bases base,
 				      unsigned int family);
 extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
 				    struct expr *expr, unsigned int family);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8d11969e0fb1..f4b943964fc9 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1407,8 +1407,9 @@ static void ct_meta_common_postprocess(struct rule_pp_ctx *ctx,
 		    left->flags & EXPR_F_PROTOCOL) {
 			payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		} else if (ctx->pdctx.pbase < PROTO_BASE_TRANSPORT_HDR) {
-			__payload_dependency_kill(&ctx->pdctx, base,
-						  ctx->pctx.family);
+			if (payload_dependency_exists(&ctx->pdctx, base))
+				__payload_dependency_kill(&ctx->pdctx,
+							  ctx->pctx.family);
 			if (left->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(&ctx->pdctx, ctx->stmt, base);
 		}
@@ -1870,17 +1871,19 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 	case NFPROTO_IPV4:
 		stmt->reject.family = rctx->pctx.family;
 		stmt->reject.expr->dtype = &icmp_code_type;
-		if (stmt->reject.type == NFT_REJECT_TCP_RST)
+		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
+		    payload_dependency_exists(&rctx->pdctx,
+					      PROTO_BASE_TRANSPORT_HDR))
 			__payload_dependency_kill(&rctx->pdctx,
-						  PROTO_BASE_TRANSPORT_HDR,
 						  rctx->pctx.family);
 		break;
 	case NFPROTO_IPV6:
 		stmt->reject.family = rctx->pctx.family;
 		stmt->reject.expr->dtype = &icmpv6_code_type;
-		if (stmt->reject.type == NFT_REJECT_TCP_RST)
+		if (stmt->reject.type == NFT_REJECT_TCP_RST &&
+		    payload_dependency_exists(&rctx->pdctx,
+					      PROTO_BASE_TRANSPORT_HDR))
 			__payload_dependency_kill(&rctx->pdctx,
-						  PROTO_BASE_TRANSPORT_HDR,
 						  rctx->pctx.family);
 		break;
 	case NFPROTO_INET:
diff --git a/src/payload.c b/src/payload.c
index 21c2842807cd..df59ac8adcac 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -428,6 +428,23 @@ void payload_dependency_store(struct payload_dep_ctx *ctx,
 	ctx->pdep  = stmt;
 }
 
+/**
+ * payload_dependency_exists - there is a payload dependency in place
+ * @ctx: payload dependency context
+ * @base: payload protocol base
+ *
+ * Check if we have seen a protocol key payload expression for this base, we can
+ * usually remove it if we can infer it from another payload expression in the
+ * upper base.
+ */
+bool payload_dependency_exists(const struct payload_dep_ctx *ctx,
+			       enum proto_bases base)
+{
+	return ctx->pbase != PROTO_BASE_INVALID &&
+	       ctx->pbase == base &&
+	       ctx->pdep != NULL;
+}
+
 static void payload_dependency_release(struct payload_dep_ctx *ctx)
 {
 	list_del(&ctx->pdep->list);
@@ -448,19 +465,16 @@ static void payload_dependency_release(struct payload_dep_ctx *ctx)
  * Kill a redundant payload expression if a higher layer payload expression
  * implies its existance.
  */
-void __payload_dependency_kill(struct payload_dep_ctx *ctx,
-			       enum proto_bases base, unsigned int family)
+void __payload_dependency_kill(struct payload_dep_ctx *ctx, unsigned int family)
 {
-	if (ctx->pbase != PROTO_BASE_INVALID &&
-	    ctx->pbase == base &&
-	    ctx->pdep != NULL)
-		payload_dependency_release(ctx);
+	payload_dependency_release(ctx);
 }
 
 void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 			     unsigned int family)
 {
-	__payload_dependency_kill(ctx, expr->payload.base, family);
+	if (payload_dependency_exists(ctx, expr->payload.base))
+		__payload_dependency_kill(ctx, family);
 }
 
 void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
@@ -468,10 +482,12 @@ void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 {
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_TCPOPT:
-		__payload_dependency_kill(ctx, PROTO_BASE_TRANSPORT_HDR, family);
+		if (payload_dependency_exists(ctx, PROTO_BASE_TRANSPORT_HDR))
+			__payload_dependency_kill(ctx, family);
 		break;
 	case NFT_EXTHDR_OP_IPV6:
-		__payload_dependency_kill(ctx, PROTO_BASE_NETWORK_HDR, family);
+		if (payload_dependency_exists(ctx, PROTO_BASE_NETWORK_HDR))
+			__payload_dependency_kill(ctx, family);
 		break;
 	default:
 		break;
-- 
2.11.0

