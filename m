From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 04/14] src: add table declaration to cache
Date: Mon, 10 Aug 2015 13:50:38 +0200
Message-ID: <1439207448-22485-5-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55976 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbbHJLo5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:44:57 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add declared table objects to the cache, thus we can refer to objects that
come in this batch but that are not yet available in the kernel. This happens
from the evaluation step.

Get rid of code that is doing this from the later do_command_*() stage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |   15 +++++++++++++--
 src/rule.c     |   15 ++-------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 8598eef..865b707 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1881,6 +1881,19 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 	struct chain *chain;
 	struct set *set;
 
+	if (table_lookup(&ctx->cmd->handle) == NULL) {
+		if (table == NULL) {
+			table = table_alloc();
+			handle_merge(&table->handle, &ctx->cmd->handle);
+			table_add_hash(table);
+		} else {
+			table_add_hash(table_get(table));
+		}
+	}
+
+	if (ctx->cmd->table == NULL)
+		return 0;
+
 	ctx->table = table;
 	list_for_each_entry(set, &table->sets, list) {
 		handle_merge(&set->handle, &table->handle);
@@ -1912,8 +1925,6 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 			return 0;
 		return chain_evaluate(ctx, cmd->chain);
 	case CMD_OBJ_TABLE:
-		if (cmd->data == NULL)
-			return 0;
 		return table_evaluate(ctx, cmd->table);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/rule.c b/src/rule.c
index cb69369..1e5b1a8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -987,15 +987,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	struct table *table = NULL;
 	struct set *set;
 
-	/* No need to allocate the table object when listing all tables */
-	if (cmd->handle.table != NULL) {
+	if (cmd->handle.table != NULL)
 		table = table_lookup(&cmd->handle);
-		if (table == NULL) {
-			table = table_alloc();
-			handle_merge(&table->handle, &cmd->handle);
-			table_add_hash(table);
-		}
-	}
 
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
@@ -1056,14 +1049,10 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct table *table;
+	struct table *table = table_lookup(&cmd->handle);
 	struct chain *chain;
 	int err;
 
-	table = table_alloc();
-	handle_merge(&table->handle, &cmd->handle);
-	table_add_hash(table);
-
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
 		err = netlink_get_chain(ctx, &cmd->handle, &cmd->location);
-- 
1.7.10.4

