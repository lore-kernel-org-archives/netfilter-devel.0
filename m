From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/8] src: remove exthdr_dependency_kill
Date: Fri, 27 Oct 2017 01:06:05 +0200
Message-ID: <20171026230611.14269-3-fw@strlen.de>
References: <20171026230611.14269-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59760 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932335AbdJZXGC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 19:06:02 -0400
In-Reply-To: <20171026230611.14269-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Extend payload_dependency_kill to obtain the base from the
ct/meta/payload expression and convert the only caller.

This also introduces new WARN() define.
An earlier version used BUG() here, however, because this is used
during delinearization it seems better to not crash on a user
and just continue instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h         |  2 --
 include/utils.h           |  1 +
 src/netlink_delinearize.c |  2 +-
 src/payload.c             | 51 +++++++++++++++++++++++++++++++++--------------
 4 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 8e357aef461e..22443adc3358 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -44,8 +44,6 @@ extern void __payload_dependency_kill(struct payload_dep_ctx *ctx,
 				      enum proto_bases base);
 extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
 				    struct expr *expr);
-extern void exthdr_dependency_kill(struct payload_dep_ctx *ctx,
-				   struct expr *expr);
 
 extern bool payload_can_merge(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
diff --git a/include/utils.h b/include/utils.h
index 369195240e24..1eaf1ed9b1d7 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -28,6 +28,7 @@
 #define __noreturn		__attribute__((__noreturn__))
 
 #define BUG(fmt, arg...)	({ fprintf(stderr, "BUG: " fmt, ##arg); assert(0); })
+#define WARN(fmt, arg...)	({ fprintf(stderr, "WARN: " fmt, ##arg); })
 
 #define BUILD_BUG_ON(condition)	((void)sizeof(char[1 - 2*!!(condition)]))
 #define BUILD_BUG_ON_ZERO(e)	(sizeof(char[1 - 2 * !!(e)]) - 1)
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 44328879ebb8..1a5724843218 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1834,7 +1834,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		expr_postprocess(ctx, &expr->key);
 		break;
 	case EXPR_EXTHDR:
-		exthdr_dependency_kill(&ctx->pdctx, expr);
+		payload_dependency_kill(&ctx->pdctx, expr);
 		break;
 	case EXPR_SET_REF:
 	case EXPR_META:
diff --git a/src/payload.c b/src/payload.c
index aa8a95ad59f1..7d5596670cb4 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -433,6 +433,41 @@ void payload_dependency_store(struct payload_dep_ctx *ctx,
 	ctx->pdep  = stmt;
 }
 
+static enum proto_bases exthdr_to_base(const struct expr *expr)
+{
+	switch (expr->exthdr.op) {
+	case NFT_EXTHDR_OP_TCPOPT:
+		return PROTO_BASE_TRANSPORT_HDR;
+		break;
+	case NFT_EXTHDR_OP_IPV6:
+		return PROTO_BASE_NETWORK_HDR;
+	default:
+		WARN("Unhandled exthdr operation %d",
+				expr->exthdr.op);
+		break;
+	}
+
+	return PROTO_BASE_INVALID;
+}
+
+static enum proto_bases expr_to_base(const struct expr *expr)
+{
+	switch (expr->ops->type) {
+	case EXPR_PAYLOAD:
+		return expr->payload.base;
+	case EXPR_META:
+		return expr->meta.base;
+	case EXPR_CT:
+		return expr->ct.base;
+	case EXPR_EXTHDR:
+		return exthdr_to_base(expr);
+	default:
+		WARN("Cannot use payload_dependency_kill with expression type %d", expr->ops->type);
+	}
+
+	return PROTO_BASE_INVALID;
+}
+
 /**
  * __payload_dependency_kill - kill a redundant payload depedency
  *
@@ -460,21 +495,7 @@ void __payload_dependency_kill(struct payload_dep_ctx *ctx,
 
 void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr)
 {
-	__payload_dependency_kill(ctx, expr->payload.base);
-}
-
-void exthdr_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr)
-{
-	switch (expr->exthdr.op) {
-	case NFT_EXTHDR_OP_TCPOPT:
-		__payload_dependency_kill(ctx, PROTO_BASE_TRANSPORT_HDR);
-		break;
-	case NFT_EXTHDR_OP_IPV6:
-		__payload_dependency_kill(ctx, PROTO_BASE_NETWORK_HDR);
-		break;
-	default:
-		break;
-	}
+	__payload_dependency_kill(ctx, expr_to_base(expr));
 }
 
 /**
-- 
2.13.6

