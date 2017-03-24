From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 1/2] src: Make flush command selective of the set
 structure type
Date: Fri, 24 Mar 2017 12:30:41 -0300
Message-ID: <20170324153041.GA6413@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36503 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935200AbdCXPbQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 11:31:16 -0400
Received: by mail-qk0-f195.google.com with SMTP id n141so864045qke.3
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 08:31:10 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The internal set infrastructure is used for sets, maps and flow tables.
The flush command requires the set type but currently it works for all
of them. E.g. if there is a set named 's' in a table 't' the following
command shouldn't be valid but still executes:

$ nft flush flow table t s

This patch makes the flush command selective so 'flush flow table' only
works in flow tables and so on.

Fixes: 6d37dae ("parser_bison: Allow flushing maps")
Fixes: 2daa0ee ("parser_bison: Allow flushing flow tables")
Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 src/evaluate.c     | 33 ++++++++++++++++++++++++++++++++-
 src/parser_bison.y |  8 ++++----
 src/rule.c         |  2 ++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b5db724..49c5953 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3080,6 +3080,8 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	struct table *table;
+	struct set *set;
 	int ret;
 
 	ret = cache_update(cmd->op, ctx->msgs);
@@ -3096,8 +3098,37 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 		 */
 	case CMD_OBJ_CHAIN:
 		/* Chains don't hold sets */
-	case CMD_OBJ_SET:
 		break;
+	case CMD_OBJ_SET:
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		set = set_lookup(table, cmd->handle.set);
+		if (set == NULL || set->flags & (NFT_SET_MAP | NFT_SET_EVAL))
+			return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
+					 cmd->handle.set);
+		return 0;
+	case CMD_OBJ_MAP:
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		set = set_lookup(table, cmd->handle.set);
+		if (set == NULL || !(set->flags & NFT_SET_MAP))
+			return cmd_error(ctx, "Could not process rule: Map '%s' does not exist",
+					 cmd->handle.set);
+		return 0;
+	case CMD_OBJ_FLOWTABLE:
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		set = set_lookup(table, cmd->handle.set);
+		if (set == NULL || !(set->flags & NFT_SET_EVAL))
+			return cmd_error(ctx, "Could not process rule: Flow table '%s' does not exist",
+					 cmd->handle.set);
+		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 841b2e1..9f993fd 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1127,13 +1127,13 @@ flush_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$2, &@$, NULL);
 			}
-			|	FLOW TABLE	set_spec
+			|	MAP		set_spec
 			{
-				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$3, &@$, NULL);
+				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_MAP, &$2, &@$, NULL);
 			}
-			|	MAP		set_spec
+			|	FLOW TABLE	set_spec
 			{
-				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$2, &@$, NULL);
+				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_FLOWTABLE, &$3, &@$, NULL);
 			}
 			|	RULESET		ruleset_spec
 			{
diff --git a/src/rule.c b/src/rule.c
index 997a624..209cf2d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1512,6 +1512,8 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CHAIN:
 		return netlink_flush_chain(ctx, &cmd->handle, &cmd->location);
 	case CMD_OBJ_SET:
+	case CMD_OBJ_MAP:
+	case CMD_OBJ_FLOWTABLE:
 		return netlink_flush_setelems(ctx, &cmd->handle,
 					      &cmd->location);
 	case CMD_OBJ_RULESET:
-- 
2.7.4

