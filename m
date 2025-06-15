Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7A0262FF6
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 10:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749981629; cv=none; b=XTO0cyywEvu2Rg570SktuIZpcBd9QavngErooZxtdI0YGqg+6Q+BkfHms6EqvO8wrkrbyWs9MeJfUjkTKWukha7WjPPXf9C7CR/xQZqPpBk5pKwsQgp2AmyzbeOM1sLu2vjjvbW3K1PpnBW/tjuNRAJ5h9rBm30Qy6sJ8lpHr+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749981629; c=relaxed/simple;
	bh=OxweVDYxxYBCTuNw/FRkcB0l4bgYSjwV8gREC/lAccw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZYWzxxFwn37s/BDot1sZJexKYLFrz2uNAv+/CDnoEnQmkY5zSbWU07PjGEwgMKjHr1xRvRFHVysFVUBm1Bg/LOORlRLm+LBE2v6NrMc2Boj1duv4xLRD9Cm6y+atO/ctVDGY6OWUQzWj8y0SQUzhtHv6QBU150aDJlWxU6Kih6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jUJeTElr; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jUJeTElr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jUJeTElr";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jUJeTElr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B00B1602C2; Sun, 15 Jun 2025 12:00:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981625;
	bh=fDEAG0RsVSqro6cgEoRAakuBT7SGYkvPuFNyCl8oBK4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jUJeTElrPb6898GOeuLk4GL74DIChkCQb4vlbvnNuXxjhnQJVk5OB7XpZ1egWQAUk
	 asD2uKvJ5l9xby9CxAXUQIcltE+A+YoBmY3/f1hEb8d7LUwTc+rxwuHIoi/pMQUmcg
	 VlZ+cOyr+iuV862JGFbEKtSl+PWet5QrabvHYTfSn/fzvm4dCxiU1L5pOUqATyyyUD
	 d7tO1ysFz/e5BEczg9yNxwLZJH9oIYGom71Vm8WMe9v4v7X/DZQjvgp0/jpGDe2MnF
	 ExeFWeHhZhPLSiXy/7lrWMdFA79/ZOO18rCkgdKw+mkIFdfggtFXGreMWin832JZ2N
	 jo0tZSIZ67a/g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DD1BC602C0
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 12:00:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749981625;
	bh=fDEAG0RsVSqro6cgEoRAakuBT7SGYkvPuFNyCl8oBK4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jUJeTElrPb6898GOeuLk4GL74DIChkCQb4vlbvnNuXxjhnQJVk5OB7XpZ1egWQAUk
	 asD2uKvJ5l9xby9CxAXUQIcltE+A+YoBmY3/f1hEb8d7LUwTc+rxwuHIoi/pMQUmcg
	 VlZ+cOyr+iuV862JGFbEKtSl+PWet5QrabvHYTfSn/fzvm4dCxiU1L5pOUqATyyyUD
	 d7tO1ysFz/e5BEczg9yNxwLZJH9oIYGom71Vm8WMe9v4v7X/DZQjvgp0/jpGDe2MnF
	 ExeFWeHhZhPLSiXy/7lrWMdFA79/ZOO18rCkgdKw+mkIFdfggtFXGreMWin832JZ2N
	 jo0tZSIZ67a/g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/5] cache: pass name to cache_add()
Date: Sun, 15 Jun 2025 12:00:17 +0200
Message-Id: <20250615100019.2988872-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250615100019.2988872-1-pablo@netfilter.org>
References: <20250615100019.2988872-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate the name hash in the cache_add() function.

No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h |  2 +-
 src/cache.c     | 49 +++++++++++++++----------------------------------
 2 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index e6bde6c6bee3..c969534f4ea7 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -123,7 +123,7 @@ struct cache_item {
 
 void cache_init(struct cache *cache);
 void cache_free(struct cache *cache);
-void cache_add(struct cache_item *item, struct cache *cache, uint32_t hash);
+void cache_add(struct cache_item *item, struct cache *cache, const char *name);
 void cache_del(struct cache_item *item);
 
 void table_cache_add(struct table *table, struct nft_cache *cache);
diff --git a/src/cache.c b/src/cache.c
index d16052c608d5..d58fb59ff061 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -534,10 +534,7 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 
 void table_cache_add(struct table *table, struct nft_cache *cache)
 {
-	uint32_t hash;
-
-	hash = djb_hash(table->handle.table.name) % NFT_CACHE_HSIZE;
-	cache_add(&table->cache, &cache->table_cache, hash);
+	cache_add(&table->cache, &cache->table_cache, table->handle.table.name);
 }
 
 void table_cache_del(struct table *table)
@@ -572,8 +569,8 @@ static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 {
 	struct chain_cache_dump_ctx *ctx = arg;
 	const char *chain_name, *table_name;
-	uint32_t hash, family;
 	struct chain *chain;
+	uint32_t family;
 
 	table_name = nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE);
 	family = nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY);
@@ -583,13 +580,12 @@ static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 		return 0;
 
 	chain_name = nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME);
-	hash = djb_hash(chain_name) % NFT_CACHE_HSIZE;
-	chain = netlink_delinearize_chain(ctx->nlctx, nlc);
 
+	chain = netlink_delinearize_chain(ctx->nlctx, nlc);
 	if (chain->flags & CHAIN_F_BINDING) {
 		list_add_tail(&chain->cache.list, &ctx->table->chain_bindings);
 	} else {
-		cache_add(&chain->cache, &ctx->table->chain_cache, hash);
+		cache_add(&chain->cache, &ctx->table->chain_cache, chain_name);
 	}
 
 	nftnl_chain_list_del(nlc);
