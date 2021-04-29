Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2819C43461
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D23346147D
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhD2Xnx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59536 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhD2Xnw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:52 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 659C964145
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 07/18] cache: add hashtable cache for object
Date:   Fri, 30 Apr 2021 01:42:44 +0200
Message-Id: <20210429234255.16840-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
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
 include/cache.h |  5 +++
 include/rule.h  |  5 +--
 src/cache.c     | 98 ++++++++++++++++++++++++++++++++++++++++++++++++-
 src/evaluate.c  |  2 +-
 src/json.c      |  4 +-
 src/monitor.c   |  8 ++--
 src/netlink.c   | 19 ----------
 src/rule.c      | 38 +++++++------------
 8 files changed, 124 insertions(+), 55 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 4d91a73624c8..9605ef96c853 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -87,4 +87,9 @@ void cache_free(struct cache *cache);
 void cache_add(struct cache_item *item, struct cache *cache, uint32_t hash);
 void cache_del(struct cache_item *item);
 
+void obj_cache_add(struct obj *obj, struct table *table);
+void obj_cache_del(struct obj *obj);
+struct obj *obj_cache_find(const struct table *table, const char *name,
+			   uint32_t obj_type);
+
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/rule.h b/include/rule.h
index b238c85bcba9..f264bc8a1a01 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -157,6 +157,7 @@ struct table {
 	struct scope		scope;
 	struct cache		chain_cache;
 	struct cache		set_cache;
+	struct cache		obj_cache;
 	struct list_head	chains;
 	struct list_head	sets;
 	struct list_head	objs;
@@ -484,6 +485,7 @@ struct secmark {
  */
 struct obj {
 	struct list_head		list;
+	struct cache_item		cache;
 	struct location			location;
 	struct handle			handle;
 	uint32_t			type;
@@ -504,9 +506,6 @@ struct obj {
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
index 70e47064848e..b2f796ec9975 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -333,6 +333,92 @@ struct set *set_cache_find(const struct table *table, const char *name)
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
+	cache_add(&obj->cache, &ctx->table->obj_cache, hash);
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
+	cache_add(&obj->cache, &table->obj_cache, hash);
+}
+
+void obj_cache_del(struct obj *obj)
+{
+	cache_del(&obj->cache);
+}
+
+struct obj *obj_cache_find(const struct table *table, const char *name,
+			   uint32_t obj_type)
+{
+	struct obj *obj;
+	uint32_t hash;
+
+	hash = djb_hash(name) % NFT_CACHE_HSIZE;
+	list_for_each_entry(obj, &table->obj_cache.ht[hash], cache.hlist) {
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
@@ -351,6 +437,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 {
 	struct nftnl_chain_list *chain_list = NULL;
 	struct nftnl_set_list *set_list = NULL;
+	struct nftnl_obj_list *obj_list;
 	struct rule *rule, *nrule;
 	struct table *table;
 	struct chain *chain;
@@ -405,12 +492,19 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
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
index a3f468aab104..91cedf4ca021 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4412,7 +4412,7 @@ static int cmd_evaluate_list_obj(struct eval_ctx *ctx, const struct cmd *cmd,
 	if (table == NULL)
 		return table_not_found(ctx);
 
-	if (obj_lookup(table, cmd->handle.obj.name, obj_type) == NULL)
+	if (!obj_cache_find(table, cmd->handle.obj.name, obj_type))
 		return obj_not_found(ctx, &cmd->handle.obj.location,
 				     cmd->handle.obj.name);
 
diff --git a/src/json.c b/src/json.c
index a375093eb785..0b7699a625b5 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1570,7 +1570,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 	tmp = table_print_json(table);
 	json_array_append_new(root, tmp);
 
-	list_for_each_entry(obj, &table->objs, list) {
+	list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
 		tmp = obj_print_json(obj);
 		json_array_append_new(root, tmp);
 	}
@@ -1740,7 +1740,7 @@ static json_t *do_list_obj_json(struct netlink_ctx *ctx,
 		    strcmp(cmd->handle.table.name, table->handle.table.name))
 			continue;
 
-		list_for_each_entry(obj, &table->objs, list) {
+		list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
 			if (obj->type != type ||
 			    (cmd->handle.obj.name &&
 			     strcmp(cmd->handle.obj.name, obj->handle.obj.name)))
diff --git a/src/monitor.c b/src/monitor.c
index dc3f0848ba66..ae288f6cb212 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -477,7 +477,7 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 	nlo = netlink_obj_alloc(nlh);
 
 	obj = netlink_delinearize_obj(monh->ctx, nlo);
-	if (obj == NULL) {
+	if (!obj) {
 		nftnl_obj_free(nlo);
 		return MNL_CB_ERROR;
 	}
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
index 123525570c39..6323fe4e810f 100644
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
index 7dbb02f5b04f..56fb19c77e7d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1114,6 +1114,7 @@ struct table *table_alloc(void)
 
 	cache_init(&table->chain_cache);
 	cache_init(&table->set_cache);
+	cache_init(&table->obj_cache);
 
 	return table;
 }
@@ -1145,10 +1146,15 @@ void table_free(struct table *table)
 		flowtable_free(ft);
 	list_for_each_entry_safe(obj, nobj, &table->objs, list)
 		obj_free(obj);
+	/* this is implicitly releasing objs in the hashtable cache */
+	list_for_each_entry_safe(obj, nobj, &table->obj_cache.list, cache.list)
+		obj_free(obj);
+
 	handle_free(&table->handle);
 	scope_release(&table->scope);
 	cache_free(&table->chain_cache);
 	cache_free(&table->set_cache);
+	cache_free(&table->obj_cache);
 	xfree(table);
 }
 
@@ -1254,7 +1260,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 	if (table->comment)
 		nft_print(octx, "\tcomment \"%s\"\n", table->comment);
 
-	list_for_each_entry(obj, &table->objs, list) {
+	list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
 		nft_print(octx, "%s", delim);
 		obj_print(obj, octx);
 		delim = "\n";
@@ -1727,24 +1733,6 @@ void obj_free(struct obj *obj)
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
@@ -1756,7 +1744,7 @@ struct obj *obj_lookup_fuzzy(const char *obj_name,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->list, list) {
-		list_for_each_entry(obj, &table->objs, list) {
+		list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
 			if (!strcmp(obj->handle.obj.name, obj_name)) {
 				*t = table;
 				return obj;
@@ -2101,14 +2089,14 @@ static int do_list_obj(struct netlink_ctx *ctx, struct cmd *cmd, uint32_t type)
 		    strcmp(cmd->handle.table.name, table->handle.table.name))
 			continue;
 
-		if (list_empty(&table->objs))
+		if (list_empty(&table->obj_cache.list))
 			continue;
 
 		nft_print(&ctx->nft->output, "table %s %s {\n",
 			  family2str(table->handle.family),
 			  table->handle.table.name);
 
-		list_for_each_entry(obj, &table->objs, list) {
+		list_for_each_entry(obj, &table->obj_cache.list, cache.list) {
 			if (obj->type != type ||
 			    (cmd->handle.obj.name != NULL &&
 			     strcmp(cmd->handle.obj.name, obj->handle.obj.name)))
@@ -2564,8 +2552,10 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
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

