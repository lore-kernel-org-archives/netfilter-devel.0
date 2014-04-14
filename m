From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/8] netlink: add netlink_delinearize_set() func
Date: Mon, 14 Apr 2014 12:17:14 +0200
Message-ID: <20140414101714.5018.89872.stgit@nfdev.cica.es>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42755 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751493AbaDNKRQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:17:16 -0400
In-Reply-To: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's factorize this code, so it can be reused.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |  112 +++++++++++++++++++++++++++------------------------------
 1 file changed, 53 insertions(+), 59 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index daac64c..e7b3ec1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -755,6 +755,57 @@ void netlink_dump_set(struct nft_set *nls)
 #endif
 }
 
+static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
+					   struct nft_set *nls)
+{
+	struct set *set;
+	const struct datatype *keytype, *datatype;
+	uint32_t flags, key, data, data_len;
+
+	key = nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_TYPE);
+	keytype = dtype_map_from_kernel(key);
+	if (keytype == NULL) {
+		netlink_io_error(ctx, NULL, "Unknown data type in set key %u",
+				 key);
+		return NULL;
+	}
+
+	flags = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
+	if (flags & NFT_SET_MAP) {
+		data = nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_TYPE);
+		datatype = dtype_map_from_kernel(data);
+		if (datatype == NULL) {
+			netlink_io_error(ctx, NULL,
+					 "Unknown data type in set key %u",
+					 data);
+			return NULL;
+		}
+	} else
+		datatype = NULL;
+
+	set = set_alloc(&netlink_location);
+	set->handle.family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
+	set->handle.table  =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE));
+	set->handle.set    =
+		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
+
+	set->keytype = keytype;
+	set->keylen        =
+		nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_LEN) * BITS_PER_BYTE;
+
+	set->flags         = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
+
+	set->datatype = datatype;
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
@@ -806,48 +857,9 @@ int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
 static int list_set_cb(struct nft_set *nls, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
-	const struct datatype *keytype, *datatype;
-	uint32_t flags, key, data;
-	struct set *set;
 
 	netlink_dump_set(nls);
-	key = nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_TYPE);
-	keytype = dtype_map_from_kernel(key);
-	if (keytype == NULL) {
-		netlink_io_error(ctx, NULL, "Unknown data type in set key %u",
-				 key);
-		return -1;
-	}
-
-	flags = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
-	if (flags & NFT_SET_MAP) {
-		data = nft_set_attr_get_u32(nls, NFT_SET_ATTR_DATA_TYPE);
-		datatype = dtype_map_from_kernel(data);
-		if (datatype == NULL) {
-			netlink_io_error(ctx, NULL, "Unknown data type in set key %u",
-					 data);
-			return -1;
-		}
-	} else
-		datatype = NULL;
-
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
 
@@ -871,7 +883,6 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 		    const struct location *loc)
 {
 	struct nft_set *nls;
-	struct set *set;
 	int err;
 
 	nls = alloc_nft_set(h);
@@ -882,24 +893,7 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
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

