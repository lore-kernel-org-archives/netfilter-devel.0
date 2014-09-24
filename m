From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/2] rule: factorize chain and table listing code
Date: Wed, 24 Sep 2014 11:13:51 +0200
Message-ID: <20140924091351.13585.92650.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52001 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753653AbaIXJN7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:13:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's factorize common code. This is also useful in follow-up patches.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/rule.c |   67 +++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 2fe2520..ac72f12 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -749,11 +749,42 @@ static void do_command_list_cleanup(struct table *table)
 	}
 }
 
+static int do_command_list_table_content(struct netlink_ctx *ctx,
+					 struct cmd *cmd, struct table *table)
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
+	do_command_list_cleanup(table);
+	return 0;
+err:
+	do_command_list_cleanup(table);
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
+		return do_command_list_table_content(ctx, cmd, table);
 	case CMD_OBJ_CHAIN:
-		if (do_list_sets(ctx, &cmd->location, table) < 0)
-			goto err;
-		if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
-			goto err;
-		list_splice_tail_init(&ctx->list, &table->chains);
-		if (netlink_list_table(ctx, &cmd->handle, &cmd->location) < 0)
-			goto err;
-		break;
+		return do_command_list_table_content(ctx, cmd, table);
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
-	do_command_list_cleanup(table);
 	return 0;
 err:
 	do_command_list_cleanup(table);

