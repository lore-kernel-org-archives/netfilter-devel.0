Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9875C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 885BA6147D
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhD2Xnw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59546 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhD2Xnv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:51 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B498C64141
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:24 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 05/18] src: consolidate nft_cache infrastructure
Date:   Fri, 30 Apr 2021 01:42:42 +0200
Message-Id: <20210429234255.16840-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- prepend nft_ prefix to nft_cache API and internal functions
- move declarations to cache.h (and remove redundant declarations)
- move struct nft_cache definition to cache.h

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h    | 23 +++++++++++++++++------
 include/nftables.h |  8 +-------
 include/rule.h     |  6 ------
 src/cache.c        | 35 ++++++++++++++++++-----------------
 src/cmd.c          |  2 +-
 src/evaluate.c     |  2 +-
 src/libnftables.c  | 10 +++++-----
 7 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 0009276701a3..987b122bc4fb 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -1,6 +1,8 @@
 #ifndef _NFT_CACHE_H_
 #define _NFT_CACHE_H_
 
+#include <string.h>
+
 enum cache_level_bits {
 	NFT_CACHE_TABLE_BIT	= (1 << 0),
 	NFT_CACHE_CHAIN_BIT	= (1 << 1),
@@ -35,6 +37,21 @@ enum cache_level_flags {
 	NFT_CACHE_FLUSHED	= (1 << 31),
 };
 
+struct nft_cache {
+	uint32_t		genid;
+	struct list_head	list;
+	uint32_t		seqnum;
+	uint32_t		flags;
+};
+
+enum cmd_ops;
+
+unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
+int nft_cache_update(struct nft_ctx *ctx, enum cmd_ops cmd,
+		     struct list_head *msgs);
+bool nft_cache_needs_update(struct nft_cache *cache);
+void nft_cache_release(struct nft_cache *cache);
+
 static inline uint32_t djb_hash(const char *key)
 {
 	uint32_t i, hash = 5381;
@@ -47,14 +64,8 @@ static inline uint32_t djb_hash(const char *key)
 
 #define NFT_CACHE_HSIZE 8192
 
-struct netlink_ctx;
 struct table;
 struct chain;
-struct handle;
-
-int cache_init(struct netlink_ctx *ctx, unsigned int flags);
-int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs);
-void cache_release(struct nft_cache *cache);
 
 void chain_cache_add(struct chain *chain, struct table *table);
 struct chain *chain_cache_find(const struct table *table, const char *name);
diff --git a/include/nftables.h b/include/nftables.h
index 9095ff3d0b79..f239fcf0e1f4 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -5,6 +5,7 @@
 #include <stdarg.h>
 #include <limits.h>
 #include <utils.h>
+#include <cache.h>
 #include <nftables/libnftables.h>
 
 struct cookie {
@@ -95,13 +96,6 @@ static inline bool nft_output_terse(const struct output_ctx *octx)
 	return octx->flags & NFT_CTX_OUTPUT_TERSE;
 }
 
-struct nft_cache {
-	uint32_t		genid;
-	struct list_head	list;
-	uint32_t		seqnum;
-	uint32_t		flags;
-};
-
 struct mnl_socket;
 struct parser_state;
 struct scope;
diff --git a/include/rule.h b/include/rule.h
index 90c01e9014c8..7896eafec137 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -771,12 +771,6 @@ extern struct error_record *rule_postprocess(struct rule *rule);
 struct netlink_ctx;
 extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 
-extern unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
-extern int cache_update(struct nft_ctx *ctx, enum cmd_ops cmd,
-			struct list_head *msgs);
-extern bool cache_needs_update(struct nft_cache *cache);
-extern void cache_release(struct nft_cache *cache);
-
 struct timeout_protocol {
 	uint32_t array_size;
 	const char *const *state_to_name;
diff --git a/src/cache.c b/src/cache.c
index b38f3b84eda6..53dbaaba8e20 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -113,7 +113,7 @@ static unsigned int evaluate_cache_rename(struct cmd *cmd, unsigned int flags)
 	return flags;
 }
 
-unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
+unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 {
 	unsigned int flags = NFT_CACHE_EMPTY;
 	struct cmd *cmd;
@@ -445,7 +445,7 @@ cache_fails:
 	return ret;
 }
 
-int cache_init(struct netlink_ctx *ctx, unsigned int flags)
+static int nft_cache_init(struct netlink_ctx *ctx, unsigned int flags)
 {
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
@@ -466,27 +466,28 @@ int cache_init(struct netlink_ctx *ctx, unsigned int flags)
 	return 0;
 }
 
-static bool cache_is_complete(struct nft_cache *cache, unsigned int flags)
+static bool nft_cache_is_complete(struct nft_cache *cache, unsigned int flags)
 {
 	return (cache->flags & flags) == flags;
 }
 
-static bool cache_needs_refresh(struct nft_cache *cache)
+static bool nft_cache_needs_refresh(struct nft_cache *cache)
 {
 	return cache->flags & NFT_CACHE_REFRESH;
 }
 
-static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
+static bool nft_cache_is_updated(struct nft_cache *cache, uint16_t genid)
 {
 	return genid && genid == cache->genid;
 }
 
-bool cache_needs_update(struct nft_cache *cache)
+bool nft_cache_needs_update(struct nft_cache *cache)
 {
 	return cache->flags & NFT_CACHE_UPDATE;
 }
 
-int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs)
+int nft_cache_update(struct nft_ctx *nft, unsigned int flags,
+		     struct list_head *msgs)
 {
 	struct netlink_ctx ctx = {
 		.list		= LIST_HEAD_INIT(ctx.list),
@@ -499,13 +500,13 @@ int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs
 replay:
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
-	if (!cache_needs_refresh(cache) &&
-	    cache_is_complete(cache, flags) &&
-	    cache_is_updated(cache, genid))
+	if (!nft_cache_needs_refresh(cache) &&
+	    nft_cache_is_complete(cache, flags) &&
+	    nft_cache_is_updated(cache, genid))
 		return 0;
 
 	if (cache->genid)
-		cache_release(cache);
+		nft_cache_release(cache);
 
 	if (flags & NFT_CACHE_FLUSHED) {
 		oldflags = flags;
@@ -515,9 +516,9 @@ replay:
 		goto skip;
 	}
 
-	ret = cache_init(&ctx, flags);
+	ret = nft_cache_init(&ctx, flags);
 	if (ret < 0) {
-		cache_release(cache);
+		nft_cache_release(cache);
 		if (errno == EINTR)
 			goto replay;
 
@@ -526,7 +527,7 @@ replay:
 
 	genid_stop = mnl_genid_get(&ctx);
 	if (genid != genid_stop) {
-		cache_release(cache);
+		nft_cache_release(cache);
 		goto replay;
 	}
 skip:
@@ -535,7 +536,7 @@ skip:
 	return 0;
 }
 
-static void __cache_flush(struct list_head *table_list)
+static void nft_cache_flush(struct list_head *table_list)
 {
 	struct table *table, *next;
 
@@ -545,9 +546,9 @@ static void __cache_flush(struct list_head *table_list)
 	}
 }
 
-void cache_release(struct nft_cache *cache)
+void nft_cache_release(struct nft_cache *cache)
 {
-	__cache_flush(&cache->list);
+	nft_cache_flush(&cache->list);
 	cache->genid = 0;
 	cache->flags = NFT_CACHE_EMPTY;
 }
diff --git a/src/cmd.c b/src/cmd.c
index c04efce3801a..f9716fccd513 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -55,7 +55,7 @@ static int nft_cmd_enoent_rule(struct netlink_ctx *ctx, const struct cmd *cmd,
 	const struct table *table;
 	struct chain *chain;
 
-	if (cache_update(ctx->nft, flags, ctx->msgs) < 0)
+	if (nft_cache_update(ctx->nft, flags, ctx->msgs) < 0)
 		return 0;
 
 	table = table_lookup_fuzzy(&cmd->handle, &ctx->nft->cache);
diff --git a/src/evaluate.c b/src/evaluate.c
index 2c8a649f5392..a3f468aab104 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4086,7 +4086,7 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
 		return -1;
 	}
 
-	if (cache_needs_update(&ctx->nft->cache))
+	if (nft_cache_needs_update(&ctx->nft->cache))
 		return rule_cache_update(ctx, op);
 
 	return 0;
diff --git a/src/libnftables.c b/src/libnftables.c
index 044365914747..56c51a6104ac 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -303,7 +303,7 @@ void nft_ctx_free(struct nft_ctx *ctx)
 	exit_cookie(&ctx->output.output_cookie);
 	exit_cookie(&ctx->output.error_cookie);
 	iface_cache_release();
-	cache_release(&ctx->cache);
+	nft_cache_release(&ctx->cache);
 	nft_ctx_clear_include_paths(ctx);
 	scope_free(ctx->top_scope);
 	xfree(ctx->state);
@@ -416,8 +416,8 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	unsigned int flags;
 	struct cmd *cmd;
 
-	flags = cache_evaluate(nft, cmds);
-	if (cache_update(nft, flags, msgs) < 0)
+	flags = nft_cache_evaluate(nft, cmds);
+	if (nft_cache_update(nft, flags, msgs) < 0)
 		return -1;
 
 	list_for_each_entry(cmd, cmds, list) {
@@ -496,7 +496,7 @@ err:
 	    nft_output_echo(&nft->output))
 		json_print_echo(nft);
 	if (rc)
-		cache_release(&nft->cache);
+		nft_cache_release(&nft->cache);
 	return rc;
 }
 
@@ -547,6 +547,6 @@ err:
 	    nft_output_echo(&nft->output))
 		json_print_echo(nft);
 	if (rc)
-		cache_release(&nft->cache);
+		nft_cache_release(&nft->cache);
 	return rc;
 }
-- 
2.20.1

