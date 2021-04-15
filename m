Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BBAC433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0285261249
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Apr 2021 13:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhDONN7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 09:13:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57872 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbhDONN7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 09:13:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9E08163E7B
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2021 15:13:08 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 02/10] cache: add hashtable cache for flowtable
Date:   Thu, 15 Apr 2021 15:13:22 +0200
Message-Id: <20210415131330.6692-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210415131330.6692-1-pablo@netfilter.org>
References: <20210415131330.6692-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add flowtable hashtable cache.

Actually I am not expecting that many flowtables to benefit from the
hashtable to be created by streamline this code with tables, chains,
sets and policy objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h   |  4 +++
 include/netlink.h |  2 ++
 include/rule.h    |  6 ++--
 src/cache.c       | 90 +++++++++++++++++++++++++++++++++++++++++++++--
 src/evaluate.c    |  2 +-
 src/json.c        |  6 ++--
 src/netlink.c     |  2 +-
 src/rule.c        | 32 +++++++----------
 8 files changed, 116 insertions(+), 28 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index b0458dc9c284..6fa21742503c 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -67,4 +67,8 @@ void obj_cache_del(struct obj *obj);
 struct obj *obj_cache_find(const struct table *table, const char *name,
 			   uint32_t obj_type);
 
+struct flowtable;
+void ft_cache_add(struct flowtable *ft, struct table *table);
+struct flowtable *ft_cache_find(const struct table *table, const char *name);
+
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index f93c5322100f..a7c524ca9674 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -163,6 +163,8 @@ extern struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 
 extern int netlink_list_flowtables(struct netlink_ctx *ctx,
 				   const struct handle *h);
+extern struct flowtable *netlink_delinearize_flowtable(struct netlink_ctx *ctx,
+						       struct nftnl_flowtable *nlo);
 
 extern void netlink_dump_chain(const struct nftnl_chain *nlc,
 			       struct netlink_ctx *ctx);
