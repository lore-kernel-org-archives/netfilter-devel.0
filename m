From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 11/14] src: add chain declarations to cache
Date: Mon, 10 Aug 2015 13:50:45 +0200
Message-ID: <1439207448-22485-12-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56023 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbbHJLpG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:45:06 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 0ae07b6..d2bab97 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1850,8 +1850,26 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 
 static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 {
+	struct table *table;
 	struct rule *rule;
 
+	table = table_lookup(&ctx->cmd->handle);
+	if (table == NULL)
+		return cmd_error(ctx, "Table '%s' does not exist",
+				 ctx->cmd->handle.table);
+
+	if (chain == NULL) {
+		if (chain_lookup(table, &ctx->cmd->handle) == NULL) {
+			chain = chain_alloc(NULL);
+			handle_merge(&chain->handle, &ctx->cmd->handle);
+			chain_add_hash(chain, table);
+		}
+		return 0;
+	} else {
+		if (chain_lookup(table, &chain->handle) == NULL)
+			chain_add_hash(chain_get(chain), table);
+	}
+
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		chain->hooknum = str2hooknum(chain->handle.family,
 					     chain->hookstr);
@@ -1913,8 +1931,6 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		handle_merge(&cmd->rule->handle, &cmd->handle);
 		return rule_evaluate(ctx, cmd->rule);
 	case CMD_OBJ_CHAIN:
-		if (cmd->data == NULL)
-			return 0;
 		return chain_evaluate(ctx, cmd->chain);
 	case CMD_OBJ_TABLE:
 		return table_evaluate(ctx, cmd->table);
-- 
1.7.10.4

