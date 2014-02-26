From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC PATCH v2 2/6] netlink: add netlink_delinearize_set() func
Date: Wed, 26 Feb 2014 17:09:54 +0100
Message-ID: <20140226160954.18974.57807.stgit@nfdev.cica.es>
References: <20140226160918.18974.64532.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60325 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751679AbaBZQJ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:09:57 -0500
In-Reply-To: <20140226160918.18974.64532.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's factorize this code, so it can be reused.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |   70 +++++++++++++++++++++++++++------------------------------
 1 file changed, 33 insertions(+), 37 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 2871888..74372bf 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -751,6 +751,37 @@ void netlink_dump_set(struct nft_set *nls)
 #endif
 }
 
+static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
+					   struct nft_set *nls)
+{
+	struct set *set;
+	uint32_t data_len, keytype, datatype;
+
+	set = set_alloc(&netlink_location);
+	set->handle.family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
+	set->handle.table  =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE));
+	set->handle.set    =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
+
+	keytype = nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_TYPE);
+	set->keytype = dtype_map_from_kernel(keytype);
+	set->keylen        =
+		nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_LEN) * BITS_PER_BYTE;
+
+	set->flags         = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
+
+	datatype = nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_LEN);
+	set->datatype = dtype_map_from_kernel(datatype);
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DATA_LEN)) {
+		data_len = nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_LEN);
+		set->datalen = data_len * BITS_PER_BYTE;
+	}
+	list_add_tail(&set->list, &ctx->list);
+
+	return set;
+}
+
 int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		    struct set *set)
 {
@@ -804,7 +835,6 @@ static int list_set_cb(struct nft_set *nls, void *arg)
 	struct netlink_ctx *ctx = arg;
 	const struct datatype *keytype, *datatype;
 	uint32_t flags, key, data;
-	struct set *set;
 
 	netlink_dump_set(nls);
 	key = nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_TYPE);
@@ -827,23 +857,7 @@ static int list_set_cb(struct nft_set *nls, void *arg)
 	} else
 		datatype = NULL;
 
-	set = set_alloc(&netlink_location);
-	set->handle.family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
-	set->handle.table  =
-		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE));
-	set->handle.set    =
-		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
-	set->keytype       = keytype;
-	set->keylen        =
-		nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_LEN) * BITS_PER_BYTE;
-	set->flags         = flags;
-	set->datatype      = datatype;
-	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DATA_LEN)) {
-		set->datalen =
-			nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_LEN) * BITS_PER_BYTE;
-	}
-	list_add_tail(&set->list, &ctx->list);
-
+	netlink_delinearize_set(ctx, nls);
 	return 0;
 }
 
@@ -867,7 +881,6 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 		    const struct location *loc)
 {
 	struct nft_set *nls;
-	struct set *set;
 	int err;
 
 	nls = alloc_nft_set(h);
@@ -878,24 +891,7 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
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

