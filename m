From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/3] src/evaluate.c: improve rule management checks
Date: Wed, 23 Mar 2016 13:51:38 +0100
Message-ID: <145873749855.10004.10666252455830923605.stgit@nfdev2.cica.es>
References: <145873749309.10004.11477358360509958985.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39994 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754589AbcCWMvq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 08:51:46 -0400
In-Reply-To: <145873749309.10004.11477358360509958985.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Improve checks (and error reporting) for basic rule management operations.

This includes a fix for netfilter bug #965.

Netfilter bug: http://bugzilla.netfilter.org/show_bug.cgi?id=965
Reported-by: Jesper Sander Lindgren <sander.contrib@gmail.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/evaluate.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 473f014..de8302b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2160,11 +2160,59 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
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
+		if (handle->handle != 0)
+			return cmd_error(ctx, "Could not insert rule: handle "
+					 "not allowed.");
+		break;
+	case CMD_ADD:
+		if (handle->handle != 0)
+			return cmd_error(ctx, "Could not add rule: handle not "
+					 "allowed.");
+		break;
+	case CMD_REPLACE:
+		if (handle->position != 0)
+			return cmd_error(ctx, "Could not replace rule: "
+					 "position not allowed.");
+		if (handle->handle == 0)
+			return cmd_error(ctx, "Could not replace rule: missing"
+					 " handle.");
+		break;
+	case CMD_DELETE:
+		if (handle->position != 0)
+			return cmd_error(ctx, "Could not delete rule: position"
+					 " not allowed.");
+		if (handle->handle == 0)
+			return cmd_error(ctx, "Could not delete rule: missing "
+					 "handle.");
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
 
@@ -2345,8 +2393,11 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
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

