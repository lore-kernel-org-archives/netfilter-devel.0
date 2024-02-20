Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F5C6995D
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Feb 2024 12:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708432063; cv=none; b=pO3tvUCYhGH8Vl6dWyEuhvwZPtOtj/cev/juCO+5cd80Hnyu8+PuSk6TjkJnDg7OUdEbTv+GUV3wp3cvKE35j6ikBkxUcwBR0wpQFx12GWc1qx+SFjrIdLquTWk5cSEAS4/h2XiLGK5NyukbUZfAjv0MX0zeBFlWRCh0PPiOcr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708432063; c=relaxed/simple;
	bh=Ovy3UctQB5a3LVEX5yhpMOW19socVwkYx2DyRKV12rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=LIMBpJ6J2Bsv30WhYSCiQwqxE/9k5FnwnmStGoJMNyTahUGOrhvyaZS5CtBNd/iFrWHWKbfg/lqfQBXBVHXSNYli/fFAQu7Trh5nppBOHpGX4SbrCQjU4O20HSRHriIuVdtN7i9i9JgyMhGEONkfhdX6QK/SIGEiTd/kfYYQrek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=34140 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rcPDh-009zfv-Mi; Tue, 20 Feb 2024 13:27:36 +0100
Date: Tue, 20 Feb 2024 13:27:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [RFC] nftables 0.9.8 -stable backports
Message-ID: <ZdSaqOwcEukd4lj4@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="L1RwvOWpz701lMH3"
Content-Disposition: inline
In-Reply-To: <20240218135600.GA4998@siaphelec.sdnalmaerd>
X-Spam-Score: -1.7 (-)


--L1RwvOWpz701lMH3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Jeremy,

On Sun, Feb 18, 2024 at 01:56:00PM +0000, Jeremy Sowden wrote:
> On 2024-02-17, at 20:11:42 +0000, Jeremy Sowden wrote:
> > Does this look good to you?
> 
> Forgot to run the test-suite.  Doing so revealed that this doesn't quite
> work because `set_alloc` doesn't initialize `s->list`.

I'd suggest instead a backport of the patch that fixes the set cache
for 0.9.8 instead.

See attached patch, it is partial backport of a upstream patch.

I have run tests/shell (two tests don't pass, because 5.15 does not
support multiple statements) and tests/py for that nftables 0.9.8 version.

--L1RwvOWpz701lMH3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-partial-backport-of-df48e56e987f-cache-add-hashtable.patch"

