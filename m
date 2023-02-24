Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1F0C61DA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Feb 2023 10:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBXKsB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Feb 2023 05:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBXKr7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Feb 2023 05:47:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB9B07DA1
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2023 02:47:57 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 2/2,v2] src: expand table command before evaluation
Date:   Fri, 24 Feb 2023 11:47:52 +0100
Message-Id: <20230224104752.144447-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230224104752.144447-1-pablo@netfilter.org>
References: <20230224104752.144447-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The nested syntax notation results in one single table command which
includes all other objects. This differs from the flat notation where
there is usually one command per object.

This patch adds a previous step to the evaluation phase to expand the
objects that are contained in the table into independent commands, so
both notations have similar representations.

Remove the code to evaluate the nested representation in the evaluation
phase since command are independently evaluated after the expansion.

The commands are expanded after the set element collapse step, in case
that there is a long list of singleton element commands to be added to
the set before, to shorten the command list iteration.

This approach also avoids interference with the object cache that is
populated in the evaluation, which might refer to objects coming in the
existing command list that is being processed.

There is still a post_expand phase to detach the elements from the set
which could be consolidated by updating the evaluation step to handle
the CMD_OBJ_SETELEMS command type.

This patch fixes 27c753e4a8d4 ("rule: expand standalone chain that
contains rules") which broken rule addition/insertion by index because
the expansion code after the evaluation messes up the cache.

Fixes: 27c753e4a8d4 ("rule: expand standalone chain that contains rules")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: expand commands after set element command collapse step.

 include/rule.h    |  1 +
 src/evaluate.c    | 39 ---------------------------------------
 src/libnftables.c |  9 ++++++++-
 src/rule.c        | 19 ++++++++++++++++++-
 4 files changed, 27 insertions(+), 41 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 0828d16122ac..f3db6aabf1ff 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -736,6 +736,7 @@ extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 			     const struct handle *h, const struct location *loc,
 			     void *data);
 extern void nft_cmd_expand(struct cmd *cmd);
+extern void nft_cmd_post_expand(struct cmd *cmd);
 extern bool nft_cmd_collapse(struct list_head *cmds);
 extern void nft_cmd_uncollapse(struct list_head *cmds);
 extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
diff --git a/src/evaluate.c b/src/evaluate.c
index d24f8b66b0de..506c2414b9e8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4821,7 +4821,6 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 {
 	struct table *table;
-	struct rule *rule;
 
 	table = table_cache_find(&ctx->nft->cache.table_cache,
 				 ctx->cmd->handle.table.name,
@@ -4877,11 +4876,6 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 		}
 	}
 
-	list_for_each_entry(rule, &chain->rules, list) {
-		handle_merge(&rule->handle, &chain->handle);
-		if (rule_evaluate(ctx, rule, CMD_INVALID) < 0)
-			return -1;
-	}
 	return 0;
 }
 
@@ -4949,11 +4943,6 @@ static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 
 static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 {
-	struct flowtable *ft;
-	struct chain *chain;
-	struct set *set;
-	struct obj *obj;
-
 	if (!table_cache_find(&ctx->nft->cache.table_cache,
 			      ctx->cmd->handle.table.name,
 			      ctx->cmd->handle.family)) {
@@ -4966,34 +4955,6 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 		}
 	}
 
-	if (ctx->cmd->table == NULL)
-		return 0;
-
-	ctx->table = table;
-	list_for_each_entry(set, &table->sets, list) {
-		expr_set_context(&ctx->ectx, NULL, 0);
-		handle_merge(&set->handle, &table->handle);
-		if (set_evaluate(ctx, set) < 0)
-			return -1;
-	}
-	list_for_each_entry(chain, &table->chains, list) {
-		handle_merge(&chain->handle, &table->handle);
-		ctx->cmd->handle.chain.location = chain->location;
-		if (chain_evaluate(ctx, chain) < 0)
-			return -1;
-	}
-	list_for_each_entry(ft, &table->flowtables, list) {
-		handle_merge(&ft->handle, &table->handle);
-		if (flowtable_evaluate(ctx, ft) < 0)
-			return -1;
-	}
-	list_for_each_entry(obj, &table->objs, list) {
-		handle_merge(&obj->handle, &table->handle);
-		if (obj_evaluate(ctx, obj) < 0)
-			return -1;
-	}
-
-	ctx->table = NULL;
 	return 0;
 }
 
diff --git a/src/libnftables.c b/src/libnftables.c
index ec01a427d6cc..4f538c44b998 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -519,6 +519,13 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	if (nft_cmd_collapse(cmds))
 		collapsed = true;
 
+	list_for_each_entry(cmd, cmds, list) {
+		if (cmd->op != CMD_ADD)
+			continue;
+
+		nft_cmd_expand(cmd);
+	}
+
 	list_for_each_entry_safe(cmd, next, cmds, list) {
 		struct eval_ctx ectx = {
 			.nft	= nft,
@@ -542,7 +549,7 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 		if (cmd->op != CMD_ADD)
 			continue;
 
-		nft_cmd_expand(cmd);
+		nft_cmd_post_expand(cmd);
 	}
 
 	return 0;
diff --git a/src/rule.c b/src/rule.c
index c162059bfd9e..047e405707f6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1318,8 +1318,9 @@ static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds
 
 	list_for_each_entry_safe(rule, next, &chain->rules, list) {
 		list_del(&rule->list);
+		handle_merge(&rule->handle, &chain->handle);
 		memset(&h, 0, sizeof(h));
-		handle_merge(&h, &rule->handle);
+		handle_merge(&h, &chain->handle);
 		if (chain->flags & CHAIN_F_BINDING) {
 			rule->handle.chain_id = chain->handle.chain_id;
 			rule->handle.chain.location = chain->location;
@@ -1350,6 +1351,7 @@ void nft_cmd_expand(struct cmd *cmd)
 			return;
 
 		list_for_each_entry(chain, &table->chains, list) {
+			handle_merge(&chain->handle, &table->handle);
 			memset(&h, 0, sizeof(h));
 			handle_merge(&h, &chain->handle);
 			h.chain_id = chain->handle.chain_id;
@@ -1394,6 +1396,21 @@ void nft_cmd_expand(struct cmd *cmd)
 		nft_cmd_expand_chain(chain, &new_cmds);
 		list_splice(&new_cmds, &cmd->list);
 		break;
+	default:
+		break;
+	}
+}
+
+void nft_cmd_post_expand(struct cmd *cmd)
+{
+	struct list_head new_cmds;
+	struct set *set;
+	struct cmd *new;
+	struct handle h;
+
+	init_list_head(&new_cmds);
+
+	switch (cmd->obj) {
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		set = cmd->set;
-- 
2.30.2

