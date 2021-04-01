Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27923C43461
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 20:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA6DC610CF
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 20:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhDAU3f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 16:29:35 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53704 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbhDAU3f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 16:29:35 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0249E63E43
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 22:29:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] evaluate: use chain hashtable for lookups
Date:   Thu,  1 Apr 2021 22:29:27 +0200
Message-Id: <20210401202928.5222-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210401202928.5222-1-pablo@netfilter.org>
References: <20210401202928.5222-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of the linear list lookup.

Before this patch:

real    0m21,735s
user    0m20,329s
sys     0m1,384s

After:

real    0m10,910s
user    0m9,448s
sys     0m1,434s

chain_lookup() is removed since linear list lookups are only used by the
fuzzy chain name matching for error reporting.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |  2 --
 src/evaluate.c |  8 ++++----
 src/netlink.c  |  2 +-
 src/rule.c     | 13 +------------
 4 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 6c6ada6b5537..ad9cca90570d 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -259,8 +259,6 @@ extern const char *chain_hookname_lookup(const char *name);
 extern struct chain *chain_alloc(const char *name);
 extern struct chain *chain_get(struct chain *chain);
 extern void chain_free(struct chain *chain);
-extern struct chain *chain_lookup(const struct table *table,
-				  const struct handle *h);
 extern struct chain *chain_lookup_fuzzy(const struct handle *h,
 					const struct nft_cache *cache,
 					const struct table **table);
diff --git a/src/evaluate.c b/src/evaluate.c
index cebf7cb8ef2c..691920b04093 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4106,14 +4106,14 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 		return table_not_found(ctx);
 
 	if (chain == NULL) {
-		if (chain_lookup(table, &ctx->cmd->handle) == NULL) {
+		if (chain_cache_find(table, &ctx->cmd->handle) == NULL) {
 			chain = chain_alloc(NULL);
 			handle_merge(&chain->handle, &ctx->cmd->handle);
 			chain_cache_add(chain, table);
 		}
 		return 0;
 	} else if (!(chain->flags & CHAIN_F_BINDING)) {
-		if (chain_lookup(table, &chain->handle) == NULL)
+		if (chain_cache_find(table, &chain->handle) == NULL)
 			chain_cache_add(chain_get(chain), table);
 	}
 
@@ -4440,7 +4440,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		if (chain_lookup(table, &cmd->handle) == NULL)
+		if (chain_cache_find(table, &cmd->handle) == NULL)
 			return chain_not_found(ctx);
 
 		return 0;
@@ -4600,7 +4600,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return table_not_found(ctx);
 
-		if (chain_lookup(table, &ctx->cmd->handle) == NULL)
+		if (chain_cache_find(table, &ctx->cmd->handle) == NULL)
 			return chain_not_found(ctx);
 
 		break;
diff --git a/src/netlink.c b/src/netlink.c
index 103fdbd10690..50318f95e690 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1746,7 +1746,7 @@ static struct rule *trace_lookup_rule(const struct nftnl_trace *nlt,
 	if (!table)
 		return NULL;
 
-	chain = chain_lookup(table, &h);
+	chain = chain_cache_find(table, &h);
 	if (!chain)
 		return NULL;
 
diff --git a/src/rule.c b/src/rule.c
index 5be9c0c82444..9c9fd7fdac6d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -761,17 +761,6 @@ void chain_free(struct chain *chain)
 	xfree(chain);
 }
 
-struct chain *chain_lookup(const struct table *table, const struct handle *h)
-{
-	struct chain *chain;
-
-	list_for_each_entry(chain, &table->cache_chain, cache_list) {
-		if (!strcmp(chain->handle.chain.name, h->chain.name))
-			return chain;
-	}
-	return NULL;
-}
-
 struct chain *chain_binding_lookup(const struct table *table,
 				   const char *chain_name)
 {
@@ -2625,7 +2614,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		chain = chain_lookup(table, &cmd->handle);
+		chain = chain_cache_find(table, &cmd->handle);
 
 		return mnl_nft_chain_rename(ctx, cmd, chain);
 	default:
-- 
2.20.1

