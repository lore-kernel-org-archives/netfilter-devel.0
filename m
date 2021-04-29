Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A35C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD13E6147E
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhD2Xnw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59542 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhD2Xnv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:51 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5C7D46413C
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:24 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 04/18] src: pass chain name to chain_cache_find()
Date:   Fri, 30 Apr 2021 01:42:41 +0200
Message-Id: <20210429234255.16840-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

You can identify chains through the unique handle in deletions, update
this interface to take a string instead of the handle to prepare for
the introduction of 64-bit handle chain lookups.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h |  3 +--
 src/cache.c     |  9 ++++-----
 src/evaluate.c  | 10 +++++-----
 src/netlink.c   |  2 +-
 src/rule.c      |  2 +-
 5 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index f500e1b19e45..0009276701a3 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -57,8 +57,7 @@ int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs
 void cache_release(struct nft_cache *cache);
 
 void chain_cache_add(struct chain *chain, struct table *table);
-struct chain *chain_cache_find(const struct table *table,
-			       const struct handle *handle);
+struct chain *chain_cache_find(const struct table *table, const char *name);
 void set_cache_add(struct set *set, struct table *table);
 struct set *set_cache_find(const struct table *table, const char *name);
 
diff --git a/src/cache.c b/src/cache.c
index f032171a95ff..b38f3b84eda6 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -244,15 +244,14 @@ void chain_cache_add(struct chain *chain, struct table *table)
 	list_add_tail(&chain->cache_list, &table->cache_chain);
 }
 
-struct chain *chain_cache_find(const struct table *table,
-			       const struct handle *handle)
+struct chain *chain_cache_find(const struct table *table, const char *name)
 {
 	struct chain *chain;
 	uint32_t hash;
 
-	hash = djb_hash(handle->chain.name) % NFT_CACHE_HSIZE;
+	hash = djb_hash(name) % NFT_CACHE_HSIZE;
 	list_for_each_entry(chain, &table->cache_chain_ht[hash], cache_hlist) {
-		if (!strcmp(chain->handle.chain.name, handle->chain.name))
+		if (!strcmp(chain->handle.chain.name, name))
 			return chain;
 	}
 
@@ -421,7 +420,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 		if (flags & NFT_CACHE_RULE_BIT) {
 			ret = netlink_list_rules(ctx, &table->handle);
 			list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
-				chain = chain_cache_find(table, &rule->handle);
+				chain = chain_cache_find(table, rule->handle.chain.name);
 				if (!chain)
 					chain = chain_binding_lookup(table,
 							rule->handle.chain.name);
diff --git a/src/evaluate.c b/src/evaluate.c
index c52309f46f59..2c8a649f5392 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4002,7 +4002,7 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
 	if (!table)
 		return table_not_found(ctx);
 
-	chain = chain_cache_find(table, &rule->handle);
+	chain = chain_cache_find(table, rule->handle.chain.name);
 	if (!chain)
 		return chain_not_found(ctx);
 
@@ -4145,14 +4145,14 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 		return table_not_found(ctx);
 
 	if (chain == NULL) {
-		if (chain_cache_find(table, &ctx->cmd->handle) == NULL) {
+		if (!chain_cache_find(table, ctx->cmd->handle.chain.name)) {
 			chain = chain_alloc(NULL);
 			handle_merge(&chain->handle, &ctx->cmd->handle);
 			chain_cache_add(chain, table);
 		}
 		return 0;
 	} else if (!(chain->flags & CHAIN_F_BINDING)) {
-		if (chain_cache_find(table, &chain->handle) == NULL)
+		if (!chain_cache_find(table, chain->handle.chain.name))
 			chain_cache_add(chain_get(chain), table);
 	}
 
@@ -4482,7 +4482,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		if (chain_cache_find(table, &cmd->handle) == NULL)
+		if (!chain_cache_find(table, cmd->handle.chain.name))
 			return chain_not_found(ctx);
 
 		return 0;
@@ -4642,7 +4642,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		if (chain_cache_find(table, &ctx->cmd->handle) == NULL)
+		if (!chain_cache_find(table, ctx->cmd->handle.chain.name))
 			return chain_not_found(ctx);
 
 		break;
diff --git a/src/netlink.c b/src/netlink.c
index e8b016096b67..123525570c39 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1718,7 +1718,7 @@ static struct rule *trace_lookup_rule(const struct nftnl_trace *nlt,
 	if (!table)
 		return NULL;
 
-	chain = chain_cache_find(table, &h);
+	chain = chain_cache_find(table, h.chain.name);
 	if (!chain)
 		return NULL;
 
diff --git a/src/rule.c b/src/rule.c
index 2c6292c4e173..fac8d22a85ee 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2608,7 +2608,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		chain = chain_cache_find(table, &cmd->handle);
+		chain = chain_cache_find(table, cmd->handle.chain.name);
 
 		return mnl_nft_chain_rename(ctx, cmd, chain);
 	default:
-- 
2.20.1

