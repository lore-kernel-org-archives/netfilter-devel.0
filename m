Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F79C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 13:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358190AbhLBNPk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 08:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239530AbhLBNPZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 08:15:25 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D82C0613DD
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Dec 2021 05:11:57 -0800 (PST)
Received: from localhost ([::1]:37968 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mslsS-0001Vj-81; Thu, 02 Dec 2021 14:11:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 4/5] cache: Filter set list on server side
Date:   Thu,  2 Dec 2021 14:11:35 +0100
Message-Id: <20211202131136.29242-5-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202131136.29242-1-phil@nwl.cc>
References: <20211202131136.29242-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fetch either all tables' sets at once, a specific table's sets or even a
specific set if needed instead of iterating over the list of previously
fetched tables and fetching for each, then ignoring anything returned
that doesn't match the filter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Catch ENOENT instead of speculating about the error cause.
---
 include/mnl.h |  2 +-
 src/cache.c   | 63 ++++++++++++++++++++++++++++++---------------------
 src/mnl.c     | 15 ++++++++----
 3 files changed, 49 insertions(+), 31 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 9d54aac876dc1..8659879c17f44 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -58,7 +58,7 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 int mnl_nft_set_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
 struct nftnl_set_list *mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
-					const char *table);
+					const char *table, const char *set);
 
 int mnl_nft_setelem_add(struct netlink_ctx *ctx, const struct set *set,
 			const struct expr *expr, unsigned int flags);
diff --git a/src/cache.c b/src/cache.c
index 1e98e6cf7cc17..38a34ee3c406f 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -487,57 +487,66 @@ static int rule_cache_init(struct netlink_ctx *ctx, const struct handle *h,
 struct set_cache_dump_ctx {
 	struct netlink_ctx	*nlctx;
 	struct table		*table;
-	const struct nft_cache_filter *filter;
 };
 
 static int set_cache_cb(struct nftnl_set *nls, void *arg)
 {
 	struct set_cache_dump_ctx *ctx = arg;
+	const char *set_table;
 	const char *set_name;
+	uint32_t set_family;
 	struct set *set;
 	uint32_t hash;
 
+	set_table = nftnl_set_get_str(nls, NFTNL_SET_TABLE);
+	set_family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
+
+	if (set_family != ctx->table->handle.family ||
+	    strcmp(set_table, ctx->table->handle.table.name))
+		return 0;
+
 	set = netlink_delinearize_set(ctx->nlctx, nls);
 	if (!set)
 		return -1;
 
-	if (ctx->filter && ctx->filter->list.set &&
-	    (ctx->filter->list.family != set->handle.family ||
-	     strcmp(ctx->filter->list.table, set->handle.table.name) ||
-	     strcmp(ctx->filter->list.set, set->handle.set.name))) {
-		set_free(set);
-		return 0;
-	}
-
 	set_name = nftnl_set_get_str(nls, NFTNL_SET_NAME);
 	hash = djb_hash(set_name) % NFT_CACHE_HSIZE;
 	cache_add(&set->cache, &ctx->table->set_cache, hash);
 
+	nftnl_set_list_del(nls);
+	nftnl_set_free(nls);
 	return 0;
 }
 
 static int set_cache_init(struct netlink_ctx *ctx, struct table *table,
-			  struct nftnl_set_list *set_list,
-			  const struct nft_cache_filter *filter)
+			  struct nftnl_set_list *set_list)
 {
 	struct set_cache_dump_ctx dump_ctx = {
 		.nlctx	= ctx,
 		.table	= table,
-		.filter = filter,
 	};
+
 	nftnl_set_list_foreach(set_list, set_cache_cb, &dump_ctx);
 
 	return 0;
 }
 
-static struct nftnl_set_list *set_cache_dump(struct netlink_ctx *ctx,
-					     const struct table *table,
-					     int *err)
+static struct nftnl_set_list *
+set_cache_dump(struct netlink_ctx *ctx,
+	       const struct nft_cache_filter *filter, int *err)
 {
 	struct nftnl_set_list *set_list;
+	int family = NFPROTO_UNSPEC;
+	const char *table = NULL;
+	const char *set = NULL;
+
+	if (filter) {
+		family = filter->list.family;
+		table = filter->list.table;
+		set = filter->list.set;
+	}
 
-	set_list = mnl_nft_set_dump(ctx, table->handle.family,
-				    table->handle.table.name);
+	set_list = mnl_nft_set_dump(ctx, family, table, set);
 	if (!set_list) {
                 if (errno == EINTR) {
 			*err = -1;
@@ -785,18 +794,17 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 		if (!chain_list)
 			return -1;
 	}
+	if (flags & NFT_CACHE_SET_BIT) {
+		set_list = set_cache_dump(ctx, filter, &ret);
+		if (!set_list) {
+			ret = -1;
+			goto cache_fails;
+		}
+	}
 
 	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (flags & NFT_CACHE_SET_BIT) {
-			set_list = set_cache_dump(ctx, table, &ret);
-			if (!set_list) {
-				ret = -1;
-				goto cache_fails;
-			}
-			ret = set_cache_init(ctx, table, set_list, filter);
-
-			nftnl_set_list_free(set_list);
-
+			ret = set_cache_init(ctx, table, set_list);
 			if (ret < 0) {
 				ret = -1;
 				goto cache_fails;
@@ -893,6 +901,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 	}
 
 cache_fails:
+	if (set_list)
+		nftnl_set_list_free(set_list);
+
 	if (flags & NFT_CACHE_CHAIN_BIT)
 		nftnl_chain_list_free(chain_list);
 
diff --git a/src/mnl.c b/src/mnl.c
index 109c3dd81e578..47b3ca613e419 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1300,10 +1300,12 @@ err_free:
 }
 
 struct nftnl_set_list *
-mnl_nft_set_dump(struct netlink_ctx *ctx, int family, const char *table)
+mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
+		 const char *table, const char *set)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_set_list *nls_list;
+	int flags = NLM_F_DUMP;
 	struct nlmsghdr *nlh;
 	struct nftnl_set *s;
 	int ret;
@@ -1312,10 +1314,15 @@ mnl_nft_set_dump(struct netlink_ctx *ctx, int family, const char *table)
 	if (s == NULL)
 		memory_allocation_error();
 
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
-				    NLM_F_DUMP, ctx->seqnum);
 	if (table != NULL)
 		nftnl_set_set_str(s, NFTNL_SET_TABLE, table);
+	if (set) {
+		nftnl_set_set_str(s, NFTNL_SET_NAME, set);
+		flags = NLM_F_ACK;
+	}
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
+				    flags, ctx->seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, s);
 	nftnl_set_free(s);
 
@@ -1324,7 +1331,7 @@ mnl_nft_set_dump(struct netlink_ctx *ctx, int family, const char *table)
 		memory_allocation_error();
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_cb, nls_list);
-	if (ret < 0)
+	if (ret < 0 && errno != ENOENT)
 		goto err;
 
 	return nls_list;
-- 
2.33.0