diff --git a/include/rule.h b/include/rule.h
index 226171a8def7..44e057ab341f 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -164,6 +164,8 @@ struct table {
 	struct list_head	*cache_obj_ht;
 	struct list_head	cache_obj;
 	struct list_head	objs;
+	struct list_head	*cache_ft_ht;
+	struct list_head	cache_ft;
 	struct list_head	flowtables;
 	struct list_head	chain_bindings;
 	enum table_flags 	flags;
@@ -522,6 +524,8 @@ uint32_t obj_type_to_cmd(uint32_t type);
 
 struct flowtable {
 	struct list_head	list;
+	struct list_head	cache_hlist;
+	struct list_head	cache_list;
 	struct handle		handle;
 	struct scope		scope;
 	struct location		location;
@@ -537,8 +541,6 @@ struct flowtable {
 extern struct flowtable *flowtable_alloc(const struct location *loc);
 extern struct flowtable *flowtable_get(struct flowtable *flowtable);
 extern void flowtable_free(struct flowtable *flowtable);
-extern void flowtable_add_hash(struct flowtable *flowtable, struct table *table);
-extern struct flowtable *flowtable_lookup(const struct table *table, const char *name);
 extern struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 						const struct nft_cache *cache,
 						const struct table **table);
diff --git a/src/cache.c b/src/cache.c
index baf8dc12e5b6..95b5c46306c3 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -426,6 +426,84 @@ struct obj *obj_cache_find(const struct table *table, const char *name,
 	return NULL;
 }
 
+struct ft_cache_dump_ctx {
+	struct netlink_ctx	*nlctx;
+	struct table		*table;
+};
+
+static int ft_cache_cb(struct nftnl_flowtable *nlf, void *arg)
+{
+	struct ft_cache_dump_ctx *ctx = arg;
+	const char *ft_name;
+	struct flowtable *ft;
+	uint32_t hash;
+
+	ft = netlink_delinearize_flowtable(ctx->nlctx, nlf);
+	if (!ft)
+		return -1;
+
+	ft_name = nftnl_flowtable_get_str(nlf, NFTNL_FLOWTABLE_NAME);
+	hash = djb_hash(ft_name) % NFT_CACHE_HSIZE;
+	list_add_tail(&ft->cache_hlist, &ctx->table->cache_ft_ht[hash]);
+	list_add_tail(&ft->cache_list, &ctx->table->cache_ft);
+
+	return 0;
+}
+
+static int ft_cache_init(struct netlink_ctx *ctx, struct table *table,
+			 struct nftnl_flowtable_list *ft_list)
+{
+	struct ft_cache_dump_ctx dump_ctx = {
+		.nlctx	= ctx,
+		.table	= table,
+	};
+	nftnl_flowtable_list_foreach(ft_list, ft_cache_cb, &dump_ctx);
+
+	return 0;
+}
+
+static struct nftnl_flowtable_list *ft_cache_dump(struct netlink_ctx *ctx,
+						  const struct table *table,
+						  int *err)
+{
+	struct nftnl_flowtable_list *ft_list;
+
+	ft_list = mnl_nft_flowtable_dump(ctx, table->handle.family,
+					 table->handle.table.name);
+	if (!ft_list) {
+                if (errno == EINTR) {
+			*err = -1;
+			return NULL;
+		}
+		*err = 0;
+		return NULL;
+	}
+
+	return ft_list;
+}
+
+void ft_cache_add(struct flowtable *ft, struct table *table)
+{
+	uint32_t hash;
+
+	hash = djb_hash(ft->handle.flowtable.name) % NFT_CACHE_HSIZE;
+	list_add_tail(&ft->cache_hlist, &table->cache_ft_ht[hash]);
+	list_add_tail(&ft->cache_list, &table->cache_ft);
+}
+
+struct flowtable *ft_cache_find(const struct table *table, const char *name)
+{
+	struct flowtable *ft;
+	uint32_t hash;
+
+	hash = djb_hash(name) % NFT_CACHE_HSIZE;
+	list_for_each_entry(ft, &table->cache_ft_ht[hash], cache_hlist) {
+		if (!strcmp(ft->handle.flowtable.name, name))
+			return ft;
+	}
+
+	return NULL;
+}
 
 static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 			     struct nft_cache *cache)
@@ -443,6 +521,7 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 
 static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 {
+	struct nftnl_flowtable_list *ft_list = NULL;
 	struct nftnl_chain_list *chain_list = NULL;
 	struct nftnl_set_list *set_list = NULL;
 	struct nftnl_obj_list *obj_list;
@@ -492,12 +571,19 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 			}
 		}
 		if (flags & NFT_CACHE_FLOWTABLE_BIT) {
-			ret = netlink_list_flowtables(ctx, &table->handle);
+			ft_list = ft_cache_dump(ctx, table, &ret);
+			if (!ft_list) {
+				ret = -1;
+				goto cache_fails;
+			}
+			ret = ft_cache_init(ctx, table, ft_list);
+
+			nftnl_flowtable_list_free(ft_list);
+
 			if (ret < 0) {
 				ret = -1;
 				goto cache_fails;
 			}
-			list_splice_tail_init(&ctx->list, &table->flowtables);
 		}
 		if (flags & NFT_CACHE_OBJECT_BIT) {
 			obj_list = obj_cache_dump(ctx, table, &ret);
diff --git a/src/evaluate.c b/src/evaluate.c
index d33a152c3de4..a516a01ffc30 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4452,7 +4452,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		ft = flowtable_lookup(table, cmd->handle.flowtable.name);
+		ft = ft_cache_find(table, cmd->handle.flowtable.name);
 		if (ft == NULL)
 			return flowtable_not_found(ctx, &ctx->cmd->handle.flowtable.location,
 						   ctx->cmd->handle.flowtable.name);
diff --git a/src/json.c b/src/json.c
index bf151e927661..29923092d12c 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1580,7 +1580,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		tmp = set_print_json(&ctx->nft->output, set);
 		json_array_append_new(root, tmp);
 	}
