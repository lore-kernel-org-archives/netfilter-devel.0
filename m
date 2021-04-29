Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9B3C43460
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8865A613DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhD2Xnx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59552 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhD2Xnw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:52 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1309264147
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 06/18] src: consolidate object cache infrastructure
Date:   Fri, 30 Apr 2021 01:42:43 +0200
Message-Id: <20210429234255.16840-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch consolidates the object cache infrastructure. Update set and
chains to use it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h | 15 +++++++++++++++
 include/rule.h  | 12 ++++--------
 src/cache.c     | 48 ++++++++++++++++++++++++++++++++++++------------
 src/json.c      | 10 +++++-----
 src/rule.c      | 40 +++++++++++++++-------------------------
 5 files changed, 75 insertions(+), 50 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 987b122bc4fb..4d91a73624c8 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -72,4 +72,19 @@ struct chain *chain_cache_find(const struct table *table, const char *name);
 void set_cache_add(struct set *set, struct table *table);
 struct set *set_cache_find(const struct table *table, const char *name);
 
+struct cache {
+	struct list_head	*ht;
+	struct list_head	list;
+};
+
+struct cache_item {
+	struct list_head	hlist;
+	struct list_head	list;
+};
+
+void cache_init(struct cache *cache);
+void cache_free(struct cache *cache);
+void cache_add(struct cache_item *item, struct cache *cache, uint32_t hash);
+void cache_del(struct cache_item *item);
+
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/rule.h b/include/rule.h
index 7896eafec137..b238c85bcba9 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -155,11 +155,9 @@ struct table {
 	struct handle		handle;
 	struct location		location;
 	struct scope		scope;
-	struct list_head	*cache_chain_ht;
-	struct list_head	cache_chain;
+	struct cache		chain_cache;
+	struct cache		set_cache;
 	struct list_head	chains;
-	struct list_head	*cache_set_ht;
-	struct list_head	cache_set;
 	struct list_head	sets;
 	struct list_head	objs;
 	struct list_head	flowtables;
@@ -233,8 +231,7 @@ struct hook_spec {
  */
 struct chain {
 	struct list_head	list;
-	struct list_head	cache_hlist;
-	struct list_head	cache_list;
+	struct cache_item	cache;
 	struct handle		handle;
 	struct location		location;
 	unsigned int		refcnt;
@@ -333,8 +330,7 @@ void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
  */
 struct set {
 	struct list_head	list;
-	struct list_head	cache_hlist;
-	struct list_head	cache_list;
+	struct cache_item	cache;
 	struct handle		handle;
 	struct location		location;
 	unsigned int		refcnt;
diff --git a/src/cache.c b/src/cache.c
index 53dbaaba8e20..70e47064848e 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -193,10 +193,9 @@ static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 	chain = netlink_delinearize_chain(ctx->nlctx, nlc);
 
 	if (chain->flags & CHAIN_F_BINDING) {
-		list_add_tail(&chain->cache_list, &ctx->table->chain_bindings);
+		list_add_tail(&chain->cache.list, &ctx->table->chain_bindings);
 	} else {
-		list_add_tail(&chain->cache_hlist, &ctx->table->cache_chain_ht[hash]);
-		list_add_tail(&chain->cache_list, &ctx->table->cache_chain);
+		cache_add(&chain->cache, &ctx->table->chain_cache, hash);
 	}
 
 	nftnl_chain_list_del(nlc);
@@ -240,8 +239,7 @@ void chain_cache_add(struct chain *chain, struct table *table)
 	uint32_t hash;
 
 	hash = djb_hash(chain->handle.chain.name) % NFT_CACHE_HSIZE;
-	list_add_tail(&chain->cache_hlist, &table->cache_chain_ht[hash]);
-	list_add_tail(&chain->cache_list, &table->cache_chain);
+	cache_add(&chain->cache, &table->chain_cache, hash);
 }
 
 struct chain *chain_cache_find(const struct table *table, const char *name)
@@ -250,7 +248,7 @@ struct chain *chain_cache_find(const struct table *table, const char *name)
 	uint32_t hash;
 
 	hash = djb_hash(name) % NFT_CACHE_HSIZE;
-	list_for_each_entry(chain, &table->cache_chain_ht[hash], cache_hlist) {
+	list_for_each_entry(chain, &table->chain_cache.ht[hash], cache.hlist) {
 		if (!strcmp(chain->handle.chain.name, name))
 			return chain;
 	}
@@ -276,8 +274,7 @@ static int set_cache_cb(struct nftnl_set *nls, void *arg)
 
 	set_name = nftnl_set_get_str(nls, NFTNL_SET_NAME);
 	hash = djb_hash(set_name) % NFT_CACHE_HSIZE;
-	list_add_tail(&set->cache_hlist, &ctx->table->cache_set_ht[hash]);
-	list_add_tail(&set->cache_list, &ctx->table->cache_set);
+	cache_add(&set->cache, &ctx->table->set_cache, hash);
 
 	return 0;
 }
@@ -319,8 +316,7 @@ void set_cache_add(struct set *set, struct table *table)
 	uint32_t hash;
 
 	hash = djb_hash(set->handle.set.name) % NFT_CACHE_HSIZE;
-	list_add_tail(&set->cache_hlist, &table->cache_set_ht[hash]);
-	list_add_tail(&set->cache_list, &table->cache_set);
+	cache_add(&set->cache, &table->set_cache, hash);
 }
 
 struct set *set_cache_find(const struct table *table, const char *name)
@@ -329,7 +325,7 @@ struct set *set_cache_find(const struct table *table, const char *name)
 	uint32_t hash;
 
 	hash = djb_hash(name) % NFT_CACHE_HSIZE;
-	list_for_each_entry(set, &table->cache_set_ht[hash], cache_hlist) {
+	list_for_each_entry(set, &table->set_cache.ht[hash], cache.hlist) {
 		if (!strcmp(set->handle.set.name, name))
 			return set;
 	}
@@ -384,7 +380,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 			}
 		}
 		if (flags & NFT_CACHE_SETELEM_BIT) {
-			list_for_each_entry(set, &table->cache_set, cache_list) {
+			list_for_each_entry(set, &table->set_cache.list, cache.list) {
 				ret = netlink_list_setelems(ctx, &set->handle,
 							    set);
 				if (ret < 0) {
@@ -552,3 +548,31 @@ void nft_cache_release(struct nft_cache *cache)
 	cache->genid = 0;
 	cache->flags = NFT_CACHE_EMPTY;
 }
+
+void cache_init(struct cache *cache)
+{
+	int i;
+
+	cache->ht = xmalloc(sizeof(struct list_head) * NFT_CACHE_HSIZE);
+	for (i = 0; i < NFT_CACHE_HSIZE; i++)
+		init_list_head(&cache->ht[i]);
+
+	init_list_head(&cache->list);
+}
+
+void cache_free(struct cache *cache)
+{
+	xfree(cache->ht);
+}
+
+void cache_add(struct cache_item *item, struct cache *cache, uint32_t hash)
+{
+	list_add_tail(&item->hlist, &cache->ht[hash]);
+	list_add_tail(&item->list, &cache->list);
+}
+
+void cache_del(struct cache_item *item)
+{
+	list_del(&item->hlist);
+	list_del(&item->list);
+}
diff --git a/src/json.c b/src/json.c
index 52603a57de50..a375093eb785 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1574,7 +1574,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		tmp = obj_print_json(obj);
 		json_array_append_new(root, tmp);
 	}
-	list_for_each_entry(set, &table->cache_set, cache_list) {
+	list_for_each_entry(set, &table->set_cache.list, cache.list) {
 		if (set_is_anonymous(set->flags))
 			continue;
 		tmp = set_print_json(&ctx->nft->output, set);
@@ -1584,7 +1584,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		tmp = flowtable_print_json(flowtable);
 		json_array_append_new(root, tmp);
 	}
-	list_for_each_entry(chain, &table->cache_chain, cache_list) {
+	list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
 		tmp = chain_print_json(chain);
 		json_array_append_new(root, tmp);
 
@@ -1646,7 +1646,7 @@ static json_t *do_list_chain_json(struct netlink_ctx *ctx,
 	struct chain *chain;
 	struct rule *rule;
 
-	list_for_each_entry(chain, &table->cache_chain, cache_list) {
+	list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
 		if (chain->handle.family != cmd->handle.family ||
 		    strcmp(cmd->handle.chain.name, chain->handle.chain.name))
 			continue;
@@ -1674,7 +1674,7 @@ static json_t *do_list_chains_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		list_for_each_entry(chain, &table->cache_chain, cache_list) {
+		list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
 			json_t *tmp = chain_print_json(chain);
 
 			json_array_append_new(root, tmp);
@@ -1707,7 +1707,7 @@ static json_t *do_list_sets_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		list_for_each_entry(set, &table->cache_set, cache_list) {
+		list_for_each_entry(set, &table->set_cache.list, cache.list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
 			    !set_is_literal(set->flags))
 				continue;
diff --git a/src/rule.c b/src/rule.c
index fac8d22a85ee..7dbb02f5b04f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -212,7 +212,7 @@ struct set *set_lookup_fuzzy(const char *set_name,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->list, list) {
-		list_for_each_entry(set, &table->cache_set, cache_list) {
+		list_for_each_entry(set, &table->set_cache.list, cache.list) {
 			if (set_is_anonymous(set->flags))
 				continue;
 			if (!strcmp(set->handle.set.name, set_name)) {
@@ -750,7 +750,7 @@ struct chain *chain_binding_lookup(const struct table *table,
 {
 	struct chain *chain;
 
-	list_for_each_entry(chain, &table->chain_bindings, cache_list) {
+	list_for_each_entry(chain, &table->chain_bindings, cache.list) {
 		if (!strcmp(chain->handle.chain.name, chain_name))
 			return chain;
 	}
@@ -768,7 +768,7 @@ struct chain *chain_lookup_fuzzy(const struct handle *h,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->list, list) {
-		list_for_each_entry(chain, &table->cache_chain, cache_list) {
+		list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
 			if (!strcmp(chain->handle.chain.name, h->chain.name)) {
 				*t = table;
 				return chain;
@@ -1102,28 +1102,18 @@ void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
 struct table *table_alloc(void)
 {
 	struct table *table;
-	int i;
 
 	table = xzalloc(sizeof(*table));
 	init_list_head(&table->chains);
-	init_list_head(&table->cache_chain);
 	init_list_head(&table->sets);
-	init_list_head(&table->cache_set);
 	init_list_head(&table->objs);
 	init_list_head(&table->flowtables);
 	init_list_head(&table->chain_bindings);
 	init_list_head(&table->scope.symbols);
 	table->refcnt = 1;
 
-	table->cache_chain_ht =
-		xmalloc(sizeof(struct list_head) * NFT_CACHE_HSIZE);
-	for (i = 0; i < NFT_CACHE_HSIZE; i++)
-		init_list_head(&table->cache_chain_ht[i]);
-
-	table->cache_set_ht =
-		xmalloc(sizeof(struct list_head) * NFT_CACHE_HSIZE);
-	for (i = 0; i < NFT_CACHE_HSIZE; i++)
-		init_list_head(&table->cache_set_ht[i]);
+	cache_init(&table->chain_cache);
+	cache_init(&table->set_cache);
 
 	return table;
 }
@@ -1141,15 +1131,15 @@ void table_free(struct table *table)
 		xfree(table->comment);
 	list_for_each_entry_safe(chain, next, &table->chains, list)
 		chain_free(chain);
-	list_for_each_entry_safe(chain, next, &table->chain_bindings, cache_list)
+	list_for_each_entry_safe(chain, next, &table->chain_bindings, cache.list)
 		chain_free(chain);
 	/* this is implicitly releasing chains in the hashtable cache */
-	list_for_each_entry_safe(chain, next, &table->cache_chain, cache_list)
+	list_for_each_entry_safe(chain, next, &table->chain_cache.list, cache.list)
 		chain_free(chain);
 	list_for_each_entry_safe(set, nset, &table->sets, list)
 		set_free(set);
 	/* this is implicitly releasing sets in the hashtable cache */
-	list_for_each_entry_safe(set, nset, &table->cache_set, cache_list)
+	list_for_each_entry_safe(set, nset, &table->set_cache.list, cache.list)
 		set_free(set);
 	list_for_each_entry_safe(ft, nft, &table->flowtables, list)
 		flowtable_free(ft);
@@ -1157,8 +1147,8 @@ void table_free(struct table *table)
 		obj_free(obj);
 	handle_free(&table->handle);
 	scope_release(&table->scope);
-	xfree(table->cache_chain_ht);
-	xfree(table->cache_set_ht);
+	cache_free(&table->chain_cache);
+	cache_free(&table->set_cache);
 	xfree(table);
 }
 
@@ -1269,7 +1259,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		obj_print(obj, octx);
 		delim = "\n";
 	}
-	list_for_each_entry(set, &table->cache_set, cache_list) {
+	list_for_each_entry(set, &table->set_cache.list, cache.list) {
 		if (set_is_anonymous(set->flags))
 			continue;
 		nft_print(octx, "%s", delim);
@@ -1281,7 +1271,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		flowtable_print(flowtable, octx);
 		delim = "\n";
 	}
-	list_for_each_entry(chain, &table->cache_chain, cache_list) {
+	list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
 		nft_print(octx, "%s", delim);
 		chain_print(chain, octx);
 		delim = "\n";
@@ -1691,7 +1681,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			  family2str(table->handle.family),
 			  table->handle.table.name);
 
-		list_for_each_entry(set, &table->cache_set, cache_list) {
+		list_for_each_entry(set, &table->set_cache.list, cache.list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
 			    !set_is_literal(set->flags))
 				continue;
@@ -2375,7 +2365,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	table_print_declaration(table, &ctx->nft->output);
 
-	list_for_each_entry(chain, &table->cache_chain, cache_list) {
+	list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
 		if (chain->handle.family != cmd->handle.family ||
 		    strcmp(cmd->handle.chain.name, chain->handle.chain.name) != 0)
 			continue;
@@ -2400,7 +2390,7 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 
 		table_print_declaration(table, &ctx->nft->output);
 
-		list_for_each_entry(chain, &table->cache_chain, cache_list) {
+		list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
 			chain_print_declaration(chain, &ctx->nft->output);
 			nft_print(&ctx->nft->output, "\t}\n");
 		}
-- 
2.20.1

