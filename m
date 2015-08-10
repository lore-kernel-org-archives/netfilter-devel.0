From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 10/14] evaluate: add cmd_evaluate_rename()
Date: Mon, 10 Aug 2015 13:50:44 +0200
Message-ID: <1439207448-22485-11-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56016 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbbHJLpF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:45:05 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure the table that we want to rename already exist. This is required by
the follow up patch that that adds chains to the cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 239dde7..0ae07b6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1958,6 +1958,24 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 	}
 }
 
+static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
+{
+	struct table *table;
+
+	switch (cmd->obj) {
+	case CMD_OBJ_CHAIN:
+		table = table_lookup(&ctx->cmd->handle);
+		if (table == NULL) {
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 ctx->cmd->handle.table);
+		}
+		break;
+	default:
+		BUG("invalid command object type %u\n", cmd->obj);
+	}
+	return 0;
+}
+
 enum {
 	CMD_MONITOR_EVENT_ANY,
 	CMD_MONITOR_EVENT_NEW,
@@ -2051,7 +2069,9 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
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

