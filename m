From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] evaluate: display error on unexisting chain when listing
Date: Wed, 12 Aug 2015 19:26:31 +0200
Message-ID: <1439400392-30875-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56334 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153AbbHLRUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Aug 2015 13:20:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft list chain ip test output
<cmdline>:1:1-25: Error: Could not process rule: Chain 'output' does not exist
list chain ip test output
^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Applies on top of the cache-consolidation branch.

 src/evaluate.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d432826..937097a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1956,16 +1956,26 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 {
+	struct table *table;
+
 	switch (cmd->obj) {
 	case CMD_OBJ_TABLE:
 		if (cmd->handle.table == NULL)
 			return 0;
-	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_SET:
 		if (table_lookup(&cmd->handle) == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
 		return 0;
+	case CMD_OBJ_CHAIN:
+		table = table_lookup(&cmd->handle);
+		if (table == NULL)
+			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
+					 cmd->handle.table);
+		if (chain_lookup(table, &cmd->handle) == NULL)
+			return cmd_error(ctx, "Could not process rule: Chain '%s' does not exist",
+					 cmd->handle.chain);
+		return 0;
 	case CMD_OBJ_SETS:
 	case CMD_OBJ_RULESET:
 		return 0;
-- 
1.7.10.4

