Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A151FC43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E3DF6147D
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhD2Xn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59558 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhD2Xny (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8671664135
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 14/18] cache: add hashtable cache for table
Date:   Fri, 30 Apr 2021 01:42:51 +0200
Message-Id: <20210429234255.16840-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a hashtable for fast table lookups.

Tables that reside in the cache use the table->cache_hlist and
table->cache_list heads.

Table that are created from command line / ruleset are also added
to the cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h           |  20 +++---
 include/rule.h            |   4 +-
 src/cache.c               |  48 ++++++++++++--
 src/evaluate.c            | 128 +++++++++++++++++++++++---------------
 src/json.c                |  16 ++---
 src/libnftables.c         |   3 +-
 src/monitor.c             |  16 +++--
 src/netlink.c             |   2 +-
 src/netlink_delinearize.c |   7 ++-
 src/rule.c                |  59 +++++++-----------
 10 files changed, 182 insertions(+), 121 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index f5b4876a4d40..fddb843b510e 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -37,13 +37,7 @@ enum cache_level_flags {
 	NFT_CACHE_FLUSHED	= (1 << 31),
 };
 
-struct nft_cache {
-	uint32_t		genid;
-	struct list_head	list;
-	uint32_t		seqnum;
-	uint32_t		flags;
-};
-
+struct nft_cache;
 enum cmd_ops;
 
 unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
@@ -88,6 +82,11 @@ void cache_free(struct cache *cache);
 void cache_add(struct cache_item *item, struct cache *cache, uint32_t hash);
 void cache_del(struct cache_item *item);
 
+void table_cache_add(struct table *table, struct nft_cache *cache);
+void table_cache_del(struct table *table);
+struct table *table_cache_find(const struct cache *cache, const char *name,
+			       uint32_t family);
+
 void obj_cache_add(struct obj *obj, struct table *table);
 void obj_cache_del(struct obj *obj);
 struct obj *obj_cache_find(const struct table *table, const char *name,
@@ -97,4 +96,11 @@ struct flowtable;
 void ft_cache_add(struct flowtable *ft, struct table *table);
 struct flowtable *ft_cache_find(const struct table *table, const char *name);
 
+struct nft_cache {
+	uint32_t		genid;
+	struct cache		table_cache;
+	uint32_t		seqnum;
+	uint32_t		flags;
+};
+
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/rule.h b/include/rule.h
index c6fd4c4c067b..fbd2c9a79b47 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -152,6 +152,7 @@ const char *table_flag_name(uint32_t flag);
  */
 struct table {
 	struct list_head	list;
+	struct cache_item	cache;
 	struct handle		handle;
 	struct location		location;
 	struct scope		scope;
@@ -173,9 +174,6 @@ struct table {
 extern struct table *table_alloc(void);
 extern struct table *table_get(struct table *table);
 extern void table_free(struct table *table);
-extern void table_add_hash(struct table *table, struct nft_cache *cache);
-extern struct table *table_lookup(const struct handle *h,
-				  const struct nft_cache *cache);
 extern struct table *table_lookup_fuzzy(const struct handle *h,
 					const struct nft_cache *cache);
 
diff --git a/src/cache.c b/src/cache.c
index d1f8e8392b58..3c139f1a5dbb 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -173,6 +173,38 @@ unsigned int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 	return flags;
 }
 
+void table_cache_add(struct table *table, struct nft_cache *cache)
+{
+	uint32_t hash;
+
+	hash = djb_hash(table->handle.table.name) % NFT_CACHE_HSIZE;
+	cache_add(&table->cache, &cache->table_cache, hash);
+}
+
+void table_cache_del(struct table *table)
+{
+	cache_del(&table->cache);
+}
+
+struct table *table_cache_find(const struct cache *cache,
+			       const char *name, uint32_t family)
+{
+	struct table *table;
+	uint32_t hash;
+
+	if (!name)
+		return NULL;
+
+	hash = djb_hash(name) % NFT_CACHE_HSIZE;
+	list_for_each_entry(table, &cache->ht[hash], cache.hlist) {
+		if (table->handle.family == family &&
+		    !strcmp(table->handle.table.name, name))
+			return table;
+	}
+
+	return NULL;
+}
+
 struct chain_cache_dump_ctx {
 	struct netlink_ctx	*nlctx;
 	struct table		*table;
@@ -507,13 +539,17 @@ struct flowtable *ft_cache_find(const struct table *table, const char *name)
 static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 			     struct nft_cache *cache)
 {
+	struct table *table, *next;
 	int ret;
 
 	ret = netlink_list_tables(ctx, h);
 	if (ret < 0)
 		return -1;
 
-	list_splice_tail_init(&ctx->list, &cache->list);
+	list_for_each_entry_safe(table, next, &ctx->list, list) {
+		list_del(&table->list);
+		table_cache_add(table, cache);
+	}
 
 	return 0;
 }
@@ -536,7 +572,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 			return -1;
 	}
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (flags & NFT_CACHE_SET_BIT) {
 			set_list = set_cache_dump(ctx, table, &ret);
 			if (!set_list) {
@@ -719,19 +755,19 @@ skip:
 	return 0;
 }
 
-static void nft_cache_flush(struct list_head *table_list)
+static void nft_cache_flush(struct cache *table_cache)
 {
 	struct table *table, *next;
 
-	list_for_each_entry_safe(table, next, table_list, list) {
-		list_del(&table->list);
+	list_for_each_entry_safe(table, next, &table_cache->list, cache.list) {
+		table_cache_del(table);
 		table_free(table);
 	}
 }
 
 void nft_cache_release(struct nft_cache *cache)
 {
-	nft_cache_flush(&cache->list);
+	nft_cache_flush(&cache->table_cache);
 	cache->genid = 0;
 	cache->flags = NFT_CACHE_EMPTY;
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index c5adf2cab7b5..e770cffa6d99 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -166,20 +166,6 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 	return 0;
 }
 
-static struct table *table_lookup_global(struct eval_ctx *ctx)
-{
-	struct table *table;
-
-	if (ctx->table != NULL)
-		return ctx->table;
-
-	table = table_lookup(&ctx->cmd->handle, &ctx->nft->cache);
-	if (table == NULL)
-		return NULL;
-
-	return table;
-}
-
 static int table_not_found(struct eval_ctx *ctx)
 {
 	struct table *table;
@@ -269,7 +255,9 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		}
 		break;
 	case SYMBOL_SET:
-		table = table_lookup_global(ctx);
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 ctx->cmd->handle.table.name,
+					 ctx->cmd->handle.family);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -3709,7 +3697,9 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct set *set;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 ctx->cmd->handle.table.name,
+				 ctx->cmd->handle.family);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -3750,7 +3740,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	struct stmt *stmt;
 	const char *type;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 ctx->cmd->handle.table.name,
+				 ctx->cmd->handle.family);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -3957,7 +3949,9 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 {
 	struct table *table;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 ctx->cmd->handle.table.name,
+				 ctx->cmd->handle.family);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -4005,7 +3999,9 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
 	struct table *table;
 	struct chain *chain;
 
