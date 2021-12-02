Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7875DC43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 13:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358202AbhLBNPo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 08:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbhLBNPb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 08:15:31 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5D8C061758
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Dec 2021 05:12:08 -0800 (PST)
Received: from localhost ([::1]:37980 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mslsc-0001Vw-Sh; Thu, 02 Dec 2021 14:12:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 3/5] cache: Filter chain list on kernel side
Date:   Thu,  2 Dec 2021 14:11:34 +0100
Message-Id: <20211202131136.29242-4-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202131136.29242-1-phil@nwl.cc>
References: <20211202131136.29242-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When operating on a specific chain, add payload to NFT_MSG_GETCHAIN so
kernel returns only relevant data. Since ENOENT is an expected return
code, do not treat this as error.

While being at it, improve code in chain_cache_cb() a bit:
- Check chain's family first, it is a less expensive check than
  comparing table names.
- Do not extract chain name of uninteresting chains.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Catch ENOENT instead of ignoring all errors for non-dump requests.
- Use NFPROTO_UNSPEC instead of AF_UNSPEC for default family value. No
  functional change, merely conformity.
---
 include/mnl.h |  3 ++-
 src/cache.c   | 38 +++++++++++++++++++-------------------
 src/mnl.c     | 21 ++++++++++++++++++---
 3 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 19faa651fdb91..9d54aac876dc1 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -43,7 +43,8 @@ int mnl_nft_chain_rename(struct netlink_ctx *ctx, const struct cmd *cmd,
 			 const struct chain *chain);
 
 struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
-					    int family);
+					    int family, const char *table,
+					    const char *chain);
 
 int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags);
diff --git a/src/cache.c b/src/cache.c
index 484efdb93862b..1e98e6cf7cc17 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -342,31 +342,23 @@ struct table *table_cache_find(const struct cache *cache,
 struct chain_cache_dump_ctx {
 	struct netlink_ctx	*nlctx;
 	struct table		*table;
-	const struct nft_cache_filter *filter;
 };
 
 static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 {
 	struct chain_cache_dump_ctx *ctx = arg;
-	const struct nft_cache_filter *filter = ctx->filter;
 	const char *chain_name, *table_name;
 	uint32_t hash, family;
 	struct chain *chain;
 
 	table_name = nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE);
-	chain_name = nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME);
 	family = nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY);
 
-	if (strcmp(table_name, ctx->table->handle.table.name) ||
-	    family != ctx->table->handle.family)
-		return 0;
-
-	if (filter && filter->list.table && filter->list.chain &&
-	    (filter->list.family != family ||
-	     strcmp(filter->list.table, table_name) ||
-	     strcmp(filter->list.chain, chain_name)))
+	if (family != ctx->table->handle.family ||
+	    strcmp(table_name, ctx->table->handle.table.name))
 		return 0;
 
+	chain_name = nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME);
 	hash = djb_hash(chain_name) % NFT_CACHE_HSIZE;
 	chain = netlink_delinearize_chain(ctx->nlctx, nlc);
 
@@ -383,25 +375,33 @@ static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 }
 
 static int chain_cache_init(struct netlink_ctx *ctx, struct table *table,
-			    struct nftnl_chain_list *chain_list,
-			    const struct nft_cache_filter *filter)
+			    struct nftnl_chain_list *chain_list)
 {
 	struct chain_cache_dump_ctx dump_ctx = {
 		.nlctx	= ctx,
 		.table	= table,
-		.filter	= filter,
 	};
 	nftnl_chain_list_foreach(chain_list, chain_cache_cb, &dump_ctx);
 
 	return 0;
 }
 
-static struct nftnl_chain_list *chain_cache_dump(struct netlink_ctx *ctx,
-						 int *err)
+static struct nftnl_chain_list *
+chain_cache_dump(struct netlink_ctx *ctx,
+		 const struct nft_cache_filter *filter, int *err)
 {
 	struct nftnl_chain_list *chain_list;
+	const char *table = NULL;
+	const char *chain = NULL;
+	int family = NFPROTO_UNSPEC;
+
+	if (filter && filter->list.table && filter->list.chain) {
+		family = filter->list.family;
+		table = filter->list.table;
+		chain = filter->list.chain;
+	}
 
-	chain_list = mnl_nft_chain_dump(ctx, AF_UNSPEC);
+	chain_list = mnl_nft_chain_dump(ctx, family, table, chain);
 	if (chain_list == NULL) {
 		if (errno == EINTR) {
 			*err = -1;
@@ -781,7 +781,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 	int ret = 0;
 
 	if (flags & NFT_CACHE_CHAIN_BIT) {
-		chain_list = chain_cache_dump(ctx, &ret);
+		chain_list = chain_cache_dump(ctx, filter, &ret);
 		if (!chain_list)
 			return -1;
 	}
@@ -834,7 +834,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			}
 		}
 		if (flags & NFT_CACHE_CHAIN_BIT) {
-			ret = chain_cache_init(ctx, table, chain_list, filter);
+			ret = chain_cache_init(ctx, table, chain_list);
 			if (ret < 0) {
 				ret = -1;
 				goto cache_fails;
diff --git a/src/mnl.c b/src/mnl.c
index 26f643fb282ea..109c3dd81e578 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -906,10 +906,12 @@ err_free:
 }
 
 struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
-					    int family)
+					    int family, const char *table,
+					    const char *chain)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_chain_list *nlc_list;
+	struct nftnl_chain *nlc = NULL;
 	struct nlmsghdr *nlh;
 	int ret;
 
@@ -917,11 +919,24 @@ struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
 	if (nlc_list == NULL)
 		memory_allocation_error();
 
+	if (table && chain) {
+		nlc = nftnl_chain_alloc();
+		if (!nlc)
+			memory_allocation_error();
+
+		nftnl_chain_set_str(nlc, NFTNL_CHAIN_TABLE, table);
+		nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, chain);
+	}
+
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
-				    NLM_F_DUMP, ctx->seqnum);
+				    nlc ? NLM_F_ACK : NLM_F_DUMP, ctx->seqnum);
+	if (nlc) {
+		nftnl_chain_nlmsg_build_payload(nlh, nlc);
+		nftnl_chain_free(nlc);
+	}
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
-	if (ret < 0)
+	if (ret < 0 && errno != ENOENT)
 		goto err;
 
 	return nlc_list;
-- 
2.33.0

