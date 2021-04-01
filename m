Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2EC8C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 20:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C795610D0
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 20:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhDAU3f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 16:29:35 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53702 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbhDAU3f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 16:29:35 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id AF2D563E3E
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 22:29:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4,v2] src: split chain list in table
Date:   Thu,  1 Apr 2021 22:29:26 +0200
Message-Id: <20210401202928.5222-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210401202928.5222-1-pablo@netfilter.org>
References: <20210401202928.5222-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch splits table->lists in two:

- Chains that reside in the cache are stored in the new
  tables->cache_chain and tables->cache_chain_ht. The hashtable chain
  cache allows for fast chain lookups.

- Chains that defined via command line / ruleset file reside in
  tables->chains.

Note that chains in the cache (already in the kernel) are not placed in
the table->chains.

By keeping separated lists, chains defined via command line / ruleset
file can be added to cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: instead of cloning the chain, reuse the existing chain coming
    from the command/ruleset and add it to the cache.

 include/rule.h |  2 ++
 src/cache.c    |  6 +++---
 src/json.c     |  6 +++---
 src/rule.c     | 18 +++++++++++-------
 4 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index f8e615121113..6c6ada6b5537 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -156,6 +156,7 @@ struct table {
 	struct location		location;
 	struct scope		scope;
 	struct list_head	*cache_chain_ht;
+	struct list_head	cache_chain;
 	struct list_head	chains;
 	struct list_head	sets;
 	struct list_head	objs;
@@ -231,6 +232,7 @@ struct hook_spec {
 struct chain {
 	struct list_head	list;
 	struct list_head	cache_hlist;
+	struct list_head	cache_list;
 	struct handle		handle;
 	struct location		location;
 	unsigned int		refcnt;
diff --git a/src/cache.c b/src/cache.c
index 400128906b03..c9e1f22a3291 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -193,10 +193,10 @@ static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 	chain = netlink_delinearize_chain(ctx->nlctx, nlc);
 
 	if (chain->flags & CHAIN_F_BINDING) {
-		list_add_tail(&chain->list, &ctx->table->chain_bindings);
+		list_add_tail(&chain->cache_list, &ctx->table->chain_bindings);
 	} else {
 		list_add_tail(&chain->cache_hlist, &ctx->table->cache_chain_ht[hash]);
-		list_add_tail(&chain->list, &ctx->table->chains);
+		list_add_tail(&chain->cache_list, &ctx->table->cache_chain);
 	}
 
 	nftnl_chain_list_del(nlc);
@@ -240,7 +240,7 @@ void chain_cache_add(struct chain *chain, struct table *table)
 
 	hash = djb_hash(chain->handle.chain.name) % NFT_CACHE_HSIZE;
 	list_add_tail(&chain->cache_hlist, &table->cache_chain_ht[hash]);
-	list_add_tail(&chain->list, &table->chains);
+	list_add_tail(&chain->cache_list, &table->cache_chain);
 }
 
 struct chain *chain_cache_find(const struct table *table,
diff --git a/src/json.c b/src/json.c
index defbc8fb44df..14e403fe1130 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1584,7 +1584,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		tmp = flowtable_print_json(flowtable);
 		json_array_append_new(root, tmp);
 	}
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		tmp = chain_print_json(chain);
 		json_array_append_new(root, tmp);
 
@@ -1646,7 +1646,7 @@ static json_t *do_list_chain_json(struct netlink_ctx *ctx,
 	struct chain *chain;
 	struct rule *rule;
 
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		if (chain->handle.family != cmd->handle.family ||
 		    strcmp(cmd->handle.chain.name, chain->handle.chain.name))
 			continue;
@@ -1674,7 +1674,7 @@ static json_t *do_list_chains_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		list_for_each_entry(chain, &table->chains, list) {
+		list_for_each_entry(chain, &table->cache_chain, cache_list) {
 			json_t *tmp = chain_print_json(chain);
 
 			json_array_append_new(root, tmp);
diff --git a/src/rule.c b/src/rule.c
index 79706ab7b60a..5be9c0c82444 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -765,7 +765,7 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
 {
 	struct chain *chain;
 
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		if (!strcmp(chain->handle.chain.name, h->chain.name))
 			return chain;
 	}
@@ -777,7 +777,7 @@ struct chain *chain_binding_lookup(const struct table *table,
 {
 	struct chain *chain;
 
-	list_for_each_entry(chain, &table->chain_bindings, list) {
+	list_for_each_entry(chain, &table->chain_bindings, cache_list) {
 		if (!strcmp(chain->handle.chain.name, chain_name))
 			return chain;
 	}
@@ -795,7 +795,7 @@ struct chain *chain_lookup_fuzzy(const struct handle *h,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->list, list) {
-		list_for_each_entry(chain, &table->chains, list) {
+		list_for_each_entry(chain, &table->cache_chain, cache_list) {
 			if (!strcmp(chain->handle.chain.name, h->chain.name)) {
 				*t = table;
 				return chain;
@@ -1133,6 +1133,7 @@ struct table *table_alloc(void)
 
 	table = xzalloc(sizeof(*table));
 	init_list_head(&table->chains);
+	init_list_head(&table->cache_chain);
 	init_list_head(&table->sets);
 	init_list_head(&table->objs);
 	init_list_head(&table->flowtables);
@@ -1161,7 +1162,10 @@ void table_free(struct table *table)
 		xfree(table->comment);
 	list_for_each_entry_safe(chain, next, &table->chains, list)
 		chain_free(chain);
-	list_for_each_entry_safe(chain, next, &table->chain_bindings, list)
+	list_for_each_entry_safe(chain, next, &table->chain_bindings, cache_list)
+		chain_free(chain);
+	/* this is implicitly releasing chains in the hashtable cache */
+	list_for_each_entry_safe(chain, next, &table->cache_chain, cache_list)
 		chain_free(chain);
 	list_for_each_entry_safe(set, nset, &table->sets, list)
 		set_free(set);
@@ -1294,7 +1298,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		flowtable_print(flowtable, octx);
 		delim = "\n";
 	}
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		nft_print(octx, "%s", delim);
 		chain_print(chain, octx);
 		delim = "\n";
@@ -2388,7 +2392,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	table_print_declaration(table, &ctx->nft->output);
 
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		if (chain->handle.family != cmd->handle.family ||
 		    strcmp(cmd->handle.chain.name, chain->handle.chain.name) != 0)
 			continue;
@@ -2413,7 +2417,7 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 
 		table_print_declaration(table, &ctx->nft->output);
 
-		list_for_each_entry(chain, &table->chains, list) {
+		list_for_each_entry(chain, &table->cache_chain, cache_list) {
 			chain_print_declaration(chain, &ctx->nft->output);
 			nft_print(&ctx->nft->output, "\t}\n");
 		}
-- 
2.20.1

