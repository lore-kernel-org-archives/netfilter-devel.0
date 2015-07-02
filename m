From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v3 2/7] src: add table declaration to cache
Date: Thu,  2 Jul 2015 20:25:07 +0200
Message-ID: <1435861512-23572-3-git-send-email-pablo@netfilter.org>
References: <1435861512-23572-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53399 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbbGBSTp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 14:19:45 -0400
In-Reply-To: <1435861512-23572-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch prepares the set cache consolidation to avoid that sets are added
twice, once from do_add_table() which iterates over the set list when cmd->data
is set, and then again from the do_add_set().

Table objects that are declared with no table block to the cache are now
available through table_lookup().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c     |    2 --
 src/parser_bison.y |   10 ++++++++--
 src/rule.c         |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d99b38f..576509c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1910,8 +1910,6 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 			return 0;
 		return chain_evaluate(ctx, cmd->chain);
 	case CMD_OBJ_TABLE:
-		if (cmd->data == NULL)
-			return 0;
 		return table_evaluate(ctx, cmd->table);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5c4e272..5f2fb1d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -654,7 +654,10 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 
 add_cmd			:	TABLE		table_spec
 			{
-				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_TABLE, &$2, &@$, NULL);
+				struct table *table = table_alloc();
+
+				handle_merge(&table->handle, &$2);
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_TABLE, &$2, &@$, table);
 			}
 			|	TABLE		table_spec	table_block_alloc
 						'{'	table_block	'}'
@@ -705,7 +708,10 @@ add_cmd			:	TABLE		table_spec
 
 create_cmd		:	TABLE		table_spec
 			{
-				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_TABLE, &$2, &@$, NULL);
+				struct table *table = table_alloc();
+
+				handle_merge(&table->handle, &$2);
+				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_TABLE, &$2, &@$, table);
 			}
 			|	TABLE		table_spec	table_block_alloc
 						'{'	table_block	'}'
diff --git a/src/rule.c b/src/rule.c
index 5df0eda..98bb1eb 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -759,7 +759,7 @@ static int do_add_table(struct netlink_ctx *ctx, const struct handle *h,
 
 	if (netlink_add_table(ctx, h, loc, table, excl) < 0)
 		return -1;
-	if (table != NULL) {
+	if (table->scope.parent != NULL) {
 		list_for_each_entry(chain, &table->chains, list) {
 			if (netlink_add_chain(ctx, &chain->handle,
 					      &chain->location, chain,
-- 
1.7.10.4

