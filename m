From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: use printf() instead of pr_debug() whenever possible
Date: Thu,  8 Jan 2015 13:13:46 +0100
Message-ID: <1420719226-5475-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45086 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbbAHMLL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:11:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

pr_debug() is disabled with --with-mini-gmp since it relies on the
gmp_printf(), which is not available in the mini-gmp implementation.
Use printf() instead of pr_debug() if no mpz_t types are used, so
we get debugging information for proto-ctx as well.

This leaves the pr_debug() usage limited to src/segtree.c.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |    2 --
 src/proto.c               |   14 +++++++-------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e9a04dd..b34d586 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -915,8 +915,6 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 {
 	struct expr *expr = *exprp, *i;
 
-	//pr_debug("%s len %u\n", expr->ops->name, expr->len);
-
 	switch (expr->ops->type) {
 	case EXPR_MAP:
 		expr_postprocess(ctx, stmt, &expr->map);
diff --git a/src/proto.c b/src/proto.c
index 7dc7b3e..6a12ee8 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -137,15 +137,15 @@ static void proto_ctx_debug(const struct proto_ctx *ctx, enum proto_bases base)
 	if (!(debug_level & DEBUG_PROTO_CTX))
 		return;
 
-	pr_debug("update %s protocol context:\n", proto_base_names[base]);
+	printf("update %s protocol context:\n", proto_base_names[base]);
 	for (i = PROTO_BASE_LL_HDR; i <= PROTO_BASE_MAX; i++) {
-		pr_debug(" %-20s: %s%s\n",
-			 proto_base_names[i],
-			 ctx->protocol[i].desc ? ctx->protocol[i].desc->name :
-						 "none",
-			 i == base ? " <-" : "");
+		printf(" %-20s: %s%s\n",
+		       proto_base_names[i],
+		       ctx->protocol[i].desc ? ctx->protocol[i].desc->name :
+					       "none",
+		       i == base ? " <-" : "");
 	}
-	pr_debug("\n");
+	printf("\n");
 #endif
 }
 
-- 
1.7.10.4

