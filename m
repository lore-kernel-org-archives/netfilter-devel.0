From: Hendrik Schwartke <hendrik@os-t.de>
Subject: [PATCH 1/2] Removed duplicated code in netlink.c
Date: Tue, 10 Jun 2014 16:54:46 +0200
Message-ID: <1402412087-9825-1-git-send-email-hendrik@os-t.de>
Cc: Hendrik Schwartke <hendrik@os-t.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:64856 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFJOzH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:55:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 src/netlink.c |  614 ++++++++++++++++-----------------------------------------
 1 file changed, 166 insertions(+), 448 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 2e7c572..1b174bd 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -473,179 +473,80 @@ void netlink_dump_chain(struct nft_chain *nlc)
 #endif
 }
 
-static int netlink_add_chain_compat(struct netlink_ctx *ctx,
-				    const struct handle *h,
-				    const struct location *loc,
-				    const struct chain *chain, bool excl)
-{
-	struct nft_chain *nlc;
-	int err;
-
-	nlc = alloc_nft_chain(h);
-	if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
-		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
-				       chain->hooknum);
-		nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
-				       chain->priority);
-		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
-				       chain->type);
-	}
-	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(nf_sock, nlc, excl ? NLM_F_EXCL : 0);
-	nft_chain_free(nlc);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not add chain: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_add_chain_batch(struct netlink_ctx *ctx,
-				   const struct handle *h,
-				   const struct location *loc,
-				   const struct chain *chain, bool excl)
-{
-	struct nft_chain *nlc;
-	int err;
-
-	nlc = alloc_nft_chain(h);
-	if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
-		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
-				       chain->hooknum);
-		nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
-				       chain->priority);
-		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
-				       chain->type);
-	}
-	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_add(nf_sock, nlc, excl ? NLM_F_EXCL : 0,
-				      ctx->seqnum);
-	nft_chain_free(nlc);
-
-	if (err < 0) {
-		netlink_io_error(ctx, loc, "Could not add chain: %s",
-				 strerror(errno));
-	}
-	return err;
-}
-
 int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc, const struct chain *chain,
 		      bool excl)
 {
-	int ret;
-
-	if (ctx->batch_supported)
-		ret = netlink_add_chain_batch(ctx, h, loc, chain, excl);
-	else
-		ret = netlink_add_chain_compat(ctx, h, loc, chain, excl);
-
-	return ret;
-}
-
-static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
-				       const struct handle *h,
-				       const struct location *loc,
-				       const char *name)
-{
-	struct nft_chain *nlc;
-	int err;
-
-	nlc = alloc_nft_chain(h);
-	nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_NAME, name);
-	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_add(nf_sock, nlc, 0);
-	nft_chain_free(nlc);
 
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not rename chain: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
-				      const struct handle *h,
-				      const struct location *loc,
-				      const char *name)
-{
-	struct nft_chain *nlc;
-	int err;
-
-	nlc = alloc_nft_chain(h);
-	nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_NAME, name);
-	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_add(nf_sock, nlc, 0, ctx->seqnum);
-	nft_chain_free(nlc);
-
-	if (err < 0) {
-		netlink_io_error(ctx, loc, "Could not rename chain: %s",
-				 strerror(errno));
-	}
-	return err;
+        struct nft_chain *nlc;
+        int err;
+        unsigned int flags = excl ? NLM_F_EXCL : 0;
+
+        nlc = alloc_nft_chain(h);
+        if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
+                nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
+                                       chain->hooknum);
+                nft_chain_attr_set_s32(nlc, NFT_CHAIN_ATTR_PRIO,
+                                       chain->priority);
+                nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
+                                       chain->type);
+        }
+        netlink_dump_chain(nlc);
+        if (ctx->batch_supported)
+                err = mnl_nft_chain_batch_add(nf_sock, nlc, flags,
+                                              ctx->seqnum);
+        else
+                err = mnl_nft_chain_add(nf_sock, nlc, flags);
+        nft_chain_free(nlc);
+
+        if (err < 0) {
+                netlink_io_error(ctx, loc, "Could not add chain: %s",
+                                 strerror(errno));
+        }
+        return err;
 }
 
 int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc, const char *name)
 {
-	int ret;
-
-	if (ctx->batch_supported)
-		ret = netlink_rename_chain_batch(ctx, h, loc, name);
-	else
-		ret = netlink_rename_chain_compat(ctx, h, loc, name);
-
-	return ret;
-}
-
-static int netlink_del_chain_compat(struct netlink_ctx *ctx,
-				    const struct handle *h,
-				    const struct location *loc)
-{
-	struct nft_chain *nlc;
-	int err;
-
-	nlc = alloc_nft_chain(h);
-	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_delete(nf_sock, nlc, 0);
-	nft_chain_free(nlc);
-
-	if (err < 0) {
-		netlink_io_error(ctx, loc, "Could not delete chain: %s",
-				 strerror(errno));
-	}
-	return err;
-}
-
-static int netlink_del_chain_batch(struct netlink_ctx *ctx,
-				   const struct handle *h,
-				   const struct location *loc)
-{
-	struct nft_chain *nlc;
-	int err;
+        struct nft_chain *nlc;
+        int err;
 
-	nlc = alloc_nft_chain(h);
-	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_del(nf_sock, nlc, 0, ctx->seqnum);
-	nft_chain_free(nlc);
+        nlc = alloc_nft_chain(h);
+        nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_NAME, name);
+        netlink_dump_chain(nlc);
+        if (ctx->batch_supported)
+                err = mnl_nft_chain_batch_add(nf_sock, nlc, 0, ctx->seqnum);
+        else
+                err = mnl_nft_chain_add(nf_sock, nlc, 0);
+        nft_chain_free(nlc);
 
