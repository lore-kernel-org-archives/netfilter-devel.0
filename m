From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/6] netlink: remove unnecessary temporary variable
Date: Sun, 11 Jan 2015 08:09:37 +0000
Message-ID: <1420963782-21189-2-git-send-email-kaber@trash.net>
References: <1420963782-21189-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54793 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbAKIJs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:09:48 -0500
In-Reply-To: <1420963782-21189-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Waste less space and return the results of the batch/compat
functions directly.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 72 +++++++++++++++--------------------------------------------
 1 file changed, 18 insertions(+), 54 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 5347372..ceb1d3f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -546,14 +546,10 @@ int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc, const struct chain *chain,
 		      bool excl)
 {
-	int ret;
-
 	if (ctx->batch_supported)
-		ret = netlink_add_chain_batch(ctx, h, loc, chain, excl);
+		return netlink_add_chain_batch(ctx, h, loc, chain, excl);
 	else
-		ret = netlink_add_chain_compat(ctx, h, loc, chain, excl);
-
-	return ret;
+		return netlink_add_chain_compat(ctx, h, loc, chain, excl);
 }
 
 static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
@@ -600,14 +596,10 @@ static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
 int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc, const char *name)
 {
-	int ret;
-
 	if (ctx->batch_supported)
-		ret = netlink_rename_chain_batch(ctx, h, loc, name);
+		return netlink_rename_chain_batch(ctx, h, loc, name);
 	else
-		ret = netlink_rename_chain_compat(ctx, h, loc, name);
-
-	return ret;
+		return netlink_rename_chain_compat(ctx, h, loc, name);
 }
 
 static int netlink_del_chain_compat(struct netlink_ctx *ctx,
@@ -651,14 +643,10 @@ static int netlink_del_chain_batch(struct netlink_ctx *ctx,
 int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc)
 {
-	int ret;
-
 	if (ctx->batch_supported)
-		ret = netlink_del_chain_batch(ctx, h, loc);
+		return netlink_del_chain_batch(ctx, h, loc);
 	else
-		ret = netlink_del_chain_compat(ctx, h, loc);
-
-	return ret;
+		return netlink_del_chain_compat(ctx, h, loc);
 }
 
 static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
@@ -823,14 +811,10 @@ int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc,
 		      const struct table *table, bool excl)
 {
-	int ret;
-
 	if (ctx->batch_supported)
-		ret = netlink_add_table_batch(ctx, h, loc, table, excl);
+		return netlink_add_table_batch(ctx, h, loc, table, excl);
 	else
-		ret = netlink_add_table_compat(ctx, h, loc, table, excl);
-
-	return ret;
+		return netlink_add_table_compat(ctx, h, loc, table, excl);
 }
 
 static int netlink_del_table_compat(struct netlink_ctx *ctx,
@@ -871,14 +855,10 @@ static int netlink_del_table_batch(struct netlink_ctx *ctx,
 int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc)
 {
-	int ret;
-
 	if (ctx->batch_supported)
-		ret = netlink_del_table_batch(ctx, h, loc);
+		return netlink_del_table_batch(ctx, h, loc);
 	else
-		ret = netlink_del_table_compat(ctx, h, loc);
-
-	return ret;
+		return netlink_del_table_compat(ctx, h, loc);
 }
 
 void netlink_dump_table(struct nft_table *nlt)
@@ -1145,14 +1125,10 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		    struct set *set)
 {
-	int ret;
-
 	if (ctx->batch_supported)
-		ret = netlink_add_set_batch(ctx, h, set);
+		return netlink_add_set_batch(ctx, h, set);
 	else
-		ret = netlink_add_set_compat(ctx, h, set);
-
-	return ret;
+		return netlink_add_set_compat(ctx, h, set);
 }
 
 static int netlink_del_set_compat(struct netlink_ctx *ctx,
@@ -1192,14 +1168,10 @@ static int netlink_del_set_batch(struct netlink_ctx *ctx,
 int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
 		       const struct location *loc)
 {
-	int ret;
-
 	if (ctx->batch_supported)
-		ret = netlink_del_set_batch(ctx, h, loc);
+		return netlink_del_set_batch(ctx, h, loc);
 	else
-		ret = netlink_del_set_compat(ctx, h, loc);
-
-	return ret;
+		return netlink_del_set_compat(ctx, h, loc);
 }
 
 static int list_set_cb(struct nft_set *nls, void *arg)
@@ -1316,14 +1288,10 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct expr *expr)
 {
-	int ret;
-
 	if (ctx->batch_supported)
-		ret = netlink_add_setelems_batch(ctx, h, expr);
+		return netlink_add_setelems_batch(ctx, h, expr);
 	else
-		ret = netlink_add_setelems_compat(ctx, h, expr);
-
-	return ret;
+		return netlink_add_setelems_compat(ctx, h, expr);
 }
 
 static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
@@ -1418,14 +1386,10 @@ out:
 int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			    const struct expr *expr)
 {
-	int ret;
-
 	if (ctx->batch_supported)
-		ret = netlink_del_setelems_batch(ctx, h, expr);
+		return netlink_del_setelems_batch(ctx, h, expr);
 	else
-		ret = netlink_del_setelems_compat(ctx, h, expr);
-
-	return ret;
+		return netlink_del_setelems_compat(ctx, h, expr);
 }
 
 static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
-- 
2.1.0

