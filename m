From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 04/16] src: add table declaration to cache
Date: Mon,  6 Jul 2015 20:16:56 +0200
Message-ID: <1436206628-23894-5-git-send-email-pablo@netfilter.org>
References: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40430 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbbGFSLi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:38 -0400
In-Reply-To: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Declared table objects are added to the cache, thus we can reference objects
that come in this batch, but that are not yet available in the kernel. This
happens from the evaluation step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c6c6038..475eb16 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1881,6 +1881,19 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 	struct chain *chain;
 	struct set *set;
 
+	if (table_lookup(&ctx->cmd->handle) == NULL) {
+		if (table == NULL) {
+			table = table_alloc();
+			handle_merge(&table->handle, &ctx->cmd->handle);
+			table_add_hash(table);
+		} else {
+			table_add_hash(table_get(table));
+		}
+	}
+
+	if (ctx->cmd->table == NULL)
+		return 0;
+
 	ctx->table = table;
 	list_for_each_entry(set, &table->sets, list) {
 		handle_merge(&set->handle, &table->handle);
@@ -1912,8 +1925,6 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 			return 0;
 		return chain_evaluate(ctx, cmd->chain);
 	case CMD_OBJ_TABLE:
-		if (cmd->data == NULL)
-			return 0;
 		return table_evaluate(ctx, cmd->table);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
-- 
1.7.10.4