-	table = table_lookup(&rule->handle, &ctx->nft->cache);
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 rule->handle.table.name,
+				 rule->handle.family);
 	if (!table)
 		return table_not_found(ctx);
 
@@ -4147,7 +4143,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 	struct table *table;
 	struct rule *rule;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 ctx->cmd->handle.table.name,
+				 ctx->cmd->handle.family);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -4248,7 +4246,9 @@ static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 {
 	struct table *table;
 
-	table = table_lookup_global(ctx);
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 ctx->cmd->handle.table.name,
+				 ctx->cmd->handle.family);
 	if (!table)
 		return table_not_found(ctx);
 
@@ -4274,13 +4274,15 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 	struct set *set;
 	struct obj *obj;
 
-	if (table_lookup(&ctx->cmd->handle, &ctx->nft->cache) == NULL) {
-		if (table == NULL) {
+	if (!table_cache_find(&ctx->nft->cache.table_cache,
+			      ctx->cmd->handle.table.name,
+			      ctx->cmd->handle.family)) {
+		if (!table) {
 			table = table_alloc();
 			handle_merge(&table->handle, &ctx->cmd->handle);
-			table_add_hash(table, &ctx->nft->cache);
+			table_cache_add(table, &ctx->nft->cache);
 		} else {
-			table_add_hash(table_get(table), &ctx->nft->cache);
+			table_cache_add(table_get(table), &ctx->nft->cache);
 		}
 	}
 
@@ -4355,11 +4357,13 @@ static void table_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
 	if (!cmd->handle.table.name)
 		return;
 
-	table = table_lookup(&cmd->handle, &ctx->nft->cache);
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 cmd->handle.table.name,
+				 cmd->handle.family);
 	if (!table)
 		return;
 
-	list_del(&table->list);
+	table_cache_del(table);
 	table_free(table);
 }
 
