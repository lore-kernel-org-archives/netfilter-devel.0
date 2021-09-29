Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAE0C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 16:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B76BD6141B
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Sep 2021 16:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245720AbhI2QzD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Sep 2021 12:55:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33924 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245180AbhI2QzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Sep 2021 12:55:02 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 808C363EBA
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Sep 2021 18:51:55 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: filter out sets and maps that are not requested
Date:   Wed, 29 Sep 2021 18:53:16 +0200
Message-Id: <20210929165316.607415-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not fetch set content for list commands that specify a
set name.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h |  1 +
 src/cache.c     | 23 +++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index b238c1cfe326..07c05bb50176 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -41,6 +41,7 @@ enum cache_level_flags {
 struct nft_cache_filter {
 	bool			enabled;
 	const char		*table;
+	const char		*set;
 };
 
 struct nft_cache;
diff --git a/src/cache.c b/src/cache.c
index 563860e82fb8..8289ca9c0bce 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -138,6 +138,15 @@ static unsigned int evaluate_cache_list(struct cmd *cmd, unsigned int flags,
 		}
 		flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
 		break;
+	case CMD_OBJ_SET:
+	case CMD_OBJ_MAP:
+		if (filter && cmd->handle.table.name) {
+			filter->table = cmd->handle.table.name;
+			filter->set = cmd->handle.set.name;
+			filter->enabled = true;
+		}
+		flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
+		break;
 	case CMD_OBJ_CHAINS:
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_CHAIN;
 		break;
@@ -343,6 +352,7 @@ struct chain *chain_cache_find(const struct table *table, const char *name)
 struct set_cache_dump_ctx {
 	struct netlink_ctx	*nlctx;
 	struct table		*table;
+	const struct nft_cache_filter *filter;
 };
 
 static int set_cache_cb(struct nftnl_set *nls, void *arg)
@@ -357,6 +367,13 @@ static int set_cache_cb(struct nftnl_set *nls, void *arg)
 		return -1;
 
 	set_name = nftnl_set_get_str(nls, NFTNL_SET_NAME);
+
+	if (ctx->filter && ctx->filter->enabled &&
+	    (strcmp(ctx->filter->set, set->handle.set.name))) {
+		set_free(set);
+		return 0;
+	}
+
 	hash = djb_hash(set_name) % NFT_CACHE_HSIZE;
 	cache_add(&set->cache, &ctx->table->set_cache, hash);
 
@@ -364,11 +381,13 @@ static int set_cache_cb(struct nftnl_set *nls, void *arg)
 }
 
 static int set_cache_init(struct netlink_ctx *ctx, struct table *table,
-			  struct nftnl_set_list *set_list)
+			  struct nftnl_set_list *set_list,
+			  const struct nft_cache_filter *filter)
 {
 	struct set_cache_dump_ctx dump_ctx = {
 		.nlctx	= ctx,
 		.table	= table,
+		.filter = filter,
 	};
 	nftnl_set_list_foreach(set_list, set_cache_cb, &dump_ctx);
 
@@ -644,7 +663,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 				ret = -1;
 				goto cache_fails;
 			}
-			ret = set_cache_init(ctx, table, set_list);
+			ret = set_cache_init(ctx, table, set_list, filter);
 
 			nftnl_set_list_free(set_list);
 
-- 
2.30.2

