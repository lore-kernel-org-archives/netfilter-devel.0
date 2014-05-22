From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] netlink: don't add table/chain/set to ctx->list in the event path
Date: Thu, 22 May 2014 17:17:17 +0200
Message-ID: <1400771837-7670-2-git-send-email-pablo@netfilter.org>
References: <1400771837-7670-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33361 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaEVPR2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2014 11:17:28 -0400
In-Reply-To: <1400771837-7670-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The delinearize functions for tables, chains and sets add these objects
to the ctx->list. In the chain case, this is not required. Regarding
tables and sets, those are added to the cache.

This patch implicitly fixes an use chain object after free that result
in random crashes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index e130767..db42884 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -671,7 +671,6 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 			xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
 		chain->flags        |= CHAIN_F_BASECHAIN;
 	}
-	list_add_tail(&chain->list, &ctx->list);
 
 	return chain;
 }
@@ -682,6 +681,7 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 	const struct handle *h = ctx->data;
 	const char *table = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE);
 	const char *name = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME);
+	struct chain *chain;
 
 	if ((h->family != nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY)) ||
 	    strcmp(table, h->table) != 0)
@@ -690,7 +690,9 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 	if (h->chain && strcmp(name, h->chain) != 0)
 		return 0;
 
-	netlink_delinearize_chain(ctx, nlc);
+	chain = netlink_delinearize_chain(ctx, nlc);
+	list_add_tail(&chain->list, &ctx->list);
+
 	return 0;
 }
 
@@ -730,12 +732,14 @@ int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc)
 {
 	struct nft_chain *nlc;
+	struct chain *chain;
 	int err;
 
 	nlc = alloc_nft_chain(h);
 	err = mnl_nft_chain_get(nf_sock, nlc, 0);
 
-	netlink_delinearize_chain(ctx, nlc);
+	chain = netlink_delinearize_chain(ctx, nlc);
+	list_add_tail(&chain->list, &ctx->list);
 	nft_chain_free(nlc);
 
 	if (err < 0)
@@ -881,7 +885,6 @@ static struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 		nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
 	table->handle.table  =
 		xstrdup(nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME));
-	list_add_tail(&table->list, &ctx->list);
 
 	return table;
 }
@@ -889,8 +892,10 @@ static struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 static int list_table_cb(struct nft_table *nlt, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
+	struct table *table;
 
-	netlink_delinearize_table(ctx, nlt);
+	table = netlink_delinearize_table(ctx, nlt);
+	list_add_tail(&table->list, &ctx->list);
 
 	return 0;
 }
@@ -1020,7 +1025,6 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		data_len = nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_LEN);
 		set->datalen = data_len * BITS_PER_BYTE;
 	}
-	list_add_tail(&set->list, &ctx->list);
 
 	return set;
 }
@@ -1155,9 +1159,11 @@ int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
 static int list_set_cb(struct nft_set *nls, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
+	struct set *set;
 
 	netlink_dump_set(nls);
-	netlink_delinearize_set(ctx, nls);
+	set = netlink_delinearize_set(ctx, nls);
+	list_add_tail(&set->list, &ctx->list);
 	return 0;
 }
 
@@ -1181,6 +1187,7 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 		    const struct location *loc)
 {
 	struct nft_set *nls;
+	struct set *set;
 	int err;
 
 	nls = alloc_nft_set(h);
@@ -1191,7 +1198,8 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 					"Could not receive set from kernel: %s",
 					strerror(errno));
 
-	netlink_delinearize_set(ctx, nls);
+	set = netlink_delinearize_set(ctx, nls);
+	list_add_tail(&set->list, &ctx->list);
 	nft_set_free(nls);
 
 	return err;
-- 
1.7.10.4