-	if (err < 0) {
-		netlink_io_error(ctx, loc, "Could not delete chain: %s",
-				 strerror(errno));
-	}
-	return err;
+        if (err < 0)
+                netlink_io_error(ctx, loc, "Could not rename chain: %s",
+                                 strerror(errno));
+        return err;
 }
 
 int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc)
 {
-	int ret;
+	struct nft_chain *nlc;
+        int err;
 
-	if (ctx->batch_supported)
-		ret = netlink_del_chain_batch(ctx, h, loc);
-	else
-		ret = netlink_del_chain_compat(ctx, h, loc);
+        nlc = alloc_nft_chain(h);
+        netlink_dump_chain(nlc);
+        if (ctx->batch_supported)
+                err = mnl_nft_chain_batch_del(nf_sock, nlc, 0, ctx->seqnum);
+        else
+                err = mnl_nft_chain_delete(nf_sock, nlc, 0);
+		
+        nft_chain_free(nlc);
 
-	return ret;
+        if (err < 0) {
+                netlink_io_error(ctx, loc, "Could not delete chain: %s",
+                                 strerror(errno));
+        }
+        return err;
 }
 
 static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
@@ -762,104 +663,45 @@ int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 	return netlink_del_rule_batch(ctx, h, loc);
 }
 
