Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059FEC433E9
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 12:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B82D364FE2
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 12:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhCKMet (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 07:34:49 -0500
Received: from correo.us.es ([193.147.175.20]:44398 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233077AbhCKMeX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 07:34:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BF2FDA7E87
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 13:34:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8A34DA73F
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 13:34:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9D004DA72F; Thu, 11 Mar 2021 13:34:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9508DA78B
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 13:34:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 13:34:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id D5B4042DF560
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 13:34:12 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: move remaining cache in rule.c function to cache.c
Date:   Thu, 11 Mar 2021 13:34:10 +0100
Message-Id: <20210311123410.19164-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move all the cache logic to src/cache.c

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h |   6 +-
 src/cache.c     | 207 +++++++++++++++++++++++++++++++++++++++++++++++-
 src/rule.c      | 201 ----------------------------------------------
 3 files changed, 209 insertions(+), 205 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index baa2bb29f1e7..a892b7fcdcb9 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -52,9 +52,11 @@ struct table;
 struct chain;
 struct handle;
 
+int cache_init(struct netlink_ctx *ctx, unsigned int flags);
+int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs);
+void cache_release(struct nft_cache *cache);
+
 struct nftnl_chain_list *chain_cache_dump(struct netlink_ctx *ctx, int *err);
-int chain_cache_init(struct netlink_ctx *ctx, struct table *table,
-		     struct nftnl_chain_list *chain_cache);
 void chain_cache_add(struct chain *chain, struct table *table);
 struct chain *chain_cache_find(const struct table *table,
 			       const struct handle *handle);
diff --git a/src/cache.c b/src/cache.c
index ed2609008e22..63971e865622 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -15,6 +15,7 @@
 #include <netlink.h>
 #include <mnl.h>
 #include <libnftnl/chain.h>
+#include <linux/netfilter.h>
 
 static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 {
@@ -204,8 +205,8 @@ static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 	return 0;
 }
 
-int chain_cache_init(struct netlink_ctx *ctx, struct table *table,
-		     struct nftnl_chain_list *chain_list)
+static int chain_cache_init(struct netlink_ctx *ctx, struct table *table,
+			    struct nftnl_chain_list *chain_list)
 {
 	struct chain_cache_dump_ctx dump_ctx = {
 		.nlctx	= ctx,
@@ -256,3 +257,205 @@ struct chain *chain_cache_find(const struct table *table,
 
 	return NULL;
 }
+
+static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
+			     struct nft_cache *cache)
+{
+	int ret;
+
+	ret = netlink_list_tables(ctx, h);
+	if (ret < 0)
+		return -1;
+
+	list_splice_tail_init(&ctx->list, &cache->list);
+
+	return 0;
+}
+
+static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
+{
+	struct nftnl_chain_list *chain_list = NULL;
+	struct rule *rule, *nrule;
+	struct table *table;
+	struct chain *chain;
+	struct set *set;
+	int ret = 0;
+
+	if (flags & NFT_CACHE_CHAIN_BIT) {
+		chain_list = chain_cache_dump(ctx, &ret);
+		if (!chain_list)
+			return ret;
+	}
+
+	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+		if (flags & NFT_CACHE_SET_BIT) {
+			ret = netlink_list_sets(ctx, &table->handle);
+			list_splice_tail_init(&ctx->list, &table->sets);
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
+		}
+		if (flags & NFT_CACHE_SETELEM_BIT) {
+			list_for_each_entry(set, &table->sets, list) {
+				ret = netlink_list_setelems(ctx, &set->handle,
+							    set);
+				if (ret < 0) {
+					ret = -1;
+					goto cache_fails;
+				}
+			}
+		}
+		if (flags & NFT_CACHE_CHAIN_BIT) {
+			ret = chain_cache_init(ctx, table, chain_list);
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
+		}
+		if (flags & NFT_CACHE_FLOWTABLE_BIT) {
+			ret = netlink_list_flowtables(ctx, &table->handle);
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
+			list_splice_tail_init(&ctx->list, &table->flowtables);
+		}
+		if (flags & NFT_CACHE_OBJECT_BIT) {
+			ret = netlink_list_objs(ctx, &table->handle);
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
+			list_splice_tail_init(&ctx->list, &table->objs);
+		}
+
+		if (flags & NFT_CACHE_RULE_BIT) {
+			ret = netlink_list_rules(ctx, &table->handle);
+			list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
+				chain = chain_cache_find(table, &rule->handle);
+				if (!chain)
+					chain = chain_binding_lookup(table,
+							rule->handle.chain.name);
+				list_move_tail(&rule->list, &chain->rules);
+			}
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
+		}
+	}
+
+cache_fails:
+	if (flags & NFT_CACHE_CHAIN_BIT)
+		nftnl_chain_list_free(chain_list);
+
+	return ret;
+}
+
+int cache_init(struct netlink_ctx *ctx, unsigned int flags)
+{
+	struct handle handle = {
+		.family = NFPROTO_UNSPEC,
+	};
+	int ret;
+
+	if (flags == NFT_CACHE_EMPTY)
+		return 0;
+
+	/* assume NFT_CACHE_TABLE is always set. */
+	ret = cache_init_tables(ctx, &handle, &ctx->nft->cache);
+	if (ret < 0)
+		return ret;
+	ret = cache_init_objects(ctx, flags);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static bool cache_is_complete(struct nft_cache *cache, unsigned int flags)
+{
+	return (cache->flags & flags) == flags;
+}
+
+static bool cache_needs_refresh(struct nft_cache *cache)
+{
+	return cache->flags & NFT_CACHE_REFRESH;
+}
+
+static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
+{
+	return genid && genid == cache->genid;
+}
+
+bool cache_needs_update(struct nft_cache *cache)
+{
+	return cache->flags & NFT_CACHE_UPDATE;
+}
+
+int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs)
+{
+	struct netlink_ctx ctx = {
+		.list		= LIST_HEAD_INIT(ctx.list),
+		.nft		= nft,
+		.msgs		= msgs,
+	};
+	struct nft_cache *cache = &nft->cache;
+	uint32_t genid, genid_stop, oldflags;
+	int ret;
+replay:
+	ctx.seqnum = cache->seqnum++;
+	genid = mnl_genid_get(&ctx);
+	if (!cache_needs_refresh(cache) &&
+	    cache_is_complete(cache, flags) &&
+	    cache_is_updated(cache, genid))
+		return 0;
+
+	if (cache->genid)
+		cache_release(cache);
+
+	if (flags & NFT_CACHE_FLUSHED) {
+		oldflags = flags;
+		flags = NFT_CACHE_EMPTY;
+		if (oldflags & NFT_CACHE_UPDATE)
+			flags |= NFT_CACHE_UPDATE;
+		goto skip;
+	}
+
+	ret = cache_init(&ctx, flags);
+	if (ret < 0) {
+		cache_release(cache);
+		if (errno == EINTR)
+			goto replay;
+
+		return -1;
+	}
+
+	genid_stop = mnl_genid_get(&ctx);
+	if (genid != genid_stop) {
+		cache_release(cache);
+		goto replay;
+	}
+skip:
+	cache->genid = genid;
+	cache->flags = flags;
+	return 0;
+}
+
+static void __cache_flush(struct list_head *table_list)
+{
+	struct table *table, *next;
+
+	list_for_each_entry_safe(table, next, table_list, list) {
+		list_del(&table->list);
+		table_free(table);
+	}
+}
+
+void cache_release(struct nft_cache *cache)
+{
+	__cache_flush(&cache->list);
+	cache->genid = 0;
+	cache->flags = NFT_CACHE_EMPTY;
+}
diff --git a/src/rule.c b/src/rule.c
index cf4d2cbef27b..1c6010c001c5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -138,207 +138,6 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->index = src->index;
 }
 
