From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/3 v2] rule: factorize chain and table listing code
Date: Wed, 24 Sep 2014 12:32:19 +0200
Message-ID: <1411554740-16660-2-git-send-email-arturo.borrero.glez@gmail.com>
References: <1411554740-16660-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49254 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750793AbaIXKdJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:33:09 -0400
In-Reply-To: <1411554740-16660-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's factorize common code. This is also useful in follow-up patches.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: rename function to do_list_table()

 src/rule.c |   67 +++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index ab533da..336c159 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -749,11 +749,42 @@ static void table_cleanup(struct table *table)
 	}
 }
 
+static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
+			 struct table *table)
+{
+	struct rule *rule, *nrule;
+	struct chain *chain;
+
+	if (do_list_sets(ctx, &cmd->location, table) < 0)
+		goto err;
+	if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
+		goto err;
+	list_splice_tail_init(&ctx->list, &table->chains);
+	if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
+		goto err;
+
+	list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
+		table = table_lookup(&rule->handle);
+		chain = chain_lookup(table, &rule->handle);
+		if (chain == NULL) {
+			chain = chain_alloc(rule->handle.chain);
+			chain_add_hash(chain, table);
+		}
+
+		list_move_tail(&rule->list, &chain->rules);
+	}
+
+	table_print(table);
+	table_cleanup(table);
+	return 0;
+err:
+	table_cleanup(table);
+	return -1;
+}
+
 static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table = NULL;
-	struct chain *chain;
-	struct rule *rule, *nrule;
 	struct set *set;
 
 	/* No need to allocate the table object when listing all tables */
@@ -781,24 +812,9 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 			}
 			return 0;
 		}
-		/* List content of this table */
-		if (do_list_sets(ctx, &cmd->location, table) < 0)
-			goto err;
-		if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
-			goto err;
-		list_splice_tail_init(&ctx->list, &table->chains);
-		if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
-			goto err;
-		break;
+		return do_list_table(ctx, cmd, table);
 	case CMD_OBJ_CHAIN:
-		if (do_list_sets(ctx, &cmd->location, table) < 0)
-			goto err;
-		if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
-			goto err;
-		list_splice_tail_init(&ctx->list, &table->chains);
-		if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
-			goto err;
-		break;
+		return do_list_table(ctx, cmd, table);
 	case CMD_OBJ_SETS:
 		if (netlink_list_sets(ctx, &cmd->handle, &cmd->location) < 0)
 			goto err;
@@ -825,19 +841,6 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
 
-	list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
-		table = table_lookup(&rule->handle);
-		chain = chain_lookup(table, &rule->handle);
-		if (chain == NULL) {
-			chain = chain_alloc(rule->handle.chain);
-			chain_add_hash(chain, table);
-		}
-
-		list_move_tail(&rule->list, &chain->rules);
-	}
-
-	table_print(table);
-	table_cleanup(table);
 	return 0;
 err:
 	table_cleanup(table);
-- 
1.7.10.4