-static int netlink_add_table_compat(struct netlink_ctx *ctx,
-				    const struct handle *h,
-				    const struct location *loc,
-				    const struct table *table, bool excl)
-{
-	struct nft_table *nlt;
-	int err;
-
-	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_add(nf_sock, nlt, excl ? NLM_F_EXCL : 0);
-	nft_table_free(nlt);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not add table: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_add_table_batch(struct netlink_ctx *ctx,
-				   const struct handle *h,
-				   const struct location *loc,
-				   const struct table *table, bool excl)
-{
-	struct nft_table *nlt;
-	int err;
-
-	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_batch_add(nf_sock, nlt, excl ? NLM_F_EXCL : 0,
-				      ctx->seqnum);
-	nft_table_free(nlt);
-
-	if (err < 0) {
-		netlink_io_error(ctx, loc, "Could not add table: %s",
-				 strerror(errno));
-	}
-	return err;
-}
-
 int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
 		      const struct location *loc,
 		      const struct table *table, bool excl)
 {
-	int ret;
+        struct nft_table *nlt;
+        int err;
+        unsigned int flags = excl ? NLM_F_EXCL : 0;
 
-	if (ctx->batch_supported)
-		ret = netlink_add_table_batch(ctx, h, loc, table, excl);
-	else
-		ret = netlink_add_table_compat(ctx, h, loc, table, excl);
+        nlt = alloc_nft_table(h);
+        if (ctx->batch_supported)
+                err = mnl_nft_table_batch_add(nf_sock, nlt, flags,
+                                              ctx->seqnum);
+        else
+                err = mnl_nft_table_add(nf_sock, nlt, flags);
+        nft_table_free(nlt);
 
-	return ret;
-}
-
-static int netlink_del_table_compat(struct netlink_ctx *ctx,
-				    const struct handle *h,
-				    const struct location *loc)
-{
-	struct nft_table *nlt;
-	int err;
-
-	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_delete(nf_sock, nlt, 0);
-	nft_table_free(nlt);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not delete table: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_del_table_batch(struct netlink_ctx *ctx,
-				   const struct handle *h,
-				   const struct location *loc)
-{
-	struct nft_table *nlt;
-	int err;
-
-	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_batch_del(nf_sock, nlt, 0, ctx->seqnum);
-	nft_table_free(nlt);
-
-	if (err < 0) {
-		netlink_io_error(ctx, loc, "Could not delete table: %s",
-				 strerror(errno));
-	}
-	return err;
+        if (err < 0)
+                netlink_io_error(ctx, loc, "Could not add table: %s",
+                                 strerror(errno));
+        return err;
 }
 
 int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct location *loc)
 {
-	int ret;
+        struct nft_table *nlt;
+        int err;
 
-	if (ctx->batch_supported)
-		ret = netlink_del_table_batch(ctx, h, loc);
-	else
-		ret = netlink_del_table_compat(ctx, h, loc);
+        nlt = alloc_nft_table(h);
+        if (ctx->batch_supported)
+                err = mnl_nft_table_batch_del(nf_sock, nlt, 0, ctx->seqnum);
+        else
+                err = mnl_nft_table_delete(nf_sock, nlt, 0);
+        nft_table_free(nlt);
 
-	return ret;
+        if (err < 0)
+                netlink_io_error(ctx, loc, "Could not delete table: %s",
+                                 strerror(errno));
+        return err;
 }
 
 void netlink_dump_table(struct nft_table *nlt)
@@ -1030,131 +872,68 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	return set;
 }
 
