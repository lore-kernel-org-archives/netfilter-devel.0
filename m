Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6DDC433ED
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 19:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3822661056
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 19:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhDBTEy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 15:04:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55604 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBTEy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 15:04:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A56EF63E3E
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Apr 2021 21:04:35 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] cache: add hashtable cache for sets
Date:   Fri,  2 Apr 2021 21:04:46 +0200
Message-Id: <20210402190447.20689-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a hashtable for set lookups.

This patch also splits table->sets in two:

- Sets that reside in the cache are stored in the new
  tables->cache_set and tables->cache_set_ht.

- Set that defined via command line / ruleset file reside in
  tables->set.

Sets in the cache (already in the kernel) are not placed in the
table->sets list.

By keeping separated lists, sets defined via command line / ruleset file
can be added to cache.

Adding 10000 sets, before:

 # time nft -f x
 real    0m6,415s
 user    0m3,126s
 sys     0m3,284s

After:

 # time nft -f x
 real    0m3,949s
 user    0m0,743s
 sys     0m3,205s

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h           |  2 +
 include/netlink.h         |  1 -
 include/rule.h            |  6 ++-
 src/cache.c               | 93 +++++++++++++++++++++++++++++++++++++--
 src/evaluate.c            | 20 ++++-----
 src/json.c                |  6 +--
 src/monitor.c             |  2 +-
 src/netlink.c             | 31 -------------
 src/netlink_delinearize.c |  6 +--
 src/rule.c                | 36 +++++++--------
 10 files changed, 128 insertions(+), 75 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 087f9ba96848..f500e1b19e45 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -59,5 +59,7 @@ void cache_release(struct nft_cache *cache);
 void chain_cache_add(struct chain *chain, struct table *table);
 struct chain *chain_cache_find(const struct table *table,
 			       const struct handle *handle);
+void set_cache_add(struct set *set, struct table *table);
+struct set *set_cache_find(const struct table *table, const char *name);
 
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index cf8aae465324..f93c5322100f 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -139,7 +139,6 @@ extern int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h);
 extern struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 					       const struct nftnl_table *nlt);
 
-extern int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h);
 extern struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 					   const struct nftnl_set *nls);
 
