From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] evaluate: use table_lookup_global() from expr_evaluate_symbol()
Date: Mon, 14 Mar 2016 20:38:28 +0100
Message-ID: <1457984308-23864-2-git-send-email-pablo@netfilter.org>
References: <1457984308-23864-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32777 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbcCNTil (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 15:38:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BF3DE11481C
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 20:38:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A26CFDA383
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 20:38:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ACBAFDA38F
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 20:38:37 +0100 (CET)
In-Reply-To: <1457984308-23864-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If there's already a table 'test' defined in the kernel and you load
another table 'test' via `nft -f', table_lookup() returns the table
that already exists in the kernel, so if you look up for objects that
are defined in the file, nft bails out with 'Set does not exist'.

Use table_lookup_global() function returns the existing table that is
defined in the file and that it is set as context via
ctx->handle->table.

This is not a complete fix, we should splice the existing kernel objects
into the userspace declaration. We just need some way to identify what
objects are already in the kernel so we don't send them again (otherwise
we will hit EEXIST errors). I'll follow up with this full fix asap.

Anyway, this patch fixes this shell test:

I: [OK]         ./testcases/sets/cache_handling_0

So at least by now we have all shell test returning OK. I'll add more
tests to catch the case I describe above once it is fixed too.

Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 45d585d..1cd77cb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -155,6 +155,20 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
 	return 0;
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
 /*
  * Symbol expression: parse symbol and evaluate resulting expression.
  */
@@ -189,7 +203,7 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 		if (ret < 0)
 			return cmd_error(ctx, "Could not process rule: Cannot list sets");
 
-		table = table_lookup(&ctx->cmd->handle);
+		table = table_lookup_global(ctx);
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 ctx->cmd->handle.table);
@@ -2073,20 +2087,6 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 }
 
-static struct table *table_lookup_global(struct eval_ctx *ctx)
-{
-	struct table *table;
-
-	if (ctx->table != NULL)
-		return ctx->cmd->table;
-
-	table = table_lookup(&ctx->cmd->handle);
-	if (table == NULL)
-		return NULL;
-
-	return table;
-}
-
 static int setelem_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
 	struct table *table;
-- 
2.1.4

