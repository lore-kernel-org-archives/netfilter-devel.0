Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C19C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 20:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5360C610D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 20:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhDAU3f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 16:29:35 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53700 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbhDAU3e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 16:29:34 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 84353630C2
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 22:29:16 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/4] cache: rename chain_htable to cache_chain_ht
Date:   Thu,  1 Apr 2021 22:29:25 +0200
Message-Id: <20210401202928.5222-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rename the hashtable chain that is used for fast cache lookups.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h | 4 ++--
 src/cache.c    | 6 +++---
 src/rule.c     | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 4ef24eb4ec63..f8e615121113 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -155,7 +155,7 @@ struct table {
 	struct handle		handle;
 	struct location		location;
 	struct scope		scope;
-	struct list_head	*chain_htable;
+	struct list_head	*cache_chain_ht;
 	struct list_head	chains;
 	struct list_head	sets;
 	struct list_head	objs;
@@ -230,7 +230,7 @@ struct hook_spec {
  */
 struct chain {
 	struct list_head	list;
-	struct list_head	hlist;
+	struct list_head	cache_hlist;
 	struct handle		handle;
 	struct location		location;
 	unsigned int		refcnt;
diff --git a/src/cache.c b/src/cache.c
index 63971e865622..400128906b03 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -195,7 +195,7 @@ static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 	if (chain->flags & CHAIN_F_BINDING) {
 		list_add_tail(&chain->list, &ctx->table->chain_bindings);
 	} else {
-		list_add_tail(&chain->hlist, &ctx->table->chain_htable[hash]);
+		list_add_tail(&chain->cache_hlist, &ctx->table->cache_chain_ht[hash]);
 		list_add_tail(&chain->list, &ctx->table->chains);
 	}
 
@@ -239,7 +239,7 @@ void chain_cache_add(struct chain *chain, struct table *table)
 	uint32_t hash;
 
 	hash = djb_hash(chain->handle.chain.name) % NFT_CACHE_HSIZE;
-	list_add_tail(&chain->hlist, &table->chain_htable[hash]);
+	list_add_tail(&chain->cache_hlist, &table->cache_chain_ht[hash]);
 	list_add_tail(&chain->list, &table->chains);
 }
 
@@ -250,7 +250,7 @@ struct chain *chain_cache_find(const struct table *table,
 	uint32_t hash;
 
 	hash = djb_hash(handle->chain.name) % NFT_CACHE_HSIZE;
-	list_for_each_entry(chain, &table->chain_htable[hash], hlist) {
+	list_for_each_entry(chain, &table->cache_chain_ht[hash], cache_hlist) {
 		if (!strcmp(chain->handle.chain.name, handle->chain.name))
 			return chain;
 	}
diff --git a/src/rule.c b/src/rule.c
index 969318008933..79706ab7b60a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1140,10 +1140,10 @@ struct table *table_alloc(void)
 	init_list_head(&table->scope.symbols);
 	table->refcnt = 1;
 
-	table->chain_htable =
+	table->cache_chain_ht =
 		xmalloc(sizeof(struct list_head) * NFT_CACHE_HSIZE);
 	for (i = 0; i < NFT_CACHE_HSIZE; i++)
-		init_list_head(&table->chain_htable[i]);
+		init_list_head(&table->cache_chain_ht[i]);
 
 	return table;
 }
@@ -1171,7 +1171,7 @@ void table_free(struct table *table)
 		obj_free(obj);
 	handle_free(&table->handle);
 	scope_release(&table->scope);
-	xfree(table->chain_htable);
+	xfree(table->cache_chain_ht);
 	xfree(table);
 }
 
-- 
2.20.1

