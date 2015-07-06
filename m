From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 12/16] src: consolidate chain cache
Date: Mon,  6 Jul 2015 20:17:04 +0200
Message-ID: <1436206628-23894-13-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40460 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbbGFSLo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:44 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dump the list of existing chains and populate the cache from the initialization
step.

This also include some extra code to validate that the table and chain exists
from the evaluation step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |   51 ++++++++++-----------------------------------------
 1 file changed, 10 insertions(+), 41 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 88b1834..e005ce7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -81,6 +81,13 @@ int cache_init(struct list_head *msgs)
 
 		if (ret < 0)
 			return -1;
+
+		ret = netlink_list_chains(&ctx, &table->handle,
+					  &internal_location);
+		list_splice_tail_init(&ctx.list, &table->chains);
+
+		if (ret < 0)
+			return -1;
 	}
 
 	return 0;
@@ -902,22 +909,6 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
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
@@ -925,30 +916,16 @@ static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
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
@@ -1062,18 +1039,10 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 	struct chain *chain;
-	int err;
-
-	table = table_alloc();
-	handle_merge(&table->handle, &cmd->handle);
-	table_add_hash(table);
 
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		err = netlink_get_chain(ctx, &cmd->handle, &cmd->location);
-		if (err < 0)
-			return err;
-		list_splice_tail_init(&ctx->list, &table->chains);
+		table = table_lookup(&cmd->handle);
 		chain = chain_lookup(table, &cmd->handle);
 
 		return netlink_rename_chain(ctx, &chain->handle, &cmd->location,
-- 
1.7.10.4

