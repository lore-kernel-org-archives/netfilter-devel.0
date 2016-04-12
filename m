From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH v3] src/evaluate.c: improve rule management checks
Date: Tue, 12 Apr 2016 11:44:17 +0200
Message-ID: <146045423317.18092.10497374259960545713.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46220 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932110AbcDLJo2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 05:44:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Improve checks (and error reporting) for basic rule management operations.
This includes a fix for netfilter bug #965.

Netfilter bug: http://bugzilla.netfilter.org/show_bug.cgi?id=965
Reported-by: Jesper Sander Lindgren <sander.contrib@gmail.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v3: refreshed error messages with Pablo's suggestions

 src/evaluate.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 473f014..d9ac854 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -65,6 +65,12 @@ static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
 #define cmd_error(ctx, fmt, args...) \
 	__stmt_binary_error(ctx, &(ctx->cmd)->location, NULL, fmt, ## args)
+#define handle_error(ctx, fmt, args...) \
+	__stmt_binary_error(ctx, &ctx->cmd->handle.handle.location, NULL, fmt, ## args)
+#define position_error(ctx, fmt, args...) \
+	__stmt_binary_error(ctx, &ctx->cmd->handle.position.location, NULL, fmt, ## args)
+#define handle_position_error(ctx, fmt, args...) \
+	__stmt_binary_error(ctx, &ctx->cmd->handle.handle.location, &ctx->cmd->handle.position.location, fmt, ## args)
 
 static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
 				       const struct set *set,
@@ -2160,11 +2166,68 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	return 0;
 }
 
+static int rule_evaluate_cmd(struct eval_ctx *ctx)
+{
+	struct handle *handle = &ctx->cmd->handle;
+
+	/* allowed:
+	 * - insert [position] (no handle)
+	 * - add [position] (no handle)
+	 * - replace <handle> (no position)
+	 * - delete <handle> (no position)
+	 */
+
+	switch (ctx->cmd->op) {
+	case CMD_INSERT:
+		if (handle->handle.id && handle->position.id)
+			return handle_position_error(ctx, "use only `position'"
+						     " instead");
+
+		if (handle->handle.id)
+			return handle_error(ctx, "use `position' instead");
+		break;
+	case CMD_ADD:
+		if (handle->handle.id && handle->position.id)
+			return handle_position_error(ctx, "use only `position'"
+						     " instead");
+
+		if (handle->handle.id)
+			return handle_error(ctx, "use `position' instead");
+
+		break;
+	case CMD_REPLACE:
+		if (handle->handle.id && handle->position.id)
+			return handle_position_error(ctx, "use only `handle' "
+						     "instead");
+		if (handle->position.id)
+			return position_error(ctx, "use `handle' instead");
+		if (!handle->handle.id)
+			return cmd_error(ctx, "missing `handle'");
+		break;
+	case CMD_DELETE:
+		if (handle->handle.id && handle->position.id)
+			return handle_position_error(ctx, "use only `handle' "
+						     "instead");
+		if (handle->position.id)
+			return position_error(ctx, "use `handle' instead");
+		if (!handle->handle.id)
+			return cmd_error(ctx, "missing `handle'");
+		break;
+	default:
+		BUG("unkown command type %u\n", ctx->cmd->op);
+	}
+
+	return 0;
+}
+
 static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
 {
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
 
+	if (rule_evaluate_cmd(ctx) < 0)
+		return -1;
+
 	proto_ctx_init(&ctx->pctx, rule->handle.family);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
 
@@ -2345,8 +2408,11 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 			return ret;
 
 		return setelem_evaluate(ctx, &cmd->expr);
-	case CMD_OBJ_SET:
 	case CMD_OBJ_RULE:
+		if (rule_evaluate_cmd(ctx) < 0)
+			return -1;
+		/* fall through */
+	case CMD_OBJ_SET:
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_TABLE:
 		return 0;