-static int netlink_add_set_compat(struct netlink_ctx *ctx,
-				  const struct handle *h, struct set *set)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_FLAGS, set->flags);
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_TYPE,
-			     dtype_map_to_kernel(set->keytype));
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_LEN,
-			     set->keylen / BITS_PER_BYTE);
-	if (set->flags & NFT_SET_MAP) {
-		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_TYPE,
-				     dtype_map_to_kernel(set->datatype));
-		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_LEN,
-				     set->datalen / BITS_PER_BYTE);
-	}
-	netlink_dump_set(nls);
-
-	err = mnl_nft_set_add(nf_sock, nls, NLM_F_EXCL | NLM_F_ECHO);
-	if (err < 0)
-		netlink_io_error(ctx, &set->location, "Could not add set: %s",
-				 strerror(errno));
-
-	set->handle.set =
-		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
-	nft_set_free(nls);
-
-	return err;
-}
-
-/* internal ID to uniquely identify a set in the batch */
-static uint32_t set_id;
-
-static int netlink_add_set_batch(struct netlink_ctx *ctx,
-				 const struct handle *h, struct set *set)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_FLAGS, set->flags);
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_TYPE,
-			     dtype_map_to_kernel(set->keytype));
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_LEN,
-			     set->keylen / BITS_PER_BYTE);
-	if (set->flags & NFT_SET_MAP) {
-		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_TYPE,
-				     dtype_map_to_kernel(set->datatype));
-		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_LEN,
-				     set->datalen / BITS_PER_BYTE);
-	}
-	set->handle.set_id = ++set_id;
-	nft_set_attr_set_u32(nls, NFT_SET_ATTR_ID, set->handle.set_id);
-	netlink_dump_set(nls);
-
-	err = mnl_nft_set_batch_add(nf_sock, nls, NLM_F_EXCL, ctx->seqnum);
-	if (err < 0) {
-		netlink_io_error(ctx, &set->location, "Could not add set: %s",
-				 strerror(errno));
-	}
-	nft_set_free(nls);
-
-	return err;
-}
-
 int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		    struct set *set)
 {
-	int ret;
-
-	if (ctx->batch_supported)
-		ret = netlink_add_set_batch(ctx, h, set);
-	else
-		ret = netlink_add_set_compat(ctx, h, set);
-
-	return ret;
-}
-
-static int netlink_del_set_compat(struct netlink_ctx *ctx,
-				  const struct handle *h,
-				  const struct location *loc)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	err = mnl_nft_set_delete(nf_sock, nls, 0);
-	nft_set_free(nls);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not delete set: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_del_set_batch(struct netlink_ctx *ctx,
-				 const struct handle *h,
-				 const struct location *loc)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	err = mnl_nft_set_batch_del(nf_sock, nls, 0, ctx->seqnum);
-	nft_set_free(nls);
-
-	if (err < 0)
-		netlink_io_error(ctx, loc, "Could not delete set: %s",
-				 strerror(errno));
-	return err;
+        struct nft_set *nls;
+        int err;
+
+        nls = alloc_nft_set(h);
+        nft_set_attr_set_u32(nls, NFT_SET_ATTR_FLAGS, set->flags);
+        nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_TYPE,
+                             dtype_map_to_kernel(set->keytype));
+        nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_LEN,
+                             set->keylen / BITS_PER_BYTE);
+        if (set->flags & NFT_SET_MAP) {
+                nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_TYPE,
+                                     dtype_map_to_kernel(set->datatype));
+                nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_LEN,
+                                     set->datalen / BITS_PER_BYTE);
+        }
+
+        if (ctx->batch_supported) {
+                /* internal ID to uniquely identify a set in the batch */
+                static uint32_t set_id = 0;
+
+                set->handle.set_id = ++set_id;
+                nft_set_attr_set_u32(nls, NFT_SET_ATTR_ID, set->handle.set_id);
+                netlink_dump_set(nls);
+                err = mnl_nft_set_batch_add(nf_sock, nls, NLM_F_EXCL,
+                                            ctx->seqnum);
+        } else {
+                netlink_dump_set(nls);
+                err = mnl_nft_set_add(nf_sock, nls, NLM_F_EXCL | NLM_F_ECHO);
+                set->handle.set =
+                        xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
+        }
+
+        if (err < 0) {
+                netlink_io_error(ctx, &set->location, "Could not add set: %s",
+                                 strerror(errno));
+        }
+        nft_set_free(nls);
+
+        return err;
 }
 
 int netlink_delete_set(struct netlink_ctx *ctx, const struct handle *h,
 		       const struct location *loc)
 {
-	int ret;
 
-	if (ctx->batch_supported)
-		ret = netlink_del_set_batch(ctx, h, loc);
-	else
-		ret = netlink_del_set_compat(ctx, h, loc);
+        struct nft_set *nls;
+        int err;
 
-	return ret;
+        nls = alloc_nft_set(h);
+        if (ctx->batch_supported)
+                err = mnl_nft_set_batch_del(nf_sock, nls, 0, ctx->seqnum);
+        else
+                err = mnl_nft_set_delete(nf_sock, nls, 0);
+        nft_set_free(nls);
+
+        if (err < 0)
+                netlink_io_error(ctx, loc, "Could not delete set: %s",
+                                 strerror(errno));
+        return err;
 }
 
 static int list_set_cb(struct nft_set *nls, void *arg)
