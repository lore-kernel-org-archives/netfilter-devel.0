From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 4/8] netlink: add netlink_delinearize_chain() func
Date: Mon, 14 Apr 2014 12:17:24 +0200
Message-ID: <20140414101724.5018.37509.stgit@nfdev.cica.es>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42767 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753360AbaDNKR1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:17:27 -0400
In-Reply-To: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's make this code reusable.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |   46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index e7b3ec1..91f1304 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -500,20 +500,11 @@ int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-static int list_chain_cb(struct nft_chain *nlc, void *arg)
+static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
+					       struct nft_chain *nlc)
 {
-	struct netlink_ctx *ctx = arg;
-	const struct handle *h = ctx->data;
 	struct chain *chain;
 
-	if ((h->family != nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY)) ||
-	    strcmp(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE), h->table) != 0)
-		return 0;
-
-	if (h->chain &&
-	    strcmp(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME), h->chain) != 0)
-		return 0;
-
 	chain = chain_alloc(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
 	chain->handle.family =
 		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
@@ -535,6 +526,24 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 	}
 	list_add_tail(&chain->list, &ctx->list);
 
+	return chain;
+}
+
+static int list_chain_cb(struct nft_chain *nlc, void *arg)
+{
+	struct netlink_ctx *ctx = arg;
+	const struct handle *h = ctx->data;
+	const char *table = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE);
+	const char *name = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME);
+
+	if ((h->family != nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY)) ||
+	    strcmp(table, h->table) != 0)
+		return 0;
+
+	if (h->chain && strcmp(name, h->chain) != 0)
+		return 0;
+
+	netlink_delinearize_chain(ctx, nlc);
 	return 0;
 }
 
@@ -574,25 +583,12 @@ int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc)
 {
 	struct nft_chain *nlc;
-	struct chain *chain;
 	int err;
 
 	nlc = alloc_nft_chain(h);
 	err = mnl_nft_chain_get(nf_sock, nlc, 0);
 
-	chain = chain_alloc(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
-	chain->handle.family = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
-	chain->handle.table  = xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE));
-	chain->handle.handle = nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
-	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE) &&
-	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_HOOKNUM) &&
-	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_PRIO)) {
-		chain->hooknum       = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
-		chain->priority      = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
-		chain->type          = xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
-	}
-	list_add_tail(&chain->list, &ctx->list);
-
+	netlink_delinearize_chain(ctx, nlc);
 	nft_chain_free(nlc);
 
 	if (err < 0)