-	list_for_each_entry(flowtable, &table->flowtables, list) {
+	list_for_each_entry(flowtable, &table->cache_ft, cache_list) {
 		tmp = flowtable_print_json(flowtable);
 		json_array_append_new(root, tmp);
 	}
@@ -1759,7 +1759,7 @@ static json_t *do_list_flowtable_json(struct netlink_ctx *ctx,
 	json_t *root = json_array();
 	struct flowtable *ft;
 
-	ft = flowtable_lookup(table, cmd->handle.flowtable.name);
+	ft = ft_cache_find(table, cmd->handle.flowtable.name);
 	if (ft == NULL)
 		return json_null();
 
@@ -1779,7 +1779,7 @@ static json_t *do_list_flowtables_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		list_for_each_entry(flowtable, &table->flowtables, list) {
+		list_for_each_entry(flowtable, &table->cache_ft, cache_list) {
 			tmp = flowtable_print_json(flowtable);
 			json_array_append_new(root, tmp);
 		}
diff --git a/src/netlink.c b/src/netlink.c
index 2286a6ffabf8..5b2ad676f3e5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1534,7 +1534,7 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return err;
 }
 
-static struct flowtable *
+struct flowtable *
 netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 			      struct nftnl_flowtable *nlo)
 {
diff --git a/src/rule.c b/src/rule.c
index b78d4e7f9cd3..414e53e7d2f6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1112,6 +1112,7 @@ struct table *table_alloc(void)
 	init_list_head(&table->objs);
 	init_list_head(&table->cache_obj);
 	init_list_head(&table->flowtables);
+	init_list_head(&table->cache_ft);
 	init_list_head(&table->chain_bindings);
 	init_list_head(&table->scope.symbols);
 	table->refcnt = 1;
@@ -1131,6 +1132,11 @@ struct table *table_alloc(void)
 	for (i = 0; i < NFT_CACHE_HSIZE; i++)
 		init_list_head(&table->cache_obj_ht[i]);
 
+	table->cache_ft_ht =
+		xmalloc(sizeof(struct list_head) * NFT_CACHE_HSIZE);
+	for (i = 0; i < NFT_CACHE_HSIZE; i++)
+		init_list_head(&table->cache_ft_ht[i]);
+
 	return table;
 }
 
@@ -1159,6 +1165,9 @@ void table_free(struct table *table)
 		set_free(set);
 	list_for_each_entry_safe(ft, nft, &table->flowtables, list)
 		flowtable_free(ft);
+	/* this is implicitly releasing flowtables in the hashtable cache */
+	list_for_each_entry_safe(ft, nft, &table->cache_ft, cache_list)
+		flowtable_free(ft);
 	list_for_each_entry_safe(obj, nobj, &table->objs, list)
 		obj_free(obj);
 	/* this is implicitly releasing objs in the hashtable cache */
@@ -1170,6 +1179,7 @@ void table_free(struct table *table)
 	xfree(table->cache_chain_ht);
 	xfree(table->cache_set_ht);
 	xfree(table->cache_obj_ht);
+	xfree(table->cache_ft_ht);
 	xfree(table);
 }
 
@@ -1287,7 +1297,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		set_print(set, octx);
 		delim = "\n";
 	}
-	list_for_each_entry(flowtable, &table->flowtables, list) {
+	list_for_each_entry(flowtable, &table->cache_ft, cache_list) {
 		nft_print(octx, "%s", delim);
 		flowtable_print(flowtable, octx);
 		delim = "\n";
@@ -2161,11 +2171,6 @@ void flowtable_free(struct flowtable *flowtable)
 	xfree(flowtable);
 }
 
-void flowtable_add_hash(struct flowtable *flowtable, struct table *table)
-{
-	list_add_tail(&flowtable->list, &table->flowtables);
-}
-
 static void flowtable_print_declaration(const struct flowtable *flowtable,
 					struct print_fmt_options *opts,
 					struct output_ctx *octx)
@@ -2231,17 +2236,6 @@ void flowtable_print(const struct flowtable *s, struct output_ctx *octx)
 	do_flowtable_print(s, &opts, octx);
 }
 
-struct flowtable *flowtable_lookup(const struct table *table, const char *name)
-{
-	struct flowtable *ft;
-
-	list_for_each_entry(ft, &table->flowtables, list) {
-		if (!strcmp(ft->handle.flowtable.name, name))
-			return ft;
-	}
-	return NULL;
-}
-
 struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 					 const struct nft_cache *cache,
 					 const struct table **t)
@@ -2271,7 +2265,7 @@ static int do_list_flowtable(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	struct flowtable *ft;
 
-	ft = flowtable_lookup(table, cmd->handle.flowtable.name);
+	ft = ft_cache_find(table, cmd->handle.flowtable.name);
 	if (ft == NULL)
 		return -1;
 
@@ -2304,7 +2298,7 @@ static int do_list_flowtables(struct netlink_ctx *ctx, struct cmd *cmd)
 			  family2str(table->handle.family),
 			  table->handle.table.name);
 
-		list_for_each_entry(flowtable, &table->flowtables, list) {
+		list_for_each_entry(flowtable, &table->cache_ft, cache_list) {
 			flowtable_print_declaration(flowtable, &opts, &ctx->nft->output);
 			nft_print(&ctx->nft->output, "%s}%s", opts.tab, opts.nl);
 		}
-- 
2.20.1

