From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: use existing table object from evaluation context
Date: Thu, 10 Sep 2015 01:59:28 +0200
Message-ID: <1441843168-5632-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60794 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbbIIXw6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 19:52:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Skip table object lookup if we are in the context of table declaration already,
ctx->table already points to the right table we have to use during the
evalution. Otherwise, a list corruption occurs when using the wrong table
object when it already exists in the kernel.

http://marc.info/?l=netfilter-devel&m=144179814209295&w=2

Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1405da8..22dd6d5 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1711,12 +1711,26 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 }
 
+static struct table *table_lookup_global(struct eval_ctx *ctx)
+{
+	struct table *table;
+
+	if (ctx->table != NULL)
+		return ctx->cmd->table;
+
+	table = table_lookup(&ctx->cmd->handle);
+	if (table == NULL)
+		return NULL;
+
+	return table;
+}
+
 static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct table *table;
 	struct set *set;
 
-	table = table_lookup(&ctx->cmd->handle);
+	table = table_lookup_global(ctx);
 	if (table == NULL)
 		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 				 ctx->cmd->handle.table);
@@ -1739,7 +1753,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	struct table *table;
 	const char *type;
 
-	table = table_lookup(&ctx->cmd->handle);
+	table = table_lookup_global(ctx);
 	if (table == NULL)
 		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 				 ctx->cmd->handle.table);
@@ -1857,9 +1871,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 	struct table *table;
 	struct rule *rule;
 
-	table = table_lookup(&ctx->cmd->handle);
+	table = table_lookup_global(ctx);
 	if (table == NULL)
-		return cmd_error(ctx, "Table '%s' does not exist",
+		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 				 ctx->cmd->handle.table);
 
 	if (chain == NULL) {
-- 
1.7.10.4