@@ -1217,97 +996,27 @@ static void alloc_setelem_cache(const struct expr *set, struct nft_set *nls)
 	}
 }
 
-static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
-				      const struct handle *h,
-				      const struct expr *expr)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
-
-	err = mnl_nft_setelem_batch_add(nf_sock, nls, 0, ctx->seqnum);
-	nft_set_free(nls);
-	if (err < 0)
-		netlink_io_error(ctx, &expr->location,
-				 "Could not add set elements: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
-				       const struct handle *h,
-				       const struct expr *expr)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
-
-	err = mnl_nft_setelem_add(nf_sock, nls, 0);
-	nft_set_free(nls);
-	if (err < 0)
-		netlink_io_error(ctx, &expr->location,
-				 "Could not add set elements: %s",
-				 strerror(errno));
-	return err;
-}
-
 int netlink_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			 const struct expr *expr)
 {
-	int ret;
+        struct nft_set *nls;
+        int err;
 
-	if (ctx->batch_supported)
-		ret = netlink_add_setelems_batch(ctx, h, expr);
-	else
-		ret = netlink_add_setelems_compat(ctx, h, expr);
+        nls = alloc_nft_set(h);
+        alloc_setelem_cache(expr, nls);
+        netlink_dump_set(nls);
 
-	return ret;
-}
-
-static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
-				      const struct handle *h,
-				      const struct expr *expr)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
-
-	err = mnl_nft_setelem_batch_del(nf_sock, nls, 0, ctx->seqnum);
-	nft_set_free(nls);
-	if (err < 0)
-		netlink_io_error(ctx, &expr->location,
-				 "Could not delete set elements: %s",
-				 strerror(errno));
-	return err;
-}
-
-static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
-				       const struct handle *h,
-				       const struct expr *expr)
-{
-	struct nft_set *nls;
-	int err;
-
-	nls = alloc_nft_set(h);
-	alloc_setelem_cache(expr, nls);
-	netlink_dump_set(nls);
-
-	err = mnl_nft_setelem_delete(nf_sock, nls, 0);
-	nft_set_free(nls);
-	if (err < 0)
-		netlink_io_error(ctx, &expr->location,
-				 "Could not delete set elements: %s",
-				 strerror(errno));
-	return err;
+        if (ctx->batch_supported)
+                err = mnl_nft_setelem_batch_add(nf_sock, nls, 0,
+                                                ctx->seqnum);
+        else
+                err = mnl_nft_setelem_add(nf_sock, nls, 0);
+        nft_set_free(nls);
+        if (err < 0)
+                netlink_io_error(ctx, &expr->location,
+                                 "Could not add set elements: %s",
+                                 strerror(errno));
+        return err;
 }
 
 static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
@@ -1360,14 +1069,23 @@ out:
 int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			    const struct expr *expr)
 {
-	int ret;
-
-	if (ctx->batch_supported)
-		ret = netlink_del_setelems_batch(ctx, h, expr);
-	else
-		ret = netlink_del_setelems_compat(ctx, h, expr);
-
-	return ret;
+        struct nft_set *nls;
+        int err;
+
+        nls = alloc_nft_set(h);
+        alloc_setelem_cache(expr, nls);
+        netlink_dump_set(nls);
+
+        if (ctx->batch_supported)
+                err = mnl_nft_setelem_batch_del(nf_sock, nls, 0, ctx->seqnum);
+        else
+                err = mnl_nft_setelem_delete(nf_sock, nls, 0);
+        nft_set_free(nls);
+        if (err < 0)
+                netlink_io_error(ctx, &expr->location,
+                                 "Could not delete set elements: %s",
+                                 strerror(errno));
+        return err;
 }
 
 static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
-- 
1.7.10.4

