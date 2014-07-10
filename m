From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netlink: check and handle errors from netlink_delinearize_set()
Date: Thu, 10 Jul 2014 12:22:33 +0200
Message-ID: <1404987753-9252-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43789 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaGJKWg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:22:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix segfaults when delinearizing the set fails and abort on error when
listing sets.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 2e7c572..987dd63 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1164,6 +1164,8 @@ static int list_set_cb(struct nft_set *nls, void *arg)
 
 	netlink_dump_set(nls);
 	set = netlink_delinearize_set(ctx, nls);
+	if (set == NULL)
+		return -1;
 	list_add_tail(&set->list, &ctx->list);
 	return 0;
 }
@@ -1172,6 +1174,7 @@ int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc)
 {
 	struct nft_set_list *set_cache;
+	int err;
 
 	set_cache = mnl_nft_set_dump(nf_sock, h->family, h->table);
 	if (set_cache == NULL)
@@ -1179,9 +1182,9 @@ int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 					"Could not receive sets from kernel: %s",
 					strerror(errno));
 
-	nft_set_list_foreach(set_cache, list_set_cb, ctx);
+	err = nft_set_list_foreach(set_cache, list_set_cb, ctx);
 	nft_set_list_free(set_cache);
-	return 0;
+	return err;
 }
 
 int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
@@ -1200,6 +1203,8 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 					strerror(errno));
 
 	set = netlink_delinearize_set(ctx, nls);
+	if (set == NULL)
+		return -1;
 	list_add_tail(&set->list, &ctx->list);
 	nft_set_free(nls);
 
@@ -1586,6 +1591,8 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 		if (type == NFT_MSG_NEWSET) {
 			printf("add ");
 			set = netlink_delinearize_set(monh->ctx, nls);
+			if (set == NULL)
+				return MNL_CB_ERROR;
 			set_print_plain(set);
 			set_free(set);
 		} else {
@@ -1770,6 +1777,8 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 	set_tmpctx.msgs = &msgs;
 
 	s = netlink_delinearize_set(&set_tmpctx, nls);
+	if (s == NULL)
+		return;
 	s->init = set_expr_alloc(monh->loc);
 
 	t = table_lookup(&s->handle);
-- 
1.9.3

