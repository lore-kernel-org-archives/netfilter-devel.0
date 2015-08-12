From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] netlink: don't call netlink_dump_*() from listing functions with --debug=netlink
Date: Wed, 12 Aug 2015 19:26:32 +0200
Message-ID: <1439400392-30875-2-git-send-email-pablo@netfilter.org>
References: <1439400392-30875-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56337 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbbHLRU0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Aug 2015 13:20:26 -0400
In-Reply-To: <1439400392-30875-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that we always retrieve the object list to build a cache before executing
the command, this results in fully listing of existing objects in the kernel.

This is confusing when adding a simple rule, so better not to call
netlink_dump_*() from listing functions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Applies on top of the cache-consolidation branch.

 src/netlink.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 0fb7b63..b71d04f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -913,7 +913,6 @@ static struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 {
 	struct table *table;
 
-	netlink_dump_table(nlt);
 	table = table_alloc();
 	table->handle.family =
 		nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
@@ -1226,7 +1225,6 @@ static int list_set_cb(struct nft_set *nls, void *arg)
 	struct netlink_ctx *ctx = arg;
 	struct set *set;
 
-	netlink_dump_set(nls);
 	set = netlink_delinearize_set(ctx, nls);
 	if (set == NULL)
 		return -1;
@@ -1263,7 +1261,6 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nls = alloc_nft_set(h);
-	netlink_dump_set(nls);
 	err = mnl_nft_set_get(nf_sock, nls);
 	if (err < 0) {
 		nft_set_free(nls);
@@ -1504,7 +1501,6 @@ int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	int err;
 
 	nls = alloc_nft_set(h);
-	netlink_dump_set(nls);
 
 	err = mnl_nft_setelem_get(nf_sock, nls);
 	if (err < 0) {
-- 
1.7.10.4