diff --git a/include/rule.h b/include/rule.h
index ad9cca90570d..90c01e9014c8 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -158,6 +158,8 @@ struct table {
 	struct list_head	*cache_chain_ht;
 	struct list_head	cache_chain;
 	struct list_head	chains;
+	struct list_head	*cache_set_ht;
+	struct list_head	cache_set;
 	struct list_head	sets;
 	struct list_head	objs;
 	struct list_head	flowtables;
@@ -331,6 +333,8 @@ void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
  */
 struct set {
 	struct list_head	list;
+	struct list_head	cache_hlist;
+	struct list_head	cache_list;
 	struct handle		handle;
 	struct location		location;
 	unsigned int		refcnt;
@@ -359,8 +363,6 @@ extern struct set *set_alloc(const struct location *loc);
 extern struct set *set_get(struct set *set);
 extern void set_free(struct set *set);
 extern struct set *set_clone(const struct set *set);
-extern void set_add_hash(struct set *set, struct table *table);
-extern struct set *set_lookup(const struct table *table, const char *name);
 extern struct set *set_lookup_global(uint32_t family, const char *table,
 				     const char *name, struct nft_cache *cache);
 extern struct set *set_lookup_fuzzy(const char *set_name,
diff --git a/src/cache.c b/src/cache.c
index 4e573676ddb2..80632c86caa6 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -259,6 +259,85 @@ struct chain *chain_cache_find(const struct table *table,
 	return NULL;
 }
 
+struct set_cache_dump_ctx {
+	struct netlink_ctx	*nlctx;
+	struct table		*table;
+};
+
+static int set_cache_cb(struct nftnl_set *nls, void *arg)
+{
+	struct set_cache_dump_ctx *ctx = arg;
+	const char *set_name;
+	struct set *set;
+	uint32_t hash;
+
+	set = netlink_delinearize_set(ctx->nlctx, nls);
+	if (!set)
+		return -1;
+
+	set_name = nftnl_set_get_str(nls, NFTNL_SET_NAME);
+	hash = djb_hash(set_name) % NFT_CACHE_HSIZE;
+	list_add_tail(&set->cache_hlist, &ctx->table->cache_set_ht[hash]);
+	list_add_tail(&set->cache_list, &ctx->table->cache_set);
+
+	return 0;
+}
+
+static int set_cache_init(struct netlink_ctx *ctx, struct table *table,
+			  struct nftnl_set_list *set_list)
+{
+	struct set_cache_dump_ctx dump_ctx = {
+		.nlctx	= ctx,
+		.table	= table,
+	};
+	nftnl_set_list_foreach(set_list, set_cache_cb, &dump_ctx);
+
+	return 0;
+}
+
+static struct nftnl_set_list *set_cache_dump(struct netlink_ctx *ctx,
+					     const struct table *table,
+					     int *err)
+{
+	struct nftnl_set_list *set_list;
+
+	set_list = mnl_nft_set_dump(ctx, table->handle.family,
+				    table->handle.table.name);
+	if (!set_list) {
+                if (errno == EINTR) {
+			*err = -1;
+			return NULL;
+		}
+		*err = 0;
+		return NULL;
+	}
+
+	return set_list;
+}
+
+void set_cache_add(struct set *set, struct table *table)
+{
+	uint32_t hash;
+
+	hash = djb_hash(set->handle.set.name) % NFT_CACHE_HSIZE;
+	list_add_tail(&set->cache_hlist, &table->cache_set_ht[hash]);
+	list_add_tail(&set->cache_list, &table->cache_set);
+}
+
+struct set *set_cache_find(const struct table *table, const char *name)
+{
+	struct set *set;
+	uint32_t hash;
+
+	hash = djb_hash(name) % NFT_CACHE_HSIZE;
+	list_for_each_entry(set, &table->cache_set_ht[hash], cache_hlist) {
+		if (!strcmp(set->handle.set.name, name))
+			return set;
+	}
+
+	return NULL;
+}
+
 static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 			     struct nft_cache *cache)
 {
@@ -276,6 +355,7 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 {
 	struct nftnl_chain_list *chain_list = NULL;
+	struct nftnl_set_list *set_list = NULL;
 	struct rule *rule, *nrule;
 	struct table *table;
 	struct chain *chain;
@@ -290,15 +370,22 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 
 	list_for_each_entry(table, &ctx->nft->cache.list, list) {
 		if (flags & NFT_CACHE_SET_BIT) {
-			ret = netlink_list_sets(ctx, &table->handle);
-			list_splice_tail_init(&ctx->list, &table->sets);
+			set_list = set_cache_dump(ctx, table, &ret);
+			if (!set_list) {
+				ret = -1;
+				goto cache_fails;
+			}
+			ret = set_cache_init(ctx, table, set_list);
+
+			nftnl_set_list_free(set_list);
+
 			if (ret < 0) {
 				ret = -1;
 				goto cache_fails;
 			}
 		}
 		if (flags & NFT_CACHE_SETELEM_BIT) {
-			list_for_each_entry(set, &table->sets, list) {
+			list_for_each_entry(set, &table->cache_set, cache_list) {
 				ret = netlink_list_setelems(ctx, &set->handle,
 							    set);
 				if (ret < 0) {
diff --git a/src/evaluate.c b/src/evaluate.c
index 691920b04093..f320a0813a44 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -273,7 +273,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		set = set_lookup(table, (*expr)->identifier);
+		set = set_cache_find(table, (*expr)->identifier);
 		if (set == NULL)
 			return set_not_found(ctx, &(*expr)->location,
 					     (*expr)->identifier);
@@ -3677,7 +3677,7 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	if (table == NULL)
 		return table_not_found(ctx);
 
-	set = set_lookup(table, ctx->cmd->handle.set.name);
+	set = set_cache_find(table, ctx->cmd->handle.set.name);
 	if (set == NULL)
 		return set_not_found(ctx, &ctx->cmd->handle.set.location,
 				     ctx->cmd->handle.set.name);
@@ -3790,8 +3790,8 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	}
 	ctx->set = NULL;
 
-	if (set_lookup(table, set->handle.set.name) == NULL)
-		set_add_hash(set_get(set), table);
+	if (set_cache_find(table, set->handle.set.name) == NULL)
+		set_cache_add(set_get(set), table);
 
 	return 0;
 }
@@ -4398,7 +4398,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		set = set_lookup(table, cmd->handle.set.name);
+		set = set_cache_find(table, cmd->handle.set.name);
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
@@ -4412,7 +4412,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		set = set_lookup(table, cmd->handle.set.name);
+		set = set_cache_find(table, cmd->handle.set.name);
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
@@ -4426,7 +4426,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		set = set_lookup(table, cmd->handle.set.name);
+		set = set_cache_find(table, cmd->handle.set.name);
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
@@ -4541,7 +4541,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		set = set_lookup(table, cmd->handle.set.name);
+		set = set_cache_find(table, cmd->handle.set.name);
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
@@ -4557,7 +4557,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		set = set_lookup(table, cmd->handle.set.name);
+		set = set_cache_find(table, cmd->handle.set.name);
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
@@ -4573,7 +4573,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		set = set_lookup(table, cmd->handle.set.name);
+		set = set_cache_find(table, cmd->handle.set.name);
 		if (set == NULL)
 			return set_not_found(ctx, &ctx->cmd->handle.set.location,
 					     ctx->cmd->handle.set.name);
diff --git a/src/json.c b/src/json.c
index 14e403fe1130..52603a57de50 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1574,7 +1574,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		tmp = obj_print_json(obj);
 		json_array_append_new(root, tmp);
 	}
-	list_for_each_entry(set, &table->sets, list) {
+	list_for_each_entry(set, &table->cache_set, cache_list) {
 		if (set_is_anonymous(set->flags))
 			continue;
 		tmp = set_print_json(&ctx->nft->output, set);
@@ -1687,7 +1687,7 @@ static json_t *do_list_chains_json(struct netlink_ctx *ctx, struct cmd *cmd)
 static json_t *do_list_set_json(struct netlink_ctx *ctx,
 				struct cmd *cmd, struct table *table)
 {
-	struct set *set = set_lookup(table, cmd->handle.set.name);
+	struct set *set = set_cache_find(table, cmd->handle.set.name);
 
 	if (set == NULL)
 		return json_null();
@@ -1707,7 +1707,7 @@ static json_t *do_list_sets_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		list_for_each_entry(set, &table->sets, list) {
+		list_for_each_entry(set, &table->cache_set, cache_list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
 			    !set_is_literal(set->flags))
 				continue;
diff --git a/src/monitor.c b/src/monitor.c
index 047d89db933a..dc3f0848ba66 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -632,7 +632,7 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 		goto out;
 	}
 
-	set_add_hash(s, t);
+	set_cache_add(s, t);
 out:
 	nftnl_set_free(nls);
 }
diff --git a/src/netlink.c b/src/netlink.c
index 50318f95e690..e3ed1abf2890 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -971,37 +971,6 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	return set;
 }
 
-static int list_set_cb(struct nftnl_set *nls, void *arg)
-{
-	struct netlink_ctx *ctx = arg;
-	struct set *set;
-
-	set = netlink_delinearize_set(ctx, nls);
-	if (set == NULL)
-		return -1;
-	list_add_tail(&set->list, &ctx->list);
-	return 0;
-}
-
-int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h)
-{
-	struct nftnl_set_list *set_cache;
-	int err;
-
-	set_cache = mnl_nft_set_dump(ctx, h->family, h->table.name);
-	if (set_cache == NULL) {
-		if (errno == EINTR)
-			return -1;
-
-		return 0;
-	}
-
-	ctx->data = h;
-	err = nftnl_set_list_foreach(set_cache, list_set_cb, ctx);
-	nftnl_set_list_free(set_cache);
-	return err;
-}
-
 void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
 {
 	struct nftnl_set_elem *nlse;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 7cd7d403a038..710c668a0258 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -356,7 +356,7 @@ static void netlink_parse_lookup(struct netlink_parse_ctx *ctx,
 	uint32_t flag;
 
 	name = nftnl_expr_get_str(nle, NFTNL_EXPR_LOOKUP_SET);
-	set  = set_lookup(ctx->table, name);
+	set  = set_cache_find(ctx->table, name);
 	if (set == NULL)
 		return netlink_error(ctx, loc,
 				     "Unknown set '%s' in lookup expression",
@@ -1531,7 +1531,7 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	init_list_head(&dynset_parse_ctx.stmt_list);
 
 	name = nftnl_expr_get_str(nle, NFTNL_EXPR_DYNSET_SET_NAME);
-	set  = set_lookup(ctx->table, name);
+	set  = set_cache_find(ctx->table, name);
 	if (set == NULL)
 		return netlink_error(ctx, loc,
 				     "Unknown set '%s' in dynset statement",
@@ -1640,7 +1640,7 @@ static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
 		struct set *set;
 
 		name = nftnl_expr_get_str(nle, NFTNL_EXPR_OBJREF_SET_NAME);
-		set  = set_lookup(ctx->table, name);
+		set  = set_cache_find(ctx->table, name);
 		if (set == NULL)
 			return netlink_error(ctx, loc,
 					     "Unknown set '%s' in objref expression",
diff --git a/src/rule.c b/src/rule.c
index 9c9fd7fdac6d..2c6292c4e173 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -201,22 +201,6 @@ void set_free(struct set *set)
 	xfree(set);
 }
 
-void set_add_hash(struct set *set, struct table *table)
-{
-	list_add_tail(&set->list, &table->sets);
-}
-
-struct set *set_lookup(const struct table *table, const char *name)
-{
-	struct set *set;
-
-	list_for_each_entry(set, &table->sets, list) {
-		if (!strcmp(set->handle.set.name, name))
-			return set;
-	}
-	return NULL;
-}
-
 struct set *set_lookup_fuzzy(const char *set_name,
 			     const struct nft_cache *cache,
 			     const struct table **t)
@@ -228,7 +212,7 @@ struct set *set_lookup_fuzzy(const char *set_name,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->list, list) {
-		list_for_each_entry(set, &table->sets, list) {
+		list_for_each_entry(set, &table->cache_set, cache_list) {
 			if (set_is_anonymous(set->flags))
 				continue;
 			if (!strcmp(set->handle.set.name, set_name)) {
@@ -256,7 +240,7 @@ struct set *set_lookup_global(uint32_t family, const char *table,
 	if (t == NULL)
 		return NULL;
 
-	return set_lookup(t, name);
+	return set_cache_find(t, name);
 }
 
 struct print_fmt_options {
@@ -1124,6 +1108,7 @@ struct table *table_alloc(void)
 	init_list_head(&table->chains);
 	init_list_head(&table->cache_chain);
 	init_list_head(&table->sets);
+	init_list_head(&table->cache_set);
 	init_list_head(&table->objs);
 	init_list_head(&table->flowtables);
 	init_list_head(&table->chain_bindings);
@@ -1135,6 +1120,11 @@ struct table *table_alloc(void)
 	for (i = 0; i < NFT_CACHE_HSIZE; i++)
 		init_list_head(&table->cache_chain_ht[i]);
 
+	table->cache_set_ht =
+		xmalloc(sizeof(struct list_head) * NFT_CACHE_HSIZE);
+	for (i = 0; i < NFT_CACHE_HSIZE; i++)
+		init_list_head(&table->cache_set_ht[i]);
+
 	return table;
 }
 
@@ -1158,6 +1148,9 @@ void table_free(struct table *table)
 		chain_free(chain);
 	list_for_each_entry_safe(set, nset, &table->sets, list)
 		set_free(set);
+	/* this is implicitly releasing sets in the hashtable cache */
+	list_for_each_entry_safe(set, nset, &table->cache_set, cache_list)
+		set_free(set);
 	list_for_each_entry_safe(ft, nft, &table->flowtables, list)
 		flowtable_free(ft);
 	list_for_each_entry_safe(obj, nobj, &table->objs, list)
@@ -1165,6 +1158,7 @@ void table_free(struct table *table)
 	handle_free(&table->handle);
 	scope_release(&table->scope);
 	xfree(table->cache_chain_ht);
+	xfree(table->cache_set_ht);
 	xfree(table);
 }
 
@@ -1275,7 +1269,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		obj_print(obj, octx);
 		delim = "\n";
 	}
-	list_for_each_entry(set, &table->sets, list) {
+	list_for_each_entry(set, &table->cache_set, cache_list) {
 		if (set_is_anonymous(set->flags))
 			continue;
 		nft_print(octx, "%s", delim);
@@ -1697,7 +1691,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			  family2str(table->handle.family),
 			  table->handle.table.name);
 
-		list_for_each_entry(set, &table->sets, list) {
+		list_for_each_entry(set, &table->cache_set, cache_list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
 			    !set_is_literal(set->flags))
 				continue;
@@ -2435,7 +2429,7 @@ static int do_list_set(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	struct set *set;
 
-	set = set_lookup(table, cmd->handle.set.name);
+	set = set_cache_find(table, cmd->handle.set.name);
 	if (set == NULL)
 		return -1;
 
-- 
2.20.1

