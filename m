Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46CFC433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80AFD61249
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhDONOS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:14:18 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57880 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbhDONOB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 09:14:01 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 262AC63E85
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2021 15:13:11 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 09/10] cache: add hashtable cache for table
Date:   Thu, 15 Apr 2021 15:13:29 +0200
Message-Id: <20210415131330.6692-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210415131330.6692-1-pablo@netfilter.org>
References: <20210415131330.6692-1-pablo@netfilter.org>
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
 include/cache.h           |  8 ++++++-
 include/rule.h            |  5 ++--
 src/cache.c               | 43 +++++++++++++++++++++++++++++++----
 src/evaluate.c            | 40 ++++++++++++++++----------------
 src/json.c                | 14 ++++++------
 src/libnftables.c         |  8 +++++++
 src/monitor.c             | 12 +++++-----
 src/netlink.c             |  2 +-
 src/netlink_delinearize.c |  4 ++--
 src/rule.c                | 48 ++++++++++++---------------------------
 10 files changed, 107 insertions(+), 77 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index cab8a6bcca05..de27697072a1 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -5,7 +5,8 @@
 
 struct nft_cache {
 	uint32_t		genid;
-	struct list_head	list;
+	struct list_head        *ht;
+	struct list_head        list;
 	uint32_t		seqnum;
 	uint32_t		flags;
 };
@@ -65,6 +66,11 @@ int cache_init(struct netlink_ctx *ctx, unsigned int flags);
 int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs);
 void cache_release(struct nft_cache *cache);
 
+void table_cache_add(struct table *table, struct nft_cache *cache);
+void table_cache_del(struct table *table);
+struct table *table_cache_find(const struct handle *h,
+			       const struct nft_cache *cache);
+
 void chain_cache_add(struct chain *chain, struct table *table);
 struct chain *chain_cache_find(const struct table *table,
 			       const struct handle *handle);