-static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
-			     struct nft_cache *cache)
-{
-	int ret;
-
-	ret = netlink_list_tables(ctx, h);
-	if (ret < 0)
-		return -1;
-
-	list_splice_tail_init(&ctx->list, &cache->list);
-	return 0;
-}
-
-static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
-{
-	struct nftnl_chain_list *chain_list = NULL;
-	struct rule *rule, *nrule;
-	struct table *table;
-	struct chain *chain;
-	struct set *set;
-	int ret = 0;
-
-	if (flags & NFT_CACHE_CHAIN_BIT) {
-		chain_list = chain_cache_dump(ctx, &ret);
-		if (!chain_list)
-			return ret;
-	}
-
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
-		if (flags & NFT_CACHE_SET_BIT) {
-			ret = netlink_list_sets(ctx, &table->handle);
-			list_splice_tail_init(&ctx->list, &table->sets);
-			if (ret < 0) {
-				ret = -1;
-				goto cache_fails;
-			}
-		}
-		if (flags & NFT_CACHE_SETELEM_BIT) {
-			list_for_each_entry(set, &table->sets, list) {
-				ret = netlink_list_setelems(ctx, &set->handle,
-							    set);
-				if (ret < 0) {
-					ret = -1;
-					goto cache_fails;
-				}
-			}
-		}
-		if (flags & NFT_CACHE_CHAIN_BIT) {
-			ret = chain_cache_init(ctx, table, chain_list);
-			if (ret < 0) {
-				ret = -1;
-				goto cache_fails;
-			}
-		}
-		if (flags & NFT_CACHE_FLOWTABLE_BIT) {
-			ret = netlink_list_flowtables(ctx, &table->handle);
-			if (ret < 0) {
-				ret = -1;
-				goto cache_fails;
-			}
-			list_splice_tail_init(&ctx->list, &table->flowtables);
-		}
-		if (flags & NFT_CACHE_OBJECT_BIT) {
-			ret = netlink_list_objs(ctx, &table->handle);
-			if (ret < 0) {
-				ret = -1;
-				goto cache_fails;
-			}
-			list_splice_tail_init(&ctx->list, &table->objs);
-		}
-
-		if (flags & NFT_CACHE_RULE_BIT) {
-			ret = netlink_list_rules(ctx, &table->handle);
-			list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
-				chain = chain_cache_find(table, &rule->handle);
-				if (!chain)
-					chain = chain_binding_lookup(table,
-							rule->handle.chain.name);
-				list_move_tail(&rule->list, &chain->rules);
-			}
-			if (ret < 0) {
-				ret = -1;
-				goto cache_fails;
-			}
-		}
-	}
-
-cache_fails:
-	if (flags & NFT_CACHE_CHAIN_BIT)
-		nftnl_chain_list_free(chain_list);
-
-	return ret;
-}
-
-static int cache_init(struct netlink_ctx *ctx, unsigned int flags)
-{
-	struct handle handle = {
-		.family = NFPROTO_UNSPEC,
-	};
-	int ret;
-
-	if (flags == NFT_CACHE_EMPTY)
-		return 0;
-
-	/* assume NFT_CACHE_TABLE is always set. */
-	ret = cache_init_tables(ctx, &handle, &ctx->nft->cache);
-	if (ret < 0)
-		return ret;
-	ret = cache_init_objects(ctx, flags);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static bool cache_is_complete(struct nft_cache *cache, unsigned int flags)
-{
-	return (cache->flags & flags) == flags;
-}
-
-static bool cache_needs_refresh(struct nft_cache *cache)
-{
-	return cache->flags & NFT_CACHE_REFRESH;
-}
-
-static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
-{
-	return genid && genid == cache->genid;
-}
-
-bool cache_needs_update(struct nft_cache *cache)
-{
-	return cache->flags & NFT_CACHE_UPDATE;
-}
-
-int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs)
-{
-	struct netlink_ctx ctx = {
-		.list		= LIST_HEAD_INIT(ctx.list),
-		.nft		= nft,
-		.msgs		= msgs,
-	};
-	struct nft_cache *cache = &nft->cache;
-	uint32_t genid, genid_stop, oldflags;
-	int ret;
-replay:
-	ctx.seqnum = cache->seqnum++;
-	genid = mnl_genid_get(&ctx);
-	if (!cache_needs_refresh(cache) &&
-	    cache_is_complete(cache, flags) &&
-	    cache_is_updated(cache, genid))
-		return 0;
-
-	if (cache->genid)
-		cache_release(cache);
-
-	if (flags & NFT_CACHE_FLUSHED) {
-		oldflags = flags;
-		flags = NFT_CACHE_EMPTY;
-		if (oldflags & NFT_CACHE_UPDATE)
-			flags |= NFT_CACHE_UPDATE;
-		goto skip;
-	}
-
-	ret = cache_init(&ctx, flags);
-	if (ret < 0) {
-		cache_release(cache);
-		if (errno == EINTR)
-			goto replay;
-
-		return -1;
-	}
-
-	genid_stop = mnl_genid_get(&ctx);
-	if (genid != genid_stop) {
-		cache_release(cache);
-		goto replay;
-	}
-skip:
-	cache->genid = genid;
-	cache->flags = flags;
-	return 0;
-}
-
-static void __cache_flush(struct list_head *table_list)
-{
-	struct table *table, *next;
-
-	list_for_each_entry_safe(table, next, table_list, list) {
-		list_del(&table->list);
-		table_free(table);
-	}
-}
-
-void cache_release(struct nft_cache *cache)
-{
-	__cache_flush(&cache->list);
-	cache->genid = 0;
-	cache->flags = NFT_CACHE_EMPTY;
-}
-
 /* internal ID to uniquely identify a set in the batch */
 static uint32_t set_id;
 
-- 
2.20.1

