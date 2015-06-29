From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/7] src: always allocate table object with no table block
Date: Mon, 29 Jun 2015 19:53:59 +0200
Message-ID: <1435600444-21529-3-git-send-email-pablo@netfilter.org>
References: <1435600444-21529-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57257 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbbF2Rsl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 13:48:41 -0400
In-Reply-To: <1435600444-21529-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the table object to the cache, so it can be reused in the linear list
way to express updates.

The CMD_OBJ_RULESET is used to know if the table block, that contains the
chain, set and rule declarations, is present.

This patch prepares the set cache consolidation to avoid that sets are added
twice, once from do_add_table() which iterates over the set list when cmd->data
is set, and then again from the do_add_set().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c     |    3 +--
 src/parser_bison.y |    7 ++++---
 src/rule.c         |   44 ++++++++++++++++++++++++++++----------------
 3 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d99b38f..ac90162 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1910,8 +1910,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 			return 0;
 		return chain_evaluate(ctx, cmd->chain);
 	case CMD_OBJ_TABLE:
-		if (cmd->data == NULL)
-			return 0;
+	case CMD_OBJ_RULESET:
 		return table_evaluate(ctx, cmd->table);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5c4e272..2b742a7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -652,16 +652,17 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
 			;
 
-add_cmd			:	TABLE		table_spec
+add_cmd			:	TABLE		table_spec	table_block_alloc
 			{
-				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_TABLE, &$2, &@$, NULL);
+				handle_merge(&$3->handle, &$2);
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_TABLE, &$2, &@$, $3);
 			}
 			|	TABLE		table_spec	table_block_alloc
 						'{'	table_block	'}'
 			{
 				handle_merge(&$3->handle, &$2);
 				close_scope(state);
-				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_TABLE, &$2, &@$, $5);
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_RULESET, &$2, &@$, $5);
 			}
 			|	CHAIN		chain_spec
 			{
diff --git a/src/rule.c b/src/rule.c
index cbc4931..d250549 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -698,6 +698,10 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_TABLE:
 			table_free(cmd->table);
 			break;
+		case CMD_OBJ_RULESET:
+			if (cmd->data != NULL)
+				table_free(cmd->table);
+			break;
 		case CMD_OBJ_EXPR:
 			expr_free(cmd->expr);
 			break;
@@ -757,27 +761,32 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 			const struct location *loc, struct table *table,
 			bool excl)
 {
+	return netlink_add_table(ctx, h, loc, table, excl);
+}
+
+static int do_add_ruleset(struct netlink_ctx *ctx, const struct handle *h,
+			  const struct location *loc, struct table *table,
+			  bool excl)
+{
 	struct chain *chain;
 	struct set *set;
 
 	if (netlink_add_table(ctx, h, loc, table, excl) < 0)
 		return -1;
-	if (table != NULL) {
-		list_for_each_entry(chain, &table->chains, list) {
-			if (netlink_add_chain(ctx, &chain->handle,
-					      &chain->location, chain,
-					      excl) < 0)
-				return -1;
-		}
-		list_for_each_entry(set, &table->sets, list) {
-			handle_merge(&set->handle, &table->handle);
-			if (do_add_set(ctx, &set->handle, set) < 0)
-				return -1;
-		}
-		list_for_each_entry(chain, &table->chains, list) {
-			if (netlink_add_rule_list(ctx, h, &chain->rules) < 0)
-				return -1;
-		}
+
+	list_for_each_entry(chain, &table->chains, list) {
+		if (netlink_add_chain(ctx, &chain->handle, &chain->location,
+				      chain, excl) < 0)
+			return -1;
+	}
+	list_for_each_entry(set, &table->sets, list) {
+		handle_merge(&set->handle, &table->handle);
+		if (do_add_set(ctx, &set->handle, set) < 0)
+			return -1;
+	}
+	list_for_each_entry(chain, &table->chains, list) {
+		if (netlink_add_rule_list(ctx, h, &chain->rules) < 0)
+			return -1;
 	}
 	return 0;
 }
@@ -798,6 +807,9 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 		return do_add_set(ctx, &cmd->handle, cmd->set);
 	case CMD_OBJ_SETELEM:
 		return do_add_setelems(ctx, &cmd->handle, cmd->expr);
+	case CMD_OBJ_RULESET:
+		return do_add_ruleset(ctx, &cmd->handle, &cmd->location,
+				      cmd->table, excl);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
1.7.10.4

