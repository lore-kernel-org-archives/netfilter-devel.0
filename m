From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft RFC PATCH 5/6] netlink: add netlink_delinearize_rule() func
Date: Tue, 18 Feb 2014 00:18:32 +0100
Message-ID: <20140217231832.19943.65573.stgit@nfdev.cica.es>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39340 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754327AbaBQXSk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:18:40 -0500
In-Reply-To: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's make this code reusable.

Also, this patch fixes a hidden bug: the table in the chain's handle was being
set to the chain name.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/netlink.h         |    3 +++
 src/netlink.c             |   23 +----------------------
 src/netlink_delinearize.c |   30 ++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 13d01f0..1e6655c 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -74,6 +74,9 @@ extern const struct datatype *dtype_map_from_kernel(enum nft_data_types type);
 
 extern struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 					   struct nft_set *nls);
+extern struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
+					       struct nft_chain *nlc);
+
 extern int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
 			    const struct rule *rule, uint32_t flags);
 extern int netlink_delete_rule(struct netlink_ctx *ctx, const struct handle *h,
diff --git a/src/netlink.c b/src/netlink.c
index ea6611a..cd5e64a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -500,7 +500,6 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
 	const struct handle *h = ctx->data;
-	struct chain *chain;
 
 	if ((h->family != nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY)) ||
 	    strcmp(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE), h->table) != 0)
@@ -510,27 +509,7 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 	    strcmp(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME), h->chain) != 0)
 		return 0;
 
-	chain = chain_alloc(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
-	chain->handle.family =
-		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
-	chain->handle.table  =
-		xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
-	chain->handle.handle =
-		nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
-
-	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_HOOKNUM) &&
-	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_PRIO) &&
-	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE)) {
-		chain->hooknum       =
-			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
-		chain->priority      =
-			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
-		chain->type          =
-			xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TYPE));
-		chain->flags        |= CHAIN_F_BASECHAIN;
-	}
-	list_add_tail(&chain->list, &ctx->list);
-
+	netlink_delinearize_chain(ctx, nlc);
 	return 0;
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 65d1c80..5c5c4b1 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -922,3 +922,33 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 
 	return set;
 }
+
+struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
+					struct nft_chain *nlc)
+{
+	struct chain *chain;
+
+	chain = chain_alloc(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
+	chain->handle.family =
+		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
+	chain->handle.table  =
+		xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE));
+	chain->handle.handle =
+		nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
+
+	if (nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_HOOKNUM) &&
+	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_PRIO) &&
+	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_TYPE)) {
+		chain->hooknum       =
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
+		chain->priority      =
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_PRIO);
+		chain->type          =
+			xstrdup(nft_chain_attr_get_str(nlc,
+						       NFT_CHAIN_ATTR_TYPE));
+		chain->flags        |= CHAIN_F_BASECHAIN;
+	}
+	list_add_tail(&chain->list, &ctx->list);
+
+	return chain;
+}

