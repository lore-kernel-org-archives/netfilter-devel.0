Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DB1C43460
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 819E86147D
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhD2Xn4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:56 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59558 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhD2Xnw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:52 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B249164135
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 08/18] cache: add hashtable cache for flowtable
Date:   Fri, 30 Apr 2021 01:42:45 +0200
Message-Id: <20210429234255.16840-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
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
 include/rule.h    |  4 +--
 src/cache.c       | 88 +++++++++++++++++++++++++++++++++++++++++++++--
 src/evaluate.c    |  6 ++--
 src/json.c        |  8 ++---
 src/netlink.c     |  2 +-
 src/rule.c        | 31 ++++++-----------
 8 files changed, 112 insertions(+), 33 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 9605ef96c853..992f993c0667 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -92,4 +92,8 @@ void obj_cache_del(struct obj *obj);
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
index f264bc8a1a01..c6fd4c4c067b 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -158,6 +158,7 @@ struct table {
 	struct cache		chain_cache;
 	struct cache		set_cache;
 	struct cache		obj_cache;
+	struct cache		ft_cache;
 	struct list_head	chains;
 	struct list_head	sets;
 	struct list_head	objs;
@@ -516,6 +517,7 @@ uint32_t obj_type_to_cmd(uint32_t type);
 
 struct flowtable {
 	struct list_head	list;
+	struct cache_item	cache;
 	struct handle		handle;
 	struct scope		scope;
 	struct location		location;
@@ -531,8 +533,6 @@ struct flowtable {
 extern struct flowtable *flowtable_alloc(const struct location *loc);
 extern struct flowtable *flowtable_get(struct flowtable *flowtable);
 extern void flowtable_free(struct flowtable *flowtable);
-extern void flowtable_add_hash(struct flowtable *flowtable, struct table *table);
-extern struct flowtable *flowtable_lookup(const struct table *table, const char *name);
 extern struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 						const struct nft_cache *cache,
 						const struct table **table);
diff --git a/src/cache.c b/src/cache.c
index b2f796ec9975..1aec12666d52 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -418,6 +418,82 @@ struct obj *obj_cache_find(const struct table *table, const char *name,
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
+	cache_add(&ft->cache, &ctx->table->ft_cache, hash);
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
+	cache_add(&ft->cache, &table->ft_cache, hash);
+}
+
+struct flowtable *ft_cache_find(const struct table *table, const char *name)
+{
+	struct flowtable *ft;
+	uint32_t hash;
+
+	hash = djb_hash(name) % NFT_CACHE_HSIZE;
+	list_for_each_entry(ft, &table->ft_cache.ht[hash], cache.hlist) {
+		if (!strcmp(ft->handle.flowtable.name, name))
+			return ft;
+	}
+
+	return NULL;
+}
 
 static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 			     struct nft_cache *cache)
@@ -435,6 +511,7 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 
 static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 {
+	struct nftnl_flowtable_list *ft_list = NULL;
 	struct nftnl_chain_list *chain_list = NULL;
 	struct nftnl_set_list *set_list = NULL;
 	struct nftnl_obj_list *obj_list;
@@ -484,12 +561,19 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
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
index 91cedf4ca021..8f35ca5935bc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -238,7 +238,7 @@ static int flowtable_not_found(struct eval_ctx *ctx, const struct location *loc,
 	struct flowtable *ft;
 
 	ft = flowtable_lookup_fuzzy(ft_name, &ctx->nft->cache, &table);
-	if (ft == NULL)
+	if (!ft)
 		return cmd_error(ctx, loc, "%s", strerror(ENOENT));
 
 	return cmd_error(ctx, loc,
@@ -4491,8 +4491,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		ft = flowtable_lookup(table, cmd->handle.flowtable.name);
-		if (ft == NULL)
+		ft = ft_cache_find(table, cmd->handle.flowtable.name);
+		if (!ft)
 			return flowtable_not_found(ctx, &ctx->cmd->handle.flowtable.location,
 						   ctx->cmd->handle.flowtable.name);
 
diff --git a/src/json.c b/src/json.c
index 0b7699a625b5..9358cbc3da8d 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1580,7 +1580,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		tmp = set_print_json(&ctx->nft->output, set);
 		json_array_append_new(root, tmp);
 	}
-	list_for_each_entry(flowtable, &table->flowtables, list) {
+	list_for_each_entry(flowtable, &table->ft_cache.list, cache.list) {
 		tmp = flowtable_print_json(flowtable);
 		json_array_append_new(root, tmp);
 	}
@@ -1759,8 +1759,8 @@ static json_t *do_list_flowtable_json(struct netlink_ctx *ctx,
 	json_t *root = json_array();
 	struct flowtable *ft;
 
-	ft = flowtable_lookup(table, cmd->handle.flowtable.name);
-	if (ft == NULL)
+	ft = ft_cache_find(table, cmd->handle.flowtable.name);
+	if (!ft)
 		return json_null();
 
 	json_array_append_new(root, flowtable_print_json(ft));
@@ -1779,7 +1779,7 @@ static json_t *do_list_flowtables_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		list_for_each_entry(flowtable, &table->flowtables, list) {
+		list_for_each_entry(flowtable, &table->ft_cache.list, cache.list) {
 			tmp = flowtable_print_json(flowtable);
 			json_array_append_new(root, tmp);
 		}
diff --git a/src/netlink.c b/src/netlink.c
index 6323fe4e810f..5ed6d32fb292 100644
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
index 56fb19c77e7d..95016320dfd3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1115,6 +1115,7 @@ struct table *table_alloc(void)
 	cache_init(&table->chain_cache);
 	cache_init(&table->set_cache);
 	cache_init(&table->obj_cache);
+	cache_init(&table->ft_cache);
 
 	return table;
 }
@@ -1144,6 +1145,9 @@ void table_free(struct table *table)
 		set_free(set);
 	list_for_each_entry_safe(ft, nft, &table->flowtables, list)
 		flowtable_free(ft);
+	/* this is implicitly releasing flowtables in the hashtable cache */
+	list_for_each_entry_safe(ft, nft, &table->ft_cache.list, cache.list)
+		flowtable_free(ft);
 	list_for_each_entry_safe(obj, nobj, &table->objs, list)
 		obj_free(obj);
 	/* this is implicitly releasing objs in the hashtable cache */
@@ -1155,6 +1159,7 @@ void table_free(struct table *table)
 	cache_free(&table->chain_cache);
 	cache_free(&table->set_cache);
 	cache_free(&table->obj_cache);
+	cache_free(&table->ft_cache);
 	xfree(table);
 }
 
@@ -1272,7 +1277,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		set_print(set, octx);
 		delim = "\n";
 	}
-	list_for_each_entry(flowtable, &table->flowtables, list) {
+	list_for_each_entry(flowtable, &table->ft_cache.list, cache.list) {
 		nft_print(octx, "%s", delim);
 		flowtable_print(flowtable, octx);
 		delim = "\n";
@@ -2146,11 +2151,6 @@ void flowtable_free(struct flowtable *flowtable)
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
@@ -2216,17 +2216,6 @@ void flowtable_print(const struct flowtable *s, struct output_ctx *octx)
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
@@ -2238,7 +2227,7 @@ struct flowtable *flowtable_lookup_fuzzy(const char *ft_name,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->list, list) {
-		list_for_each_entry(ft, &table->flowtables, list) {
+		list_for_each_entry(ft, &table->ft_cache.list, cache.list) {
 			if (!strcmp(ft->handle.flowtable.name, ft_name)) {
 				*t = table;
 				return ft;
@@ -2256,8 +2245,8 @@ static int do_list_flowtable(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	struct flowtable *ft;
 
-	ft = flowtable_lookup(table, cmd->handle.flowtable.name);
-	if (ft == NULL)
+	ft = ft_cache_find(table, cmd->handle.flowtable.name);
+	if (!ft)
 		return -1;
 
 	nft_print(&ctx->nft->output, "table %s %s {\n",
@@ -2289,7 +2278,7 @@ static int do_list_flowtables(struct netlink_ctx *ctx, struct cmd *cmd)
 			  family2str(table->handle.family),
 			  table->handle.table.name);
 
-		list_for_each_entry(flowtable, &table->flowtables, list) {
+		list_for_each_entry(flowtable, &table->ft_cache.list, cache.list) {
 			flowtable_print_declaration(flowtable, &opts, &ctx->nft->output);
 			nft_print(&ctx->nft->output, "%s}%s", opts.tab, opts.nl);
 		}
-- 
2.20.1

