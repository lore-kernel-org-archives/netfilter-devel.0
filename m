From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft] rule: add support for display flow tables content
Date: Fri, 20 May 2016 14:55:12 +0200
Message-ID: <1463748912-19762-1-git-send-email-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36567 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbcETMzk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2016 08:55:40 -0400
Received: by mail-wm0-f68.google.com with SMTP id q62so827904wmg.3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 05:55:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit adds a new command that displays the definition of a single
flow table:

If no family is specified, ip is assumed.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/rule.h     |  1 +
 src/evaluate.c     | 11 +++++++++++
 src/parser_bison.y |  4 ++++
 src/rule.c         |  2 ++
 4 files changed, 18 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index ae77c4c..bd24648 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -316,6 +316,7 @@ enum cmd_obj {
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
 	CMD_OBJ_EXPORT,
+	CMD_OBJ_FLOWTABLE,
 	CMD_OBJ_FLOWTABLES,
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 3600ad0..cb4d2a5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2652,6 +2652,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
+	struct set *set;
 	int ret;
 
 	ret = cache_update(cmd->op, ctx->msgs);
@@ -2677,6 +2678,16 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 			return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
 					 cmd->handle.set);
 		return 0;
+	case CMD_OBJ_FLOWTABLE:
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		set = set_lookup(table, cmd->handle.set);
+		if (set == NULL || !(set->flags & SET_F_EVAL))
+			return cmd_error(ctx, "Could not process rule: Flow table '%s' does not exist",
+					 cmd->handle.set);
+		return 0;
 	case CMD_OBJ_CHAIN:
 		table = table_lookup(&cmd->handle);
 		if (table == NULL)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c71f6df..0452b8f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -840,6 +840,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLES, &$3, &@$, NULL);
 			}
+			|	FLOW TABLE	set_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLE, &$3, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
diff --git a/src/rule.c b/src/rule.c
index 1bc5c68..5613f96 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1214,6 +1214,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_ruleset(ctx, cmd);
 	case CMD_OBJ_FLOWTABLES:
 		return do_list_sets(ctx, cmd);
+	case CMD_OBJ_FLOWTABLE:
+		return do_list_set(ctx, cmd, table);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.8.2