@@ -655,10 +651,7 @@ void nft_chain_cache_update(struct netlink_ctx *ctx, struct table *table,
 
 void chain_cache_add(struct chain *chain, struct table *table)
 {
-	uint32_t hash;
-
-	hash = djb_hash(chain->handle.chain.name) % NFT_CACHE_HSIZE;
-	cache_add(&chain->cache, &table->chain_cache, hash);
+	cache_add(&chain->cache, &table->chain_cache, chain->handle.chain.name);
 }
 
 void chain_cache_del(struct chain *chain)
@@ -760,7 +753,6 @@ static int set_cache_cb(struct nftnl_set *nls, void *arg)
 	const char *set_name;
 	uint32_t set_family;
 	struct set *set;
-	uint32_t hash;
 
 	set_table = nftnl_set_get_str(nls, NFTNL_SET_TABLE);
 	set_family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
@@ -774,8 +766,7 @@ static int set_cache_cb(struct nftnl_set *nls, void *arg)
 		return -1;
 
 	set_name = nftnl_set_get_str(nls, NFTNL_SET_NAME);
-	hash = djb_hash(set_name) % NFT_CACHE_HSIZE;
-	cache_add(&set->cache, &ctx->table->set_cache, hash);
+	cache_add(&set->cache, &ctx->table->set_cache, set_name);
 
 	nftnl_set_list_del(nls);
 	nftnl_set_free(nls);
@@ -825,10 +816,7 @@ set_cache_dump(struct netlink_ctx *ctx,
 
 void set_cache_add(struct set *set, struct table *table)
 {
-	uint32_t hash;
-
-	hash = djb_hash(set->handle.set.name) % NFT_CACHE_HSIZE;
-	cache_add(&set->cache, &table->set_cache, hash);
+	cache_add(&set->cache, &table->set_cache, set->handle.set.name);
 }
 
 void set_cache_del(struct set *set)
@@ -864,7 +852,6 @@ static int obj_cache_cb(struct nftnl_obj *nlo, void *arg)
 	const char *obj_name;
 	uint32_t obj_family;
 	struct obj *obj;
-	uint32_t hash;
 
 	obj_table = nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE);
 	obj_family = nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY);
@@ -876,8 +863,7 @@ static int obj_cache_cb(struct nftnl_obj *nlo, void *arg)
 	obj = netlink_delinearize_obj(ctx->nlctx, nlo);
 	if (obj) {
 		obj_name = nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME);
-		hash = djb_hash(obj_name) % NFT_CACHE_HSIZE;
-		cache_add(&obj->cache, &ctx->table->obj_cache, hash);
+		cache_add(&obj->cache, &ctx->table->obj_cache, obj_name);
 	}
 
 	nftnl_obj_list_del(nlo);
@@ -940,10 +926,7 @@ static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
 
 void obj_cache_add(struct obj *obj, struct table *table)
 {
-	uint32_t hash;
-
-	hash = djb_hash(obj->handle.obj.name) % NFT_CACHE_HSIZE;
-	cache_add(&obj->cache, &table->obj_cache, hash);
+	cache_add(&obj->cache, &table->obj_cache, obj->handle.obj.name);
 }
 
 void obj_cache_del(struct obj *obj)
@@ -981,7 +964,6 @@ static int ft_cache_cb(struct nftnl_flowtable *nlf, void *arg)
 	const char *ft_table;
 	const char *ft_name;
 	uint32_t ft_family;
-	uint32_t hash;
 
 	ft_family = nftnl_flowtable_get_u32(nlf, NFTNL_FLOWTABLE_FAMILY);
 	ft_table = nftnl_flowtable_get_str(nlf, NFTNL_FLOWTABLE_TABLE);
@@ -995,8 +977,7 @@ static int ft_cache_cb(struct nftnl_flowtable *nlf, void *arg)
 		return -1;
 
 	ft_name = nftnl_flowtable_get_str(nlf, NFTNL_FLOWTABLE_NAME);
-	hash = djb_hash(ft_name) % NFT_CACHE_HSIZE;
-	cache_add(&ft->cache, &ctx->table->ft_cache, hash);
+	cache_add(&ft->cache, &ctx->table->ft_cache, ft_name);
 
 	nftnl_flowtable_list_del(nlf);
 	nftnl_flowtable_free(nlf);
@@ -1047,10 +1028,7 @@ ft_cache_dump(struct netlink_ctx *ctx, const struct nft_cache_filter *filter)
 
 void ft_cache_add(struct flowtable *ft, struct table *table)
 {
-	uint32_t hash;
-
-	hash = djb_hash(ft->handle.flowtable.name) % NFT_CACHE_HSIZE;
-	cache_add(&ft->cache, &table->ft_cache, hash);
+	cache_add(&ft->cache, &table->ft_cache, ft->handle.flowtable.name);
 }
 
 void ft_cache_del(struct flowtable *ft)
@@ -1389,8 +1367,11 @@ void cache_free(struct cache *cache)
 	free(cache->ht);
 }
 
-void cache_add(struct cache_item *item, struct cache *cache, uint32_t hash)
+void cache_add(struct cache_item *item, struct cache *cache, const char *name)
 {
+	uint32_t hash;
+
+	hash = djb_hash(name) % NFT_CACHE_HSIZE;
 	list_add_tail(&item->hlist, &cache->ht[hash]);
 	list_add_tail(&item->list, &cache->list);
 }
-- 
2.30.2

