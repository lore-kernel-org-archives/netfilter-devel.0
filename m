From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft RFC PATCH 3/6] netlink: add netlink_delinearize_set() func
Date: Tue, 18 Feb 2014 00:18:22 +0100
Message-ID: <20140217231822.19943.3523.stgit@nfdev.cica.es>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39325 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754308AbaBQXSa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:18:30 -0500
In-Reply-To: <20140217231654.19943.18736.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's factorize this code, so it can be reused.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/netlink.h         |    4 ++++
 src/netlink.c             |   22 ++--------------------
 src/netlink_delinearize.c |   27 +++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 4e3f8aa..13d01f0 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -70,6 +70,10 @@ extern int netlink_linearize_rule(struct netlink_ctx *ctx,
 extern struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 					     const struct nft_rule *r);
 
+extern const struct datatype *dtype_map_from_kernel(enum nft_data_types type);
+
+extern struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
+					   struct nft_set *nls);
 extern int netlink_add_rule(struct netlink_ctx *ctx, const struct handle *h,
 			    const struct rule *rule, uint32_t flags);
 extern int netlink_delete_rule(struct netlink_ctx *ctx, const struct handle *h,
diff --git a/src/netlink.c b/src/netlink.c
index 07af1cb..ea6611a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -731,7 +731,7 @@ static enum nft_data_types dtype_map_to_kernel(const struct datatype *dtype)
 	}
 }
 
-static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
+const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 {
 	switch (type) {
 	case NFT_DATA_VERDICT:
@@ -870,7 +870,6 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 		    const struct location *loc)
 {
 	struct nft_set *nls;
-	struct set *set;
 	int err;
 
 	nls = alloc_nft_set(h);
@@ -881,24 +880,7 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 					"Could not receive set from kernel: %s",
 					strerror(errno));
 
-	set = set_alloc(&netlink_location);
-	set->handle.family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
-	set->handle.table  =
-		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE));
-	set->handle.set    =
-		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
-	set->keytype       =
-		 dtype_map_from_kernel(nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_TYPE));
-	set->keylen        =
-		nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_LEN) * BITS_PER_BYTE;
-	set->flags         = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
-	set->datatype      =
-		dtype_map_from_kernel(nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_TYPE));
-	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DATA_LEN)) {
-		set->datalen =
-			nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_LEN) * BITS_PER_BYTE;
-	}
-	list_add_tail(&set->list, &ctx->list);
+	netlink_delinearize_set(ctx, nls);
 	nft_set_free(nls);
 
 	return err;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0e75c8a..65d1c80 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -895,3 +895,30 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	rule_parse_postprocess(pctx, pctx->rule);
 	return pctx->rule;
 }
+
+struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
+				    struct nft_set *nls)
+{
+	struct set *set;
+
+	set = set_alloc(&internal_location);
+	set->handle.family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
+	set->handle.table  =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE));
+	set->handle.set    =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
+	set->keytype       =
+		 dtype_map_from_kernel(nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_TYPE));
+	set->keylen        =
+		nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_LEN) * BITS_PER_BYTE;
+	set->flags         = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
+	set->datatype      =
+		dtype_map_from_kernel(nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_TYPE));
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DATA_LEN)) {
+		set->datalen =
+			nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_LEN) * BITS_PER_BYTE;
+	}
+	list_add_tail(&set->list, &ctx->list);
+
+	return set;
+}

