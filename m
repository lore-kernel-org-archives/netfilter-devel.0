From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] evaluate: check if table and chain exists when adding rules
Date: Mon,  2 Nov 2015 12:55:05 +0100
Message-ID: <1446465306-3364-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55060 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbbKBLsD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Nov 2015 06:48:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Assuming a table 'test' that contains a chain 'test':

 # nft add rule test1 test2 counter
 <cmdline>:1:1-28: Error: Could not process rule: Table 'test1' does not exist
 add rule test1 test2 counter
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 # nft add rule test test2 counter
 <cmdline>:1:1-27: Error: Could not process rule: Chain 'test2' does not exist
 add rule test test2 counter
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4f9299e..ccbe8b3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2050,6 +2050,8 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 
 static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	struct table *table;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
 		return setelem_evaluate(ctx, &cmd->expr);
@@ -2058,6 +2060,15 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		return set_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
 		handle_merge(&cmd->rule->handle, &cmd->handle);
+		table = table_lookup_global(ctx);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 ctx->cmd->handle.table);
+
+		if (chain_lookup(table, &ctx->cmd->handle) == NULL)
+			return cmd_error(ctx, "Could not process rule: Chain '%s' does not exist",
+					 ctx->cmd->handle.chain);
+
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
 		return chain_evaluate(ctx, cmd->chain);
-- 
2.1.4

