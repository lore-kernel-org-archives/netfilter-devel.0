From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 13/16] evaluate: add cmd_evaluate_rename()
Date: Mon,  6 Jul 2015 20:17:05 +0200
Message-ID: <1436206628-23894-14-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40463 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbbGFSLo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:44 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure the table and the original chain that we want to rename already exist.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 91c4989..022e1ff 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1956,6 +1956,28 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table;
+	struct chain *chain;
+
+	switch (cmd->obj) {
+	case CMD_OBJ_CHAIN:
+		table = table_lookup(&ctx->cmd->handle);
+		if (table == NULL) {
+			return cmd_error(ctx, "Table '%s' does not exist",
+					 ctx->cmd->handle.table);
+		}
+		chain = chain_lookup(table, &ctx->cmd->handle);
+		if (chain == NULL)
+			return cmd_error(ctx, "Chain '%s' does not exist",
+					 ctx->cmd->handle.chain);
+		return 0;
+	default:
+		BUG("invalid command object type %u\n", cmd->obj);
+	}
+}
+
 enum {
 	CMD_MONITOR_EVENT_ANY,
 	CMD_MONITOR_EVENT_NEW,
@@ -2043,7 +2065,9 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_LIST:
 		return cmd_evaluate_list(ctx, cmd);
 	case CMD_FLUSH:
+		return 0;
 	case CMD_RENAME:
+		return cmd_evaluate_rename(ctx, cmd);
 	case CMD_EXPORT:
 	case CMD_DESCRIBE:
 		return 0;
-- 
1.7.10.4