diff --git a/include/rule.h b/include/rule.h
index 44e057ab341f..a39788284bc1 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -152,6 +152,8 @@ const char *table_flag_name(uint32_t flag);
  */
 struct table {
 	struct list_head	list;
+	struct list_head	cache_hlist;
+	struct list_head	cache_list;
 	struct handle		handle;
 	struct location		location;
 	struct scope		scope;
@@ -177,9 +179,6 @@ struct table {
 extern struct table *table_alloc(void);
 extern struct table *table_get(struct table *table);
 extern void table_free(struct table *table);
-extern void table_add_hash(struct table *table, struct nft_cache *cache);
-extern struct table *table_lookup(const struct handle *h,
-				  const struct nft_cache *cache);
 extern struct table *table_lookup_fuzzy(const struct handle *h,
 					const struct nft_cache *cache);
 
diff --git a/src/cache.c b/src/cache.c
index 8590e14cfa33..8bb9688e8eb4 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -173,6 +173,37 @@ unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 	return flags;
 }
 
+void table_cache_add(struct table *table, struct nft_cache *cache)
+{
+	uint32_t hash;
+
+	hash = djb_hash(table->handle.table.name) % NFT_CACHE_HSIZE;
+	list_add_tail(&table->cache_hlist, &cache->ht[hash]);
+	list_add_tail(&table->cache_list, &cache->list);
+}
+
+void table_cache_del(struct table *table)
+{
+	list_del(&table->cache_hlist);
+	list_del(&table->cache_list);
+}
+
+struct table *table_cache_find(const struct handle *handle,
+			       const struct nft_cache *cache)
+{
+	struct table *table;
+	uint32_t hash;
+
+	hash = djb_hash(handle->table.name) % NFT_CACHE_HSIZE;
+	list_for_each_entry(table, &cache->ht[hash], cache_hlist) {
+		if (table->handle.family == handle->family &&
+		    !strcmp(table->handle.table.name, handle->table.name))
+			return table;
+	}
+
+	return NULL;
+}
+
 struct chain_cache_dump_ctx {
 	struct netlink_ctx	*nlctx;
 	struct table		*table;
@@ -518,13 +549,17 @@ struct flowtable *ft_cache_find(const struct table *table, const char *name)
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
@@ -547,7 +582,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 			return -1;
 	}
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (flags & NFT_CACHE_SET_BIT) {
 			set_list = set_cache_dump(ctx, table, &ret);
 			if (!set_list) {
@@ -733,8 +768,8 @@ static void __cache_flush(struct list_head *table_list)
 {
 	struct table *table, *next;
 
-	list_for_each_entry_safe(table, next, table_list, list) {
-		list_del(&table->list);
+	list_for_each_entry_safe(table, next, table_list, cache_list) {
+		table_cache_del(table);
 		table_free(table);
 	}
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index 72cf756bbb5c..c33e7268d655 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -173,7 +173,7 @@ static struct table *table_lookup_global(struct eval_ctx *ctx)
 	if (ctx->table != NULL)
 		return ctx->table;
 
-	table = table_lookup(&ctx->cmd->handle, &ctx->nft->cache);
+	table = table_cache_find(&ctx->cmd->handle, &ctx->nft->cache);
 	if (table == NULL)
 		return NULL;
 
@@ -3969,7 +3969,7 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
 	struct table *table;
 	struct chain *chain;
 
-	table = table_lookup(&rule->handle, &ctx->nft->cache);
+	table = table_cache_find(&rule->handle, &ctx->nft->cache);
 	if (!table)
 		return table_not_found(ctx);
 
@@ -4238,13 +4238,13 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 	struct set *set;
 	struct obj *obj;
 
-	if (table_lookup(&ctx->cmd->handle, &ctx->nft->cache) == NULL) {
+	if (table_cache_find(&ctx->cmd->handle, &ctx->nft->cache) == NULL) {
 		if (table == NULL) {
 			table = table_alloc();
 			handle_merge(&table->handle, &ctx->cmd->handle);
-			table_add_hash(table, &ctx->nft->cache);
+			table_cache_add(table, &ctx->nft->cache);
 		} else {
-			table_add_hash(table_get(table), &ctx->nft->cache);
+			table_cache_add(table_get(table), &ctx->nft->cache);
 		}
 	}
 
@@ -4316,11 +4316,11 @@ static void table_del_cache(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 
-	table = table_lookup(&cmd->handle, &ctx->nft->cache);
+	table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 	if (!table)
 		return;
 
-	list_del(&table->list);
+	table_cache_del(table);
 	table_free(table);
 }
 
@@ -4386,7 +4386,7 @@ static int cmd_evaluate_list_obj(struct eval_ctx *ctx, const struct cmd *cmd,
 	if (obj_type == NFT_OBJECT_UNSPEC)
 		obj_type = NFT_OBJECT_COUNTER;
 
-	table = table_lookup(&cmd->handle, &ctx->nft->cache);
+	table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 	if (table == NULL)
 		return table_not_found(ctx);
 
@@ -4408,13 +4408,13 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (cmd->handle.table.name == NULL)
 			return 0;
 
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
 		return 0;
 	case CMD_OBJ_SET:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -4428,7 +4428,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_METER:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -4442,7 +4442,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_MAP:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -4456,7 +4456,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_CHAIN:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -4465,7 +4465,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_FLOWTABLE:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -4501,7 +4501,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SYNPROXYS:
 		if (cmd->handle.table.name == NULL)
 			return 0;
-		if (table_lookup(&cmd->handle, &ctx->nft->cache) == NULL)
+		if (table_cache_find(&cmd->handle, &ctx->nft->cache) == NULL)
 			return table_not_found(ctx);
 
 		return 0;
@@ -4524,7 +4524,7 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTAS:
 		if (cmd->handle.table.name == NULL)
 			return 0;
-		if (table_lookup(&cmd->handle, &ctx->nft->cache) == NULL)
+		if (table_cache_find(&cmd->handle, &ctx->nft->cache) == NULL)
 			return table_not_found(ctx);
 
 		return 0;
@@ -4557,7 +4557,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		/* Chains don't hold sets */
 		break;
 	case CMD_OBJ_SET:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -4573,7 +4573,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_MAP:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -4589,7 +4589,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	case CMD_OBJ_METER:
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
@@ -4616,7 +4616,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		table = table_lookup(&ctx->cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&ctx->cmd->handle, &ctx->nft->cache);
 		if (table == NULL)
 			return table_not_found(ctx);
 
diff --git a/src/json.c b/src/json.c
index 29923092d12c..744efc49d04e 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1603,7 +1603,7 @@ static json_t *do_list_ruleset_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	json_t *root = json_array(), *tmp;
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (family != NFPROTO_UNSPEC &&
 		    table->handle.family != family)
 			continue;
@@ -1622,7 +1622,7 @@ static json_t *do_list_tables_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	json_t *root = json_array();
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (family != NFPROTO_UNSPEC &&
 		    table->handle.family != family)
 			continue;
@@ -1669,7 +1669,7 @@ static json_t *do_list_chains_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct chain *chain;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1702,7 +1702,7 @@ static json_t *do_list_sets_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct set *set;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1731,7 +1731,7 @@ static json_t *do_list_obj_json(struct netlink_ctx *ctx,
 	struct table *table;
 	struct obj *obj;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1774,7 +1774,7 @@ static json_t *do_list_flowtables_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct flowtable *flowtable;
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1802,7 +1802,7 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	json_t *root;
 
 	if (cmd->handle.table.name)
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
diff --git a/src/libnftables.c b/src/libnftables.c
index 044365914747..8c1e4c34f682 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -96,15 +96,23 @@ out:
 
 static void nft_init(struct nft_ctx *ctx)
 {
+	int i;
+
 	mark_table_init(ctx);
 	realm_table_rt_init(ctx);
 	devgroup_table_init(ctx);
 	ct_label_table_init(ctx);
 	expr_handler_init();
+
+	init_list_head(&ctx->cache.list);
+	ctx->cache.ht = xmalloc(sizeof(struct list_head) * NFT_CACHE_HSIZE);
+	for (i = 0; i < NFT_CACHE_HSIZE; i++)
+		init_list_head(&ctx->cache.ht[i]);
 }
 
 static void nft_exit(struct nft_ctx *ctx)
 {
+	xfree(ctx->cache.ht);
 	expr_handler_exit();
 	ct_label_table_exit(ctx);
 	realm_table_rt_exit(ctx);
diff --git a/src/monitor.c b/src/monitor.c
index eb887d9344fa..5745633610d2 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -575,7 +575,7 @@ static void netlink_events_cache_addtable(struct netlink_mon_handler *monh,
 	t = netlink_delinearize_table(monh->ctx, nlt);
 	nftnl_table_free(nlt);
 
-	table_add_hash(t, &monh->ctx->nft->cache);
+	table_cache_add(t, &monh->ctx->nft->cache);
 }
 
 static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
@@ -589,11 +589,11 @@ static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
 	h.family = nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY);
 	h.table.name  = nftnl_table_get_str(nlt, NFTNL_TABLE_NAME);
 
-	t = table_lookup(&h, &monh->ctx->nft->cache);
+	t = table_cache_find(&h, &monh->ctx->nft->cache);
 	if (t == NULL)
 		goto out;
 
-	list_del(&t->list);
+	table_cache_del(t);
 	table_free(t);
 out:
 	nftnl_table_free(nlt);
@@ -619,7 +619,7 @@ static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 		goto out;
 	s->init = set_expr_alloc(monh->loc, s);
 
-	t = table_lookup(&s->handle, &monh->ctx->nft->cache);
+	t = table_cache_find(&s->handle, &monh->ctx->nft->cache);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache set: table not found.\n");
 		set_free(s);
@@ -720,7 +720,7 @@ static void netlink_events_cache_addobj(struct netlink_mon_handler *monh,
 	if (obj == NULL)
 		goto out;
 
-	t = table_lookup(&obj->handle, &monh->ctx->nft->cache);
+	t = table_cache_find(&obj->handle, &monh->ctx->nft->cache);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache object: table not found.\n");
 		obj_free(obj);
@@ -750,7 +750,7 @@ static void netlink_events_cache_delobj(struct netlink_mon_handler *monh,
 	type	 = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE);
 	h.handle.id	= nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
 
-	t = table_lookup(&h, &monh->ctx->nft->cache);
+	t = table_cache_find(&h, &monh->ctx->nft->cache);
 	if (t == NULL) {
 		fprintf(stderr, "W: Unable to cache object: table not found.\n");
 		goto out;
diff --git a/src/netlink.c b/src/netlink.c
index 5b2ad676f3e5..3ed49c10bbee 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1695,7 +1695,7 @@ static struct rule *trace_lookup_rule(const struct nftnl_trace *nlt,
 	if (!h.table.name)
 		return NULL;
 
-	table = table_lookup(&h, cache);
+	table = table_cache_find(&h, cache);
 	if (!table)
 		return NULL;
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 710c668a0258..9e282a61708c 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1792,7 +1792,7 @@ struct stmt *netlink_parse_set_expr(const struct set *set,
 
 	handle_merge(&h, &set->handle);
 	pctx->rule = rule_alloc(&netlink_location, &h);
-	pctx->table = table_lookup(&set->handle, cache);
+	pctx->table = table_cache_find(&set->handle, cache);
 	assert(pctx->table != NULL);
 
 	if (netlink_parse_expr(nle, pctx) < 0)
@@ -2938,7 +2938,7 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 		h.position.id = nftnl_rule_get_u64(nlr, NFTNL_RULE_POSITION);
 
 	pctx->rule = rule_alloc(&netlink_location, &h);
-	pctx->table = table_lookup(&h, &ctx->nft->cache);
+	pctx->table = table_cache_find(&h, &ctx->nft->cache);
 	assert(pctx->table != NULL);
 
 	pctx->rule->comment = nftnl_rule_get_comment(nlr);
diff --git a/src/rule.c b/src/rule.c
index a6909fc75060..106d8c33cf6b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -211,7 +211,7 @@ struct set *set_lookup_fuzzy(const char *set_name,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->list, cache_list) {
 		list_for_each_entry(set, &table->cache_set, cache_list) {
 			if (set_is_anonymous(set->flags))
 				continue;
@@ -236,7 +236,7 @@ struct set *set_lookup_global(uint32_t family, const char *table,
 	h.family = family;
 	h.table.name = table;
 
-	t = table_lookup(&h, cache);
+	t = table_cache_find(&h, cache);
 	if (t == NULL)
 		return NULL;
 
@@ -767,7 +767,7 @@ struct chain *chain_lookup_fuzzy(const struct handle *h,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->list, cache_list) {
 		list_for_each_entry(chain, &table->cache_chain, cache_list) {
 			if (!strcmp(chain->handle.chain.name, h->chain.name)) {
 				*t = table;
@@ -1189,24 +1189,6 @@ struct table *table_get(struct table *table)
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
@@ -1215,7 +1197,7 @@ struct table *table_lookup_fuzzy(const struct handle *h,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->list, cache_list) {
 		if (!strcmp(table->handle.table.name, h->table.name))
 			return table;
 
@@ -1703,7 +1685,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct set *set;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -1768,7 +1750,7 @@ struct obj *obj_lookup_fuzzy(const char *obj_name,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->list, cache_list) {
 		list_for_each_entry(obj, &table->cache_obj, cache_list) {
 			if (!strcmp(obj->handle.obj.name, obj_name)) {
 				*t = table;
@@ -2105,7 +2087,7 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 	struct table *table;
 	struct obj *obj;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -2246,7 +2228,7 @@ struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 
 	string_misspell_init(&st);
 
-	list_for_each_entry(table, &cache->list, list) {
+	list_for_each_entry(table, &cache->list, cache_list) {
 		list_for_each_entry(ft, &table->cache_ft, cache_list) {
 			if (!strcmp(ft->handle.flowtable.name, ft_name)) {
 				*t = table;
@@ -2289,7 +2271,7 @@ static int do_list_flowtables(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct flowtable *flowtable;
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -2313,7 +2295,7 @@ static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 	unsigned int family = cmd->handle.family;
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (family != NFPROTO_UNSPEC &&
 		    table->handle.family != family)
 			continue;
@@ -2334,7 +2316,7 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -2380,7 +2362,7 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table;
 	struct chain *chain;
 
-	list_for_each_entry(table, &ctx->nft->cache.list, list) {
+	list_for_each_entry(table, &ctx->nft->cache.list, cache_list) {
 		if (cmd->handle.family != NFPROTO_UNSPEC &&
 		    cmd->handle.family != table->handle.family)
 			continue;
@@ -2433,7 +2415,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_command_list_json(ctx, cmd);
 
 	if (cmd->handle.table.name != NULL)
-		table = table_lookup(&cmd->handle, &ctx->nft->cache);
+		table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -2560,7 +2542,7 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	ret = netlink_reset_objs(ctx, cmd, type, dump);
 	list_for_each_entry_safe(obj, next, &ctx->list, list) {
-		table = table_lookup(&obj->handle, &ctx->nft->cache);
+		table = table_cache_find(&obj->handle, &ctx->nft->cache);
 		if (!obj_cache_find(table, obj->handle.obj.name, obj->type)) {
 			list_del(&obj->list);
 			obj_cache_add(obj, table);
@@ -2592,7 +2574,7 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table = table_lookup(&cmd->handle, &ctx->nft->cache);
+	struct table *table = table_cache_find(&cmd->handle, &ctx->nft->cache);
 	const struct chain *chain;
 
 	switch (cmd->obj) {
-- 
2.20.1

