From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 09/14] src: use cache infrastructure for chain objects
Date: Mon, 10 Aug 2015 13:50:43 +0200
Message-ID: <1439207448-22485-10-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56012 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbbHJLpE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:45:04 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The chain list is obtained if the user requests a listing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |   61 ++++++++++++++++++++++--------------------------------------
 1 file changed, 22 insertions(+), 39 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 8461461..b7c834f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -67,7 +67,7 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h)
 	return 0;
 }
 
-static int cache_init_objects(struct netlink_ctx *ctx)
+static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 {
 	struct table *table;
 	int ret;
@@ -79,6 +79,24 @@ static int cache_init_objects(struct netlink_ctx *ctx)
 
 		if (ret < 0)
 			return -1;
+
+		/* Skip caching other objects to speed up things: We only need
+		 * a full cache when listing the existing ruleset or renaming
+		 * a chain.
+		 */
+		switch (cmd) {
+		case CMD_LIST:
+		case CMD_RENAME:
+			break;
+		default:
+			continue;
+		}
+
+		ret = netlink_list_chains(ctx, &table->handle,
+					  &internal_location);
+		if (ret < 0)
+			return -1;
+		list_splice_tail_init(&ctx->list, &table->chains);
 	}
 	return 0;
 }
@@ -98,7 +116,7 @@ static int cache_init(enum cmd_ops cmd, struct list_head *msgs)
 	ret = cache_init_tables(&ctx, &handle);
 	if (ret < 0)
 		return ret;
-	ret = cache_init_objects(&ctx);
+	ret = cache_init_objects(&ctx, cmd);
 	if (ret < 0)
 		return ret;
 
@@ -929,22 +947,6 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 	return 0;
 }
 
-static void table_cleanup(struct table *table)
-{
-	struct chain *chain, *nchain;
-	struct set *set, *nset;
-
-	list_for_each_entry_safe(chain, nchain, &table->chains, list) {
-		list_del(&chain->list);
-		chain_free(chain);
-	}
-
-	list_for_each_entry_safe(set, nset, &table->sets, list) {
-		list_del(&set->list);
-		set_free(set);
-	}
-}
-
 static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 			 struct table *table)
 {
@@ -952,30 +954,16 @@ static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
 	struct chain *chain;
 
 	if (do_list_sets(ctx, &cmd->location, table) < 0)
-		goto err;
-	if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
-		goto err;
-	list_splice_tail_init(&ctx->list, &table->chains);
+		return -1;
 	if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
-		goto err;
+		return -1;
 
 	list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
-		table = table_lookup(&rule->handle);
 		chain = chain_lookup(table, &rule->handle);
-		if (chain == NULL) {
-			chain = chain_alloc(rule->handle.chain);
-			chain_add_hash(chain, table);
-		}
-
 		list_move_tail(&rule->list, &chain->rules);
 	}
-
 	table_print(table);
-	table_cleanup(table);
 	return 0;
-err:
-	table_cleanup(table);
-	return -1;
 }
 
 static int do_list_sets_global(struct netlink_ctx *ctx, struct cmd *cmd)
@@ -1092,14 +1080,9 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = table_lookup(&cmd->handle);
 	struct chain *chain;
-	int err;
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		err = netlink_get_chain(ctx, &cmd->handle, &cmd->location);
-		if (err < 0)
-			return err;
-		list_splice_tail_init(&ctx->list, &table->chains);
 		chain = chain_lookup(table, &cmd->handle);
 
 		return netlink_rename_chain(ctx, &chain->handle, &cmd->location,
-- 
1.7.10.4

