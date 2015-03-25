From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] netlink_delinarize: fix payload dependency killing of link layer dependencies
Date: Wed, 25 Mar 2015 21:00:26 +0000
Message-ID: <1427317227-11313-2-git-send-email-kaber@trash.net>
References: <1427317227-11313-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51965 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbbCYVAb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 17:00:31 -0400
In-Reply-To: <1427317227-11313-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

payload_dependency_kill() does not properly handle dependencies for link
layer expressions. Since those dependencies are logically defined on an
even lower layer (device layer), we don't have a payload base for them,
meaning they will use PROTO_BASE_INVALID, which is skipped.

So instead of storing the payload base on which the dependency is defined,
we store the base of the layer for which the dependency applies, meaning
dependencies defined by the device layer will properly work.

This fixes killing the dependency of ether saddr, instead of

iiftype ether ether ether saddr ...

we now only display

ether saddr ...

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink_delinearize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 387bb67..ec1a964 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -753,7 +753,7 @@ struct rule_pp_ctx {
 static void payload_dependency_kill(struct rule_pp_ctx *ctx, struct expr *expr)
 {
 	if (ctx->pbase != PROTO_BASE_INVALID &&
-	    ctx->pbase == expr->payload.base - 1 &&
+	    ctx->pbase == expr->payload.base &&
 	    ctx->pdep != NULL) {
 		list_del(&ctx->pdep->list);
 		stmt_free(ctx->pdep);
@@ -766,7 +766,7 @@ static void payload_dependency_store(struct rule_pp_ctx *ctx,
 				     struct stmt *stmt,
 				     enum proto_bases base)
 {
-	ctx->pbase = base;
+	ctx->pbase = base + 1;
 	ctx->pdep  = stmt;
 }
 
-- 
2.1.0

