From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 02/14] src: add cmd_evaluate_list()
Date: Mon, 10 Aug 2015 13:50:36 +0200
Message-ID: <1439207448-22485-3-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55981 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbbHJLo6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:44:58 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function validates that the table that we want to list already exists by
looking it up from the cache.

This also adds cmd_error() to display an error from the evaluation step, when
the objects that the rule indicates do not exist.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index f8c7372..8598eef 100644
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
@@ -1933,6 +1935,26 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_TABLE:
+		if (cmd->handle.table == NULL)
+			return 0;
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
@@ -2024,6 +2046,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_DELETE:
 		return cmd_evaluate_delete(ctx, cmd);
 	case CMD_LIST:
+		return cmd_evaluate_list(ctx, cmd);
 	case CMD_FLUSH:
 	case CMD_RENAME:
 	case CMD_EXPORT:
-- 
1.7.10.4

