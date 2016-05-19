From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft] rule: add 'list flow tables' support
Date: Thu, 19 May 2016 14:46:03 +0200
Message-ID: <1463661963-7561-1-git-send-email-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36684 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbcESMrd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 May 2016 08:47:33 -0400
Received: by mail-wm0-f66.google.com with SMTP id w143so20657433wmw.3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2016 05:47:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit adds a new command that lists flow tables:

    # nft list flow tables [family]

Only the declaration is displayed. If no family is specified, all flow
tables of all families are listed.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/rule.h     |  1 +
 src/evaluate.c     |  1 +
 src/parser_bison.y |  4 ++++
 src/rule.c         | 17 +++++++++++++++--
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index bfe398d..ae77c4c 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -316,6 +316,7 @@ enum cmd_obj {
 	CMD_OBJ_EXPR,
 	CMD_OBJ_MONITOR,
 	CMD_OBJ_EXPORT,
+	CMD_OBJ_FLOWTABLES,
 };
 
 struct export {
diff --git a/src/evaluate.c b/src/evaluate.c
index c317761..3600ad0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2689,6 +2689,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CHAINS:
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_RULESET:
+	case CMD_OBJ_FLOWTABLES:
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 76cf65c..c71f6df 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -836,6 +836,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_RULESET, &$2, &@$, NULL);
 			}
+			|	FLOW TABLES	ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_FLOWTABLES, &$3, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
diff --git a/src/rule.c b/src/rule.c
index b2f58f4..7a5c70c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -258,7 +258,14 @@ static void set_print_declaration(const struct set *set,
 	const char *type;
 	uint32_t flags;
 
-	type = set->flags & SET_F_MAP ? "map" : "set";
+	if (set->flags & SET_F_MAP) {
+		type = "map";
+	} else if (set->flags & SET_F_EVAL) {
+		type = "flow table";
+	} else {
+		type = "set";
+	}
+
 	printf("%s%s", opts->tab, type);
 
 	if (opts->family != NULL)
@@ -1067,7 +1074,11 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
 		       table->handle.table);
 
 		list_for_each_entry(set, &table->sets, list) {
-			if (set->flags & SET_F_ANONYMOUS)
+			if (cmd->obj == CMD_OBJ_SETS &&
+			    set->flags & SET_F_ANONYMOUS)
+				continue;
+			if (cmd->obj == CMD_OBJ_FLOWTABLES &&
+			    !(set->flags & SET_F_EVAL))
 				continue;
 			set_print_declaration(set, &opts);
 			printf("%s}%s", opts.tab, opts.nl);
@@ -1202,6 +1213,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_set(ctx, cmd, table);
 	case CMD_OBJ_RULESET:
 		return do_list_ruleset(ctx, cmd);
+	case CMD_OBJ_FLOWTABLES:
+		return do_list_sets(ctx, cmd);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
-- 
2.8.2

