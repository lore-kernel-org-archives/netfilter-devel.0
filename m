Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF78C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25E4C61249
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhDONN6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:13:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57868 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhDONN6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 09:13:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 75D6E63E77
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2021 15:13:07 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 01/10] cache: add hashtable cache for object
Date:   Thu, 15 Apr 2021 15:13:21 +0200
Message-Id: <20210415131330.6692-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210415131330.6692-1-pablo@netfilter.org>
References: <20210415131330.6692-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a hashtable for object lookups.

This patch also splits table->objs in two:

- Sets that reside in the cache are stored in the new
  tables->cache_obj and tables->cache_obj_ht.

- Set that defined via command line / ruleset file reside in
  tables->obj.

Sets in the cache (already in the kernel) are not placed in the
table->objs list.

By keeping separated lists, objs defined via command line / ruleset file
can be added to cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h |   5 +++
 include/rule.h  |   7 ++--
 src/cache.c     | 101 +++++++++++++++++++++++++++++++++++++++++++++++-
 src/evaluate.c  |   2 +-
 src/json.c      |   4 +-
 src/monitor.c   |   6 +--
 src/netlink.c   |  19 ---------
 src/rule.c      |  43 +++++++++------------
 8 files changed, 133 insertions(+), 54 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index f500e1b19e45..b0458dc9c284 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -62,4 +62,9 @@ struct chain *chain_cache_find(const struct table *table,
 void set_cache_add(struct set *set, struct table *table);
 struct set *set_cache_find(const struct table *table, const char *name);
 
+void obj_cache_add(struct obj *obj, struct table *table);
+void obj_cache_del(struct obj *obj);
+struct obj *obj_cache_find(const struct table *table, const char *name,
+			   uint32_t obj_type);
+
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/rule.h b/include/rule.h
index 90c01e9014c8..226171a8def7 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -161,6 +161,8 @@ struct table {
 	struct list_head	*cache_set_ht;
 	struct list_head	cache_set;
 	struct list_head	sets;
+	struct list_head	*cache_obj_ht;
+	struct list_head	cache_obj;
 	struct list_head	objs;
 	struct list_head	flowtables;
 	struct list_head	chain_bindings;
@@ -488,6 +490,8 @@ struct secmark {
  */
 struct obj {
 	struct list_head		list;
+	struct list_head		cache_hlist;
+	struct list_head		cache_list;
 	struct location			location;
 	struct handle			handle;
 	uint32_t			type;
@@ -508,9 +512,6 @@ struct obj {
 struct obj *obj_alloc(const struct location *loc);
 extern struct obj *obj_get(struct obj *obj);
 void obj_free(struct obj *obj);
-void obj_add_hash(struct obj *obj, struct table *table);
-struct obj *obj_lookup(const struct table *table, const char *name,
-		       uint32_t type);
 struct obj *obj_lookup_fuzzy(const char *obj_name,
 			     const struct nft_cache *cache,
 			     const struct table **t);
diff --git a/src/cache.c b/src/cache.c
index f032171a95ff..baf8dc12e5b6 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -338,6 +338,95 @@ struct set *set_cache_find(const struct table *table, const char *name)
 	return NULL;
 }
 
+struct obj_cache_dump_ctx {
+	struct netlink_ctx	*nlctx;
+	struct table		*table;
+};
+
+static int obj_cache_cb(struct nftnl_obj *nlo, void *arg)
+{
+	struct obj_cache_dump_ctx *ctx = arg;
+	const char *obj_name;
+	struct obj *obj;
+	uint32_t hash;
+
+	obj = netlink_delinearize_obj(ctx->nlctx, nlo);
+	if (!obj)
+		return -1;
+
+	obj_name = nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME);
+	hash = djb_hash(obj_name) % NFT_CACHE_HSIZE;
+	list_add_tail(&obj->cache_hlist, &ctx->table->cache_obj_ht[hash]);
+	list_add_tail(&obj->cache_list, &ctx->table->cache_obj);
+
+	return 0;
+}
+
+static int obj_cache_init(struct netlink_ctx *ctx, struct table *table,
+			  struct nftnl_obj_list *obj_list)
+{
+	struct obj_cache_dump_ctx dump_ctx = {
+		.nlctx	= ctx,
+		.table	= table,
+	};
+	nftnl_obj_list_foreach(obj_list, obj_cache_cb, &dump_ctx);
+
+	return 0;
+}
+
+static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
+					     const struct table *table,
+					     int *err)
+{
+	struct nftnl_obj_list *obj_list;
+
+	obj_list = mnl_nft_obj_dump(ctx, table->handle.family,
+				    table->handle.table.name, NULL,
+				    0, true, false);
+	if (!obj_list) {
+                if (errno == EINTR) {
+			*err = -1;
+			return NULL;
+		}
+		*err = 0;
+		return NULL;
+	}
+
+	return obj_list;
+}
+
+void obj_cache_add(struct obj *obj, struct table *table)
+{
+	uint32_t hash;
+
+	hash = djb_hash(obj->handle.obj.name) % NFT_CACHE_HSIZE;
+	list_add_tail(&obj->cache_hlist, &table->cache_obj_ht[hash]);
+	list_add_tail(&obj->cache_list, &table->cache_obj);
+}
+
+void obj_cache_del(struct obj *obj)
+{
+	list_del(&obj->cache_hlist);
+	list_del(&obj->cache_list);
+}
+
+struct obj *obj_cache_find(const struct table *table, const char *name,
+			   uint32_t obj_type)
+{
+	struct obj *obj;
+	uint32_t hash;
+
+	hash = djb_hash(name) % NFT_CACHE_HSIZE;
+	list_for_each_entry(obj, &table->cache_obj_ht[hash], cache_hlist) {
+		if (!strcmp(obj->handle.obj.name, name) &&
+		    obj->type == obj_type)
+			return obj;
+	}
+
+	return NULL;
+}
+
+
 static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 			     struct nft_cache *cache)
 {
@@ -356,6 +445,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 {
 	struct nftnl_chain_list *chain_list = NULL;
 	struct nftnl_set_list *set_list = NULL;
+	struct nftnl_obj_list *obj_list;
 	struct rule *rule, *nrule;
 	struct table *table;
 	struct chain *chain;
@@ -410,12 +500,19 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 			list_splice_tail_init(&ctx->list, &table->flowtables);
 		}
 		if (flags & NFT_CACHE_OBJECT_BIT) {
-			ret = netlink_list_objs(ctx, &table->handle);
+			obj_list = obj_cache_dump(ctx, table, &ret);
+			if (!obj_list) {
+				ret = -1;
+				goto cache_fails;
+			}
+			ret = obj_cache_init(ctx, table, obj_list);
+
+			nftnl_obj_list_free(obj_list);
+
 			if (ret < 0) {
 				ret = -1;
 				goto cache_fails;
 			}
-			list_splice_tail_init(&ctx->list, &table->objs);
 		}
 
 		if (flags & NFT_CACHE_RULE_BIT) {
diff --git a/src/evaluate.c b/src/evaluate.c
index 85cf9e05b641..d33a152c3de4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4373,7 +4373,7 @@ static int cmd_evaluate_list_obj(struct eval_ctx *ctx, const struct cmd *cmd,
 	if (table == NULL)
 		return table_not_found(ctx);
 
-	if (obj_lookup(table, cmd->handle.obj.name, obj_type) == NULL)
+	if (obj_cache_find(table, cmd->handle.obj.name, obj_type) == NULL)
 		return obj_not_found(ctx, &cmd->handle.obj.location,
 				     cmd->handle.obj.name);
 
diff --git a/src/json.c b/src/json.c
index 52603a57de50..bf151e927661 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1570,7 +1570,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 	tmp = table_print_json(table);
 	json_array_append_new(root, tmp);
 
-	list_for_each_entry(obj, &table->objs, list) {
+	list_for_each_entry(obj, &table->cache_obj, cache_list) {
 		tmp = obj_print_json(obj);
 		json_array_append_new(root, tmp);
 	}
@@ -1740,7 +1740,7 @@ static json_t *do_list_obj_json(struct netlink_ctx *ctx,
 		    strcmp(cmd->handle.table.name, table->handle.table.name))
 			continue;
 
-		list_for_each_entry(obj, &table->objs, list) {
+		list_for_each_entry(obj, &table->cache_obj, cache_list) {
 			if (obj->type != type ||
 			    (cmd->handle.obj.name &&
 			     strcmp(cmd->handle.obj.name, obj->handle.obj.name)))
diff --git a/src/monitor.c b/src/monitor.c
index dc3f0848ba66..1f0f8a361fbd 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -727,7 +727,7 @@ static void netlink_events_cache_addobj(struct netlink_mon_handler *monh,
 		goto out;
 	}
 
-	obj_add_hash(obj, t);
+	obj_cache_add(obj, t);
 out:
 	nftnl_obj_free(nlo);
 }
@@ -756,13 +756,13 @@ static void netlink_events_cache_delobj(struct netlink_mon_handler *monh,
 		goto out;
 	}
 
-	obj = obj_lookup(t, name, type);
+	obj = obj_cache_find(t, name, type);
 	if (obj == NULL) {
 		fprintf(stderr, "W: Unable to find object in cache\n");
 		goto out;
 	}
 
-	list_del(&obj->list);
+	obj_cache_del(obj);
 	obj_free(obj);
 out:
 	nftnl_obj_free(nlo);
diff --git a/src/netlink.c b/src/netlink.c
index e8b016096b67..2286a6ffabf8 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1517,25 +1517,6 @@ static int list_obj_cb(struct nftnl_obj *nls, void *arg)
 	return 0;
 }
 
-int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h)
-{
-	struct nftnl_obj_list *obj_cache;
-	int err;
-
-	obj_cache = mnl_nft_obj_dump(ctx, h->family,
-				     h->table.name, NULL, 0, true, false);
-	if (obj_cache == NULL) {
-		if (errno == EINTR)
-			return -1;
-
-		return 0;
-	}
-
-	err = nftnl_obj_list_foreach(obj_cache, list_obj_cb, ctx);
-	nftnl_obj_list_free(obj_cache);
-	return err;
-}
-
 int netlink_reset_objs(struct netlink_ctx *ctx, const struct cmd *cmd,
 		       uint32_t type, bool dump)
 {
diff --git a/src/rule.c b/src/rule.c
index 2c6292c4e173..b78d4e7f9cd3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1110,6 +1110,7 @@ struct table *table_alloc(void)
 	init_list_head(&table->sets);
 	init_list_head(&table->cache_set);
 	init_list_head(&table->objs);
+	init_list_head(&table->cache_obj);
 	init_list_head(&table->flowtables);
 	init_list_head(&table->chain_bindings);
 	init_list_head(&table->scope.symbols);
@@ -1125,6 +1126,11 @@ struct table *table_alloc(void)
 	for (i = 0; i < NFT_CACHE_HSIZE; i++)
 		init_list_head(&table->cache_set_ht[i]);
 
+	table->cache_obj_ht =
+		xmalloc(sizeof(struct list_head) * NFT_CACHE_HSIZE);
+	for (i = 0; i < NFT_CACHE_HSIZE; i++)
+		init_list_head(&table->cache_obj_ht[i]);
+
 	return table;
 }
 
@@ -1155,10 +1161,15 @@ void table_free(struct table *table)
 		flowtable_free(ft);
 	list_for_each_entry_safe(obj, nobj, &table->objs, list)
 		obj_free(obj);
+	/* this is implicitly releasing objs in the hashtable cache */
+	list_for_each_entry_safe(obj, nobj, &table->cache_obj, cache_list)
+		obj_free(obj);
+
 	handle_free(&table->handle);
 	scope_release(&table->scope);
 	xfree(table->cache_chain_ht);
 	xfree(table->cache_set_ht);
+	xfree(table->cache_obj_ht);
 	xfree(table);
 }
 
@@ -1264,7 +1275,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 	if (table->comment)
 		nft_print(octx, "\tcomment \"%s\"\n", table->comment);
 
-	list_for_each_entry(obj, &table->objs, list) {
+	list_for_each_entry(obj, &table->cache_obj, cache_list) {
 		nft_print(octx, "%s", delim);
 		obj_print(obj, octx);
 		delim = "\n";
@@ -1737,24 +1748,6 @@ void obj_free(struct obj *obj)
 	xfree(obj);
 }
 
-void obj_add_hash(struct obj *obj, struct table *table)
-{
-	list_add_tail(&obj->list, &table->objs);
-}
-
-struct obj *obj_lookup(const struct table *table, const char *name,
-		       uint32_t type)
-{
-	struct obj *obj;
-
-	list_for_each_entry(obj, &table->objs, list) {
-		if (!strcmp(obj->handle.obj.name, name) &&
-		    obj->type == type)
-			return obj;
-	}
-	return NULL;
-}
-
 struct obj *obj_lookup_fuzzy(const char *obj_name,
 			     const struct nft_cache *cache,
 			     const struct table **t)
@@ -1766,7 +1759,7 @@ struct obj *obj_lookup_fuzzy(const char *obj_name,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->list, list) {
-		list_for_each_entry(obj, &table->objs, list) {
+		list_for_each_entry(obj, &table->cache_obj, cache_list) {
 			if (!strcmp(obj->handle.obj.name, obj_name)) {
 				*t = table;
 				return obj;
@@ -2111,14 +2104,14 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 		    strcmp(cmd->handle.table.name, table->handle.table.name))
 			continue;
 
-		if (list_empty(&table->objs))
+		if (list_empty(&table->cache_obj))
 			continue;
 
 		nft_print(&ctx->nft->output, "table %s %s {\n",
 			  family2str(table->handle.family),
 			  table->handle.table.name);
 
-		list_for_each_entry(obj, &table->objs, list) {
+		list_for_each_entry(obj, &table->cache_obj, cache_list) {
 			if (obj->type != type ||
 			    (cmd->handle.obj.name != NULL &&
 			     strcmp(cmd->handle.obj.name, obj->handle.obj.name)))
@@ -2574,8 +2567,10 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 	ret = netlink_reset_objs(ctx, cmd, type, dump);
 	list_for_each_entry_safe(obj, next, &ctx->list, list) {
 		table = table_lookup(&obj->handle, &ctx->nft->cache);
-		if (!obj_lookup(table, obj->handle.obj.name, obj->type))
-			list_move(&obj->list, &table->objs);
+		if (!obj_cache_find(table, obj->handle.obj.name, obj->type)) {
+			list_del(&obj->list);
+			obj_cache_add(obj, table);
+		}
 	}
 	if (ret < 0)
 		return ret;
-- 
2.20.1

