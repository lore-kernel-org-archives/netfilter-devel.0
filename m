From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 07/10] exthdr: remove implicit dependencies
Date: Tue,  1 Mar 2016 16:37:47 +0100
Message-ID: <1456846670-28179-8-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49310 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbcCAPhz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:37:55 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

exthdr expression requires a dependency on ipv6; we can
thus remove an ipv6 protocol test if its present.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ae6abb0..eec7d0f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -982,10 +982,10 @@ struct rule_pp_ctx {
 /*
  * Kill a redundant payload dependecy that is implied by a higher layer payload expression.
  */
-static void payload_dependency_kill(struct rule_pp_ctx *ctx, struct expr *expr)
+static void __payload_dependency_kill(struct rule_pp_ctx *ctx, enum proto_bases base)
 {
 	if (ctx->pbase != PROTO_BASE_INVALID &&
-	    ctx->pbase == expr->payload.base &&
+	    ctx->pbase == base &&
 	    ctx->pdep != NULL) {
 		list_del(&ctx->pdep->list);
 		stmt_free(ctx->pdep);
@@ -996,6 +996,11 @@ static void payload_dependency_kill(struct rule_pp_ctx *ctx, struct expr *expr)
 	}
 }
 
+static void payload_dependency_kill(struct rule_pp_ctx *ctx, const struct expr *expr)
+{
+	__payload_dependency_kill(ctx, expr->payload.base);
+}
+
 static void payload_dependency_store(struct rule_pp_ctx *ctx,
 				     struct stmt *stmt,
 				     enum proto_bases base)
@@ -1505,8 +1510,10 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_SET_ELEM:
 		expr_postprocess(ctx, &expr->key);
 		break;
-	case EXPR_SET_REF:
 	case EXPR_EXTHDR:
+		__payload_dependency_kill(ctx, PROTO_BASE_NETWORK_HDR);
+		break;
+	case EXPR_SET_REF:
 	case EXPR_META:
 	case EXPR_VERDICT:
 		break;
-- 
2.4.10

