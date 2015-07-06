From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 02/16] src: add cmd_evaluate_list()
Date: Mon,  6 Jul 2015 20:16:54 +0200
Message-ID: <1436206628-23894-3-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40422 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbbGFSLi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:38 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function validates that the table that we want to list already exists by
looking up from the new table cache.

This also adds cmd_error() to display an error from the evaluation step, when
the objects that the rule indicates do not exist.

We can now simplify the later handling at do_command_list() since we're now
sure that the table exists at that stage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |   21 +++++++++++++++++++++
 src/rule.c     |    9 +--------
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d99b38f..c6c6038 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -62,6 +62,8 @@ static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define monitor_error(ctx, s1, fmt, args...) \
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
+#define cmd_error(ctx, fmt, args...) \
+	__stmt_binary_error(ctx, &(ctx->cmd)->location, NULL, fmt, ## args)
 
 static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 				       const struct set *set,
@@ -1933,6 +1935,24 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_TABLE:
+	case CMD_OBJ_CHAIN:
+	case CMD_OBJ_SETS:
+	case CMD_OBJ_SET:
+		if (table_lookup(&cmd->handle) == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		return 0;
+	case CMD_OBJ_RULESET:
+		return 0;
+	default:
+		BUG("invalid command object type %u\n", cmd->obj);
+	}
+}
+
 enum {
 	CMD_MONITOR_EVENT_ANY,
 	CMD_MONITOR_EVENT_NEW,
@@ -2018,6 +2038,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_DELETE:
 		return cmd_evaluate_delete(ctx, cmd);
 	case CMD_LIST:
+		return cmd_evaluate_list(ctx, cmd);
 	case CMD_FLUSH:
 	case CMD_RENAME:
 	case CMD_EXPORT:
diff --git a/src/rule.c b/src/rule.c
index 3813039..4ae32b8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -940,15 +940,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
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
-- 
1.7.10.4