@@ -4425,7 +4429,9 @@ static int cmd_evaluate_list_obj(struct eval_ctx *ctx, const struct cmd *cmd,
 	if (obj_type == NFT_OBJECT_UNSPEC)
 		obj_type = NFT_OBJECT_COUNTER;
 
-	table = table_lookup(&cmd->handle, &ctx->nft->cache);
+	table = table_cache_find(&ctx->nft->cache.table_cache,
+				 cmd->handle.table.name,
+				 cmd->handle.family);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -4447,14 +4453,18 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (cmd->handle.table.name == NULL)
 			return 0;
 
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		return 0;
 	case CMD_OBJ_SET:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		set = set_cache_find(table, cmd->handle.set.name);
@@ -4467,8 +4477,10 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_METER:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		set = set_cache_find(table, cmd->handle.set.name);
@@ -4481,8 +4493,10 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_MAP:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		set = set_cache_find(table, cmd->handle.set.name);
@@ -4495,8 +4509,10 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_CHAIN:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		if (!chain_cache_find(table, cmd->handle.chain.name))
@@ -4504,8 +4520,10 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_FLOWTABLE:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		ft = ft_cache_find(table, cmd->handle.flowtable.name);
@@ -4540,7 +4558,9 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXYS:
 		if (cmd->handle.table.name == NULL)
 			return 0;
-		if (table_lookup(&cmd->handle, &ctx->nft->cache) == NULL)
+		if (!table_cache_find(&ctx->nft->cache.table_cache,
+				      cmd->handle.table.name,
+				      cmd->handle.family))
 			return table_not_found(ctx);
 
 		return 0;
@@ -4563,7 +4583,9 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTAS:
 		if (cmd->handle.table.name == NULL)
 			return 0;
-		if (table_lookup(&cmd->handle, &ctx->nft->cache) == NULL)
+		if (!table_cache_find(&ctx->nft->cache.table_cache,
+				      cmd->handle.table.name,
+				      cmd->handle.family))
 			return table_not_found(ctx);
 
 		return 0;
@@ -4582,6 +4604,7 @@ static void __flush_set_cache(struct set *set)
 
 static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	struct cache *table_cache = &ctx->nft->cache.table_cache;
 	struct table *table;
 	struct set *set;
 
@@ -4596,8 +4619,9 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		/* Chains don't hold sets */
 		break;
 	case CMD_OBJ_SET:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(table_cache, cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		set = set_cache_find(table, cmd->handle.set.name);
@@ -4612,8 +4636,9 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_MAP:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(table_cache, cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		set = set_cache_find(table, cmd->handle.set.name);
@@ -4628,8 +4653,9 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_METER:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(table_cache, cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		set = set_cache_find(table, cmd->handle.set.name);
@@ -4655,8 +4681,10 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		table = table_lookup(&ctx->cmd->handle, &ctx->nft->cache);
-		if (table == NULL)
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name,
+					 cmd->handle.family);
+		if (!table)
 			return table_not_found(ctx);
 
 		if (!chain_cache_find(table, ctx->cmd->handle.chain.name))
diff --git a/src/json.c b/src/json.c
index 9358cbc3da8d..b4197b2fef0c 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1603,7 +1603,7 @@ static json_t *do_list_ruleset_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	json_t *root = json_array(), *tmp;
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (family != NFPROTO_UNSPEC &&
 		    table->handle.family != family)
 			continue;
@@ -1622,7 +1622,7 @@ static json_t *do_list_tables_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	json_t *root = json_array();
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (family != NFPROTO_UNSPEC &&
 		    table->handle.family != family)
 			continue;
@@ -1669,7 +1669,7 @@ static json_t *do_list_chains_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct chain *chain;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1702,7 +1702,7 @@ static json_t *do_list_sets_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct set *set;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1731,7 +1731,7 @@ static json_t *do_list_obj_json(struct netlink_ctx *ctx,
 	struct table *table;
 	struct obj *obj;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1774,7 +1774,7 @@ static json_t *do_list_flowtables_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct flowtable *flowtable;
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1802,7 +1802,9 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	json_t *root;
 
 	if (cmd->handle.table.name)
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name,
+					 cmd->handle.family);
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
diff --git a/src/libnftables.c b/src/libnftables.c
index 56c51a6104ac..e080eb032770 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -105,6 +105,7 @@ static void nft_init(struct nft_ctx *ctx)
 
 static void nft_exit(struct nft_ctx *ctx)
 {
+	cache_free(&ctx->cache.table_cache);
 	expr_handler_exit();
 	ct_label_table_exit(ctx);
 	realm_table_rt_exit(ctx);
@@ -166,7 +167,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	ctx->state = xzalloc(sizeof(struct parser_state));
 	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
 	ctx->parser_max_errors	= 10;
-	init_list_head(&ctx->cache.list);
+	cache_init(&ctx->cache.table_cache);
 	ctx->top_scope = scope_alloc();
 	ctx->flags = flags;
 	ctx->output.output_fp = stdout;
diff --git a/src/monitor.c b/src/monitor.c
index 00cf7d135034..144fe96c2898 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -575,7 +575,7 @@ static void netlink_events_cache_addtable(struct netlink_mon_handler *monh,
 	t = netlink_delinearize_table(monh->ctx, nlt);
 	nftnl_table_free(nlt);
 
-	table_add_hash(t, &monh->ctx->nft->cache);
+	table_cache_add(t, &monh->ctx->nft->cache);
 }
 
 static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
@@ -589,11 +589,12 @@ static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
 	h.family = nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY);
 	h.table.name  = nftnl_table_get_str(nlt, NFTNL_TABLE_NAME);
 
-	t = table_lookup(&h, &monh->ctx->nft->cache);
+	t = table_cache_find(&monh->ctx->nft->cache.table_cache,
+			     h.table.name, h.family);
 	if (t == NULL)
 		goto out;
 
-	list_del(&t->list);
+	table_cache_del(t);
 	table_free(t);
 out:
 	nftnl_table_free(nlt);
@@ -619,7 +620,8 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 		goto out;
 	s->init = set_expr_alloc(monh->loc, s);
 
-	t = table_lookup(&s->handle, &monh->ctx->nft->cache);
+	t = table_cache_find(&monh->ctx->nft->cache.table_cache,
+			     s->handle.table.name, s->handle.family);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache set: table not found.\n");
 		set_free(s);
@@ -720,7 +722,8 @@ static void netlink_events_cache_addobj(struct netlink_mon_handler *monh,
 	if (obj == NULL)
 		goto out;
 
-	t = table_lookup(&obj->handle, &monh->ctx->nft->cache);
+	t = table_cache_find(&monh->ctx->nft->cache.table_cache,
+			     obj->handle.table.name, obj->handle.family);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache object: table not found.\n");
 		obj_free(obj);
@@ -750,7 +753,8 @@ static void netlink_events_cache_delobj(struct netlink_mon_handler *monh,
 	type	 = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE);
 	h.handle.id	= nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
 
-	t = table_lookup(&h, &monh->ctx->nft->cache);
+	t = table_cache_find(&monh->ctx->nft->cache.table_cache,
+			     h.table.name, h.family);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache object: table not found.\n");
 		goto out;
diff --git a/src/netlink.c b/src/netlink.c
index 5ed6d32fb292..e4926a80d79a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1695,7 +1695,7 @@ static struct rule *trace_lookup_rule(const struct nftnl_trace *nlt,
 	if (!h.table.name)
 		return NULL;
 
-	table = table_lookup(&h, cache);
+	table = table_cache_find(&cache->table_cache, h.table.name, h.family);
 	if (!table)
 		return NULL;
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 710c668a0258..d82d9f51f482 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1792,7 +1792,9 @@ struct stmt *netlink_parse_set_expr(const struct set *set,
 
 	handle_merge(&h, &set->handle);
 	pctx->rule = rule_alloc(&netlink_location, &h);
-	pctx->table = table_lookup(&set->handle, cache);
+	pctx->table = table_cache_find(&cache->table_cache,
+				       set->handle.table.name,
+				       set->handle.family);
 	assert(pctx->table != NULL);
 
 	if (netlink_parse_expr(nle, pctx) < 0)
@@ -2938,7 +2940,8 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 		h.position.id = nftnl_rule_get_u64(nlr, NFTNL_RULE_POSITION);
 
 	pctx->rule = rule_alloc(&netlink_location, &h);
-	pctx->table = table_lookup(&h, &ctx->nft->cache);
+	pctx->table = table_cache_find(&ctx->nft->cache.table_cache,
+				       h.table.name, h.family);
 	assert(pctx->table != NULL);
 
 	pctx->rule->comment = nftnl_rule_get_comment(nlr);
diff --git a/src/rule.c b/src/rule.c
index 95016320dfd3..07a541a20bb9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -211,7 +211,7 @@ struct set *set_lookup_fuzzy(const char *set_name,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
 		list_for_each_entry(set, &table->set_cache.list, cache.list) {
 			if (set_is_anonymous(set->flags))
 				continue;
@@ -230,13 +230,9 @@ struct set *set_lookup_fuzzy(const char *set_name,
 struct set *set_lookup_global(uint32_t family, const char *table,
 			      const char *name, struct nft_cache *cache)
 {
-	struct handle h;
 	struct table *t;
 
-	h.family = family;
-	h.table.name = table;
-
-	t = table_lookup(&h, cache);
+	t = table_cache_find(&cache->table_cache, table, family);
 	if (t == NULL)
 		return NULL;
 
@@ -767,7 +763,7 @@ struct chain *chain_lookup_fuzzy(const struct handle *h,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
 		list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
 			if (!strcmp(chain->handle.chain.name, h->chain.name)) {
 				*t = table;
@@ -1169,24 +1165,6 @@ struct table *table_get(struct table *table)
 	return table;
 }
 
-void table_add_hash(struct table *table, struct nft_cache *cache)
-{
-	list_add_tail(&table->list, &cache->list);
-}
-
-struct table *table_lookup(const struct handle *h,
-			   const struct nft_cache *cache)
-{
-	struct table *table;
-
-	list_for_each_entry(table, &cache->list, list) {
-		if (table->handle.family == h->family &&
-		    !strcmp(table->handle.table.name, h->table.name))
-			return table;
-	}
-	return NULL;
-}
-
 struct table *table_lookup_fuzzy(const struct handle *h,
 				 const struct nft_cache *cache)
 {
@@ -1195,7 +1173,7 @@ struct table *table_lookup_fuzzy(const struct handle *h,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
 		if (!strcmp(table->handle.table.name, h->table.name))
 			return table;
 
@@ -1683,7 +1661,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct set *set;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1748,7 +1726,7 @@ struct obj *obj_lookup_fuzzy(const char *obj_name,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
 		list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
 			if (!strcmp(obj->handle.obj.name, obj_name)) {
 				*t = table;
@@ -2085,7 +2063,7 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 	struct table *table;
 	struct obj *obj;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -2226,7 +2204,7 @@ struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->table_cache.list, cache.list) {
 		list_for_each_entry(ft, &table->ft_cache.list, cache.list) {
 			if (!strcmp(ft->handle.flowtable.name, ft_name)) {
 				*t = table;
@@ -2269,7 +2247,7 @@ static int do_list_flowtables(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct flowtable *flowtable;
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -2293,7 +2271,7 @@ static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 	unsigned int family = cmd->handle.family;
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (family != NFPROTO_UNSPEC &&
 		    table->handle.family != family)
 			continue;
@@ -2314,7 +2292,7 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -2360,7 +2338,7 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct chain *chain;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -2413,8 +2391,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_list_json(ctx, cmd);
 
 	if (cmd->handle.table.name != NULL)
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
-
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 cmd->handle.table.name,
+					 cmd->handle.family);
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		if (!cmd->handle.table.name)
@@ -2540,7 +2519,9 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	ret = netlink_reset_objs(ctx, cmd, type, dump);
 	list_for_each_entry_safe(obj, next, &ctx->list, list) {
-		table = table_lookup(&obj->handle, &ctx->nft->cache);
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 obj->handle.table.name,
+					 obj->handle.family);
 		if (!obj_cache_find(table, obj->handle.obj.name, obj->type)) {
 			list_del(&obj->list);
 			obj_cache_add(obj, table);
@@ -2572,7 +2553,9 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table = table_lookup(&cmd->handle, &ctx->nft->cache);
+	struct table *table = table_cache_find(&ctx->nft->cache.table_cache,
+					       cmd->handle.table.name,
+					       cmd->handle.family);
 	const struct chain *chain;
 
 	switch (cmd->obj) {
-- 
2.20.1