From 92908c439d1e33f10ee96daf63eae50d1dfcbb52 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 20 Feb 2024 10:26:22 +0100
Subject: [PATCH] partial backport of df48e56e987f ("cache: add hashtable cache
 for sets")

This patch splits table->sets in two:

- Sets that reside in the cache are stored in the new
  tables->cache_set and tables->cache_set_ht.

- Set that defined via command line / ruleset file reside in
  tables->set.

Sets in the cache (already in the kernel) are not placed in the
table->sets list.

By keeping separated lists, sets defined via command line / ruleset file
can be added to cache.
---
 include/cache.h   |  7 +++++
 include/netlink.h |  1 -
 include/rule.h    |  3 ++-
 src/cache.c       | 69 +++++++++++++++++++++++++++++++++++++++++++++++
 src/evaluate.c    |  2 +-
 src/json.c        |  4 +--
 src/monitor.c     |  2 +-
 src/netlink.c     | 31 ---------------------
 src/rule.c        | 34 ++++++++++++++---------
 9 files changed, 104 insertions(+), 49 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index baa2bb29f1e7..d4abe67611bc 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -59,4 +59,11 @@ void chain_cache_add(struct chain *chain, struct table *table);
 struct chain *chain_cache_find(const struct table *table,
 			       const struct handle *handle);
 
+struct nftnl_set_list;
+
+struct nftnl_set_list *set_cache_dump(struct netlink_ctx *ctx, int *err);
+int set_cache_init(struct netlink_ctx *ctx, struct table *table,
+		   struct nftnl_set_list *set_list);
+void set_cache_add(struct set *set, struct table *table);
+
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
index f880cfd32bd8..7d1bd75e9d7e 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -157,6 +157,7 @@ struct table {
 	struct list_head	*cache_chain_ht;
 	struct list_head	cache_chain;
 	struct list_head	chains;
+	struct list_head	cache_set;
 	struct list_head	sets;
 	struct list_head	objs;
 	struct list_head	flowtables;
@@ -323,6 +324,7 @@ void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
  */
 struct set {
 	struct list_head	list;
+	struct list_head	cache_list;
 	struct handle		handle;
 	struct location		location;
 	unsigned int		refcnt;
@@ -351,7 +353,6 @@ extern struct set *set_alloc(const struct location *loc);
 extern struct set *set_get(struct set *set);
 extern void set_free(struct set *set);
 extern struct set *set_clone(const struct set *set);
-extern void set_add_hash(struct set *set, struct table *table);
 extern struct set *set_lookup(const struct table *table, const char *name);
 extern struct set *set_lookup_global(uint32_t family, const char *table,
 				     const char *name, struct nft_cache *cache);
diff --git a/src/cache.c b/src/cache.c
index 32e6eea4ac5c..600e6f02d22e 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -15,6 +15,8 @@
 #include <netlink.h>
 #include <mnl.h>
 #include <libnftnl/chain.h>
+#include <include/linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
 
 static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 {
@@ -256,3 +258,70 @@ struct chain *chain_cache_find(const struct table *table,
 
 	return NULL;
 }
+
+struct set_cache_dump_ctx {
+	struct netlink_ctx	*nlctx;
+	struct table		*table;
+};
+
+static int set_cache_cb(struct nftnl_set *nls, void *arg)
+{
+	struct set_cache_dump_ctx *ctx = arg;
+	const char *set_table;
+	uint32_t set_family;
+	struct set *set;
+
+	set_table = nftnl_set_get_str(nls, NFTNL_SET_TABLE);
+	set_family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
+
+	if (set_family != ctx->table->handle.family ||
+	    strcmp(set_table, ctx->table->handle.table.name))
+		return 0;
+
+	set = netlink_delinearize_set(ctx->nlctx, nls);
+	if (!set)
+		return -1;
+
+	list_add_tail(&set->cache_list, &ctx->table->cache_set);
+
+	nftnl_set_list_del(nls);
+	nftnl_set_free(nls);
+	return 0;
+}
+
+int set_cache_init(struct netlink_ctx *ctx, struct table *table,
+		   struct nftnl_set_list *set_list)
+{
+	struct set_cache_dump_ctx dump_ctx = {
+		.nlctx	= ctx,
+		.table	= table,
+	};
+
+	nftnl_set_list_foreach(set_list, set_cache_cb, &dump_ctx);
+
+	return 0;
+}
+
+void set_cache_add(struct set *set, struct table *table)
+{
+	list_add_tail(&set->cache_list, &table->cache_set);
+}
+
+struct nftnl_set_list *set_cache_dump(struct netlink_ctx *ctx, int *err)
+{
+	struct nftnl_set_list *set_list;
+	const char *table = NULL;
+	int family = AF_UNSPEC;
+
+	set_list = mnl_nft_set_dump(ctx, family, table);
+	if (!set_list) {
+		if (errno == EINTR) {
+			*err = -1;
+			return NULL;
+		}
+		*err = 0;
+		return NULL;
+	}
+
+	return set_list;
+}
diff --git a/src/evaluate.c b/src/evaluate.c
index 232ae39020cc..7378174ceb97 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3760,7 +3760,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	ctx->set = NULL;
 
 	if (set_lookup(table, set->handle.set.name) == NULL)
-		set_add_hash(set_get(set), table);
+		set_cache_add(set_get(set), table);
 
 	return 0;
 }
diff --git a/src/json.c b/src/json.c
index 737e73b08b5a..13079230af22 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1584,7 +1584,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		tmp = obj_print_json(obj);
 		json_array_append_new(root, tmp);
 	}
-	list_for_each_entry(set, &table->sets, list) {
+	list_for_each_entry(set, &table->cache_set, cache_list) {
 		if (set_is_anonymous(set->flags))
 			continue;
 		tmp = set_print_json(&ctx->nft->output, set);
@@ -1717,7 +1717,7 @@ static json_t *do_list_sets_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		list_for_each_entry(set, &table->sets, list) {
+		list_for_each_entry(set, &table->cache_set, cache_list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
 			    !set_is_literal(set->flags))
 				continue;
diff --git a/src/monitor.c b/src/monitor.c
index af2998d4272b..946621e28ec0 100644
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
index ec2dad29ace1..dcac0ab8f871 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -970,37 +970,6 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
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
diff --git a/src/rule.c b/src/rule.c
index 9c74b89c1fb1..4b2682455253 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -153,6 +153,7 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 {
 	struct nftnl_chain_list *chain_list = NULL;
+	struct nftnl_set_list *set_list = NULL;
 	struct rule *rule, *nrule;
 	struct table *table;
 	struct chain *chain;
@@ -164,16 +165,22 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 		if (!chain_list)
 			return ret;
 	}
+	if (flags & NFT_CACHE_SET_BIT) {
+		set_list = set_cache_dump(ctx, &ret);
+		if (!set_list) {
+			ret = -1;
+			goto cache_fails;
+		}
+	}
 
 	list_for_each_entry(table, &ctx->nft->cache.list, list) {
 		if (flags & NFT_CACHE_SET_BIT) {
-			ret = netlink_list_sets(ctx, &table->handle);
-			list_splice_tail_init(&ctx->list, &table->sets);
+			ret = set_cache_init(ctx, table, set_list);
 			if (ret < 0)
 				return -1;
 		}
 		if (flags & NFT_CACHE_SETELEM_BIT) {
-			list_for_each_entry(set, &table->sets, list) {
+			list_for_each_entry(set, &table->cache_set, cache_list) {
 				ret = netlink_list_setelems(ctx, &set->handle,
 							    set);
 				if (ret < 0)
@@ -212,6 +219,10 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 		}
 	}
 
+cache_fails:
+	if (set_list)
+		nftnl_set_list_free(set_list);
+
 	if (flags & NFT_CACHE_CHAIN_BIT)
 		nftnl_chain_list_free(chain_list);
 
@@ -389,16 +400,11 @@ void set_free(struct set *set)
 	xfree(set);
 }
 
-void set_add_hash(struct set *set, struct table *table)
-{
-	list_add_tail(&set->list, &table->sets);
-}
-
 struct set *set_lookup(const struct table *table, const char *name)
 {
 	struct set *set;
 
-	list_for_each_entry(set, &table->sets, list) {
+	list_for_each_entry(set, &table->cache_set, cache_list) {
 		if (!strcmp(set->handle.set.name, name))
 			return set;
 	}
@@ -416,7 +422,7 @@ struct set *set_lookup_fuzzy(const char *set_name,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->list, list) {
-		list_for_each_entry(set, &table->sets, list) {
+		list_for_each_entry(set, &table->cache_set, cache_list) {
 			if (set_is_anonymous(set->flags))
 				continue;
 			if (!strcmp(set->handle.set.name, set_name)) {
@@ -1323,6 +1329,7 @@ struct table *table_alloc(void)
 	init_list_head(&table->chains);
 	init_list_head(&table->cache_chain);
 	init_list_head(&table->sets);
+	init_list_head(&table->cache_set);
 	init_list_head(&table->objs);
 	init_list_head(&table->flowtables);
 	init_list_head(&table->chain_bindings);
@@ -1357,6 +1364,9 @@ void table_free(struct table *table)
 		chain_free(chain);
 	list_for_each_entry_safe(set, nset, &table->sets, list)
 		set_free(set);
+	/* this is implicitly releasing sets in the cache */
+	list_for_each_entry_safe(set, nset, &table->cache_set, cache_list)
+		set_free(set);
 	list_for_each_entry_safe(ft, nft, &table->flowtables, list)
 		flowtable_free(ft);
 	list_for_each_entry_safe(obj, nobj, &table->objs, list)
@@ -1457,7 +1467,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		obj_print(obj, octx);
 		delim = "\n";
 	}
-	list_for_each_entry(set, &table->sets, list) {
+	list_for_each_entry(set, &table->cache_set, cache_list) {
 		if (set_is_anonymous(set->flags))
 			continue;
 		nft_print(octx, "%s", delim);
@@ -1910,7 +1920,7 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 			  family2str(table->handle.family),
 			  table->handle.table.name);
 
-		list_for_each_entry(set, &table->sets, list) {
+		list_for_each_entry(set, &table->cache_set, cache_list) {
 			if (cmd->obj == CMD_OBJ_SETS &&
 			    !set_is_literal(set->flags))
 				continue;
-- 
2.30.2


--L1RwvOWpz701lMH3--
